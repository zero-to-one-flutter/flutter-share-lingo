import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/core/providers/data_providers.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/domain/usecase/create_post_usecase.dart';
import 'package:share_lingo/domain/usecase/upload_image_usecase.dart';
import 'package:share_lingo/domain/usecase/update_post_usecase.dart';
import 'package:share_lingo/presentation/user_global_view_model.dart';

class PostWriteViewModel extends StateNotifier<AsyncValue<void>> {
  final CreatePostUseCase createPostUseCase;
  final UploadImageUseCase uploadImageUseCase;
  final UpdatePostUseCase updatePostUseCase;

  /// --- 투표 관련 상태 관리용 변수 ---
  bool _isPoll = false;
  String? _pollQuestion;
  List<String>? _pollOptions;

  PostWriteViewModel({
    required this.createPostUseCase,
    required this.uploadImageUseCase,
    required this.updatePostUseCase,
  }) : super(const AsyncData(null));

  Future<void> submitPost({
    required WidgetRef ref,
    required String uid,
    required String content,
    required List<String> tags,
    required List<Uint8List> imageBytesList,
  }) async {
    state = const AsyncLoading();

    try {
      final user = ref.read(userGlobalViewModelProvider);
      if (user == null) {
        state = AsyncError("유저 정보 없음", StackTrace.current);
        return;
      }

      final imageUrls = await Future.wait(
        imageBytesList.map(
          (imageBytes) => uploadImageUseCase(uid: uid, imageBytes: imageBytes),
        ),
      );

      final post = PostEntity(
        id: '',
        uid: uid,
        userName: user.name,
        userProfileImage: user.profileImage ?? '',
        userNativeLanguage: user.nativeLanguage ?? '',
        userTargetLanguage: user.targetLanguage ?? '',
        userDistrict: user.district,
        userLocation: user.location,
        userBio: user.bio,
        userBirthdate: user.birthdate,
        userHobbies: user.hobbies,
        userLanguageLearningGoal: user.languageLearningGoal,
        content: content,
        imageUrl: imageUrls,
        tags: tags,
        createdAt: DateTime.now(),
        likeCount: 0,
        commentCount: 0,
        deleted: false,

        isPoll: _isPoll,
        pollQuestion: _pollQuestion,
        pollOptions: _pollOptions,
        pollVotes: null, // 초기에는 투표 결과 없음
        userVotes: null, // 초기에는 유저 투표 없음
      );

      await createPostUseCase(post);
      state = const AsyncData(null);
    } catch (e, st) {
      if (mounted) {
        state = AsyncError(e, st);
      }
    }
  }

  Future<void> updatePost({
    required String id,
    required String content,
    required List<String> imageUrls,
    required List<String> tags,
  }) async {
    state = const AsyncLoading();
    try {
      final updateData = {
        'content': content,
        'imageUrl': imageUrls,
        'tags': tags,
      };
      final hasPoll =
          _pollQuestion?.isNotEmpty == true && _pollOptions?.isNotEmpty == true;
      if (hasPoll) {
        updateData.addAll({
          'isPoll': true,
          if (_pollQuestion != null) 'pollQuestion': _pollQuestion!,
          if (_pollOptions != null) 'pollOptions': _pollOptions!,
          'pollVotes': <String, int>{},
          'userVotes': <String, int>{},
        });
      } else {
        updateData.addAll({
          'isPoll': false,
          'pollQuestion': FieldValue.delete(),
          'pollOptions': FieldValue.delete(),
          'pollVotes': FieldValue.delete(),
          'userVotes': FieldValue.delete(),
        });
      }

      final docRef = FirebaseFirestore.instance.collection('posts').doc(id);
      await docRef.update(updateData);

      if (!mounted) return;
      state = const AsyncData(null);
    } catch (e, st) {
      if (mounted) {
        state = AsyncError(e, st);
      }
    }
  }

  /// --- 외부에서 호출할 수 있는 설정 메서드 ---
  void setPollData({required String question, required List<String> options}) {
    _isPoll = true;
    _pollQuestion = question;
    _pollOptions = options;
  }

  Future<void> deletePoll(String postId) async {
    state = const AsyncLoading();

    try {
      final docRef = FirebaseFirestore.instance.collection('posts').doc(postId);

      await docRef.update({
        'isPoll': false,
        'pollQuestion': FieldValue.delete(),
        'pollOptions': FieldValue.delete(),
        'pollVotes': FieldValue.delete(),
        'userVotes': FieldValue.delete(),
      });

      if (mounted) {
        state = const AsyncData(null);
      }
    } catch (e, st) {
      if (mounted) {
        state = AsyncError(e, st);
      }
    }
  }
}

final postWriteViewModelProvider =
    StateNotifierProvider.autoDispose<PostWriteViewModel, AsyncValue<void>>((
      ref,
    ) {
      final createUseCase = ref.read(createPostUseCaseProvider);
      final uploadUseCase = ref.read(uploadImageUseCaseProvider);
      final updateUseCase = ref.read(updatePostUseCaseProvider);
      return PostWriteViewModel(
        createPostUseCase: createUseCase,
        uploadImageUseCase: uploadUseCase,
        updatePostUseCase: updateUseCase,
      );
    });
