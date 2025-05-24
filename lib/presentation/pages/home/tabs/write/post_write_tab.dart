import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:share_lingo/core/providers/data_providers.dart';
import 'package:share_lingo/core/utils/snackbar_util.dart';
import 'package:share_lingo/domain/entity/post_entity.dart';
import 'package:share_lingo/presentation/pages/home/tabs/feed/feed_view_model.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/post_write_view_model.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/vote_state.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/widgets/cancel_button.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/widgets/poll_input_dialog.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/widgets/poll_preview_card.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/widgets/post_input_field.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/widgets/submit_button.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/widgets/tag_row_button.dart';
import 'package:share_lingo/presentation/pages/home/tabs/write/yolo_detection.dart';

import '../../../../user_global_view_model.dart';

class PostWriteTab extends ConsumerStatefulWidget {
  const PostWriteTab({super.key, this.post});

  final PostEntity? post;

  @override
  ConsumerState<PostWriteTab> createState() => _PostWriteTabState();
}

class _PostWriteTabState extends ConsumerState<PostWriteTab> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _contentController;
  final List<String> _selectedTags = [];
  final List<Uint8List> _selectedImages = [];
  late List<String> _existingImageUrls;

  final ImagePicker _picker = ImagePicker();
  final YoloDetection _yoloModel = YoloDetection();
  String? uiPollQuestion;
  List<String>? uiPollOptions;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(
      text: widget.post?.content ?? '',
    );
    _existingImageUrls = List.from(widget.post?.imageUrl ?? []);
    //투표 미리보기용 상태 초기화
    if (widget.post?.isPoll == true) {
      uiPollQuestion = widget.post?.pollQuestion;
      uiPollOptions = widget.post?.pollOptions;
    }
    //수정모드일 경우 기존 태그 불러오기
    if (widget.post?.tags != null && widget.post!.tags.isNotEmpty) {
      _selectedTags.addAll(widget.post!.tags);
    }
    Future.microtask(() async {
      try {
        if (!_yoloModel.isInitialized) {
          await _yoloModel.initialize();
        }
      } catch (e) {
        debugPrint('YOLO 모델 초기화 실패: $e');
        if (mounted) {
          SnackbarUtil.showSnackBar(context, 'AI 모델 초기화에 실패했습니다.');
        }
      }
    });
  }

  Future<void> _pickImage() async {
    final totalImages = _selectedImages.length + _existingImageUrls.length;
    if (totalImages >= 3) {
      if (!mounted) return;
      SnackbarUtil.showSnackBar(context, '이미지는 최대 3장까지 가능합니다.');
      return;
    }

    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) {
      if (!mounted) return;
      SnackbarUtil.showSnackBar(context, '이미지를 불러오지 못했습니다.');
      return;
    }

    try {
      if (!_yoloModel.isInitialized) {
        await _yoloModel.initialize();
      }

      final objects = _yoloModel.runInference(image);
      final hasPerson = objects.any(
        (e) => _yoloModel.label(e.labelIndex).toLowerCase() == 'person',
      );

      if (hasPerson) {
        if (!mounted) return;
        SnackbarUtil.showSnackBar(context, '사람이 감지된 이미지는 업로드할 수 없습니다.');
        return;
      }

      if (!mounted) return;
      setState(() {
        _selectedImages.add(bytes);
      });
    } catch (e) {
      debugPrint('YOLO 분석 실패: $e');
      if (!mounted) return;
      SnackbarUtil.showSnackBar(context, '이미지 분석 중 오류가 발생했습니다.');
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() != true) return;

    final content = _contentController.text.trim();
    if (content.isEmpty) return;

    final uid = FirebaseAuth.instance.currentUser?.uid ?? 'test-user';

    final newImageUrls = await Future.wait(
      _selectedImages.map(
        (bytes) => ref
            .read(uploadImageUseCaseProvider)
            .call(uid: uid, imageBytes: bytes),
      ),
    );

    final combinedImageUrls = [..._existingImageUrls, ...newImageUrls];
    if (uiPollQuestion != null && uiPollOptions != null) {
      ref
          .read(postWriteViewModelProvider.notifier)
          .setPollData(question: uiPollQuestion!, options: uiPollOptions!);
    }
    if (widget.post != null) {
      // 기존 투표 정보 무효화
      if (uiPollQuestion != null && uiPollOptions != null) {
        final postId = widget.post!.id;

        // 상태 리셋
        ref.read(voteStateProvider.notifier).reset(postId);

        // 빈 값으로 다시 설정 (선택도 초기화)
        ref
            .read(voteStateProvider.notifier)
            .set(
              postId,
              VoteState(
                pollVotes: {}, // 새로운 투표니까 초기화
                selectedIndex: null,
              ),
            );
      }
      // 수정 모드
      await ref
          .read(postWriteViewModelProvider.notifier)
          .updatePost(
            id: widget.post!.id,
            content: content,
            imageUrls: combinedImageUrls,
            tags: _selectedTags,
          );
      // 피드 데이터 무효화해서 새로 불러오게 함
      ref.invalidate(feedNotifierProvider);
      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }

    // 새 글 작성
    final postNotifier = ref.read(postWriteViewModelProvider.notifier);
    await postNotifier.submitPost(
      ref: ref,
      uid: uid,
      content: content,
      tags: _selectedTags.map((tag) => tag.replaceAll('#', '')).toList(),
      imageBytesList: _selectedImages,
    );

    if (!mounted) return;
    await ref.read(feedNotifierProvider(FeedQueryArg()).notifier).refresh();
    await ref
        .read(
          feedNotifierProvider(
            FeedQueryArg(uid: ref.read(userGlobalViewModelProvider)!.id),
          ).notifier,
        )
        .refresh();
    if (!mounted) return;

    _contentController.clear();
    _selectedImages.clear();
    _selectedTags.clear();
    setState(() {});

    SnackbarUtil.showSnackBar(context, '게시되었습니다');
    Navigator.of(context).pop(true);
  }

  void _cancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: CancelButton(onPressed: _cancel),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SubmitButton(onPressed: _submit),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                  top: 5,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        PostInputField(controller: _contentController),
                        const SizedBox(height: 16),
                        // 투표 미리보기 카드
                        if (uiPollQuestion != null && uiPollOptions != null)
                          PollPreviewCard(
                            question: uiPollQuestion!,
                            options: uiPollOptions!,
                            onDelete: () {
                              setState(() {
                                uiPollQuestion = null;
                                uiPollOptions = null;
                              });

                              ref
                                  .read(postWriteViewModelProvider.notifier)
                                  .setPollData(question: '', options: []);
                            },
                          ),
                        if (_existingImageUrls.isNotEmpty)
                          SizedBox(
                            height: 100,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _existingImageUrls.length,
                              separatorBuilder:
                                  (_, __) => const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    Image.network(
                                      _existingImageUrls[index],
                                      height: 100,
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _existingImageUrls.removeAt(index);
                                          });
                                        },
                                        child: const Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),

                        if (_selectedImages.isNotEmpty)
                          SizedBox(
                            height: 100,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _selectedImages.length,
                              separatorBuilder:
                                  (_, __) => const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                return Stack(
                                  children: [
                                    Image.memory(
                                      _selectedImages[index],
                                      height: 100,
                                    ),
                                    Positioned(
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedImages.removeAt(index);
                                          });
                                        },
                                        child: const Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),

                        const SizedBox(height: 16),
                        TagRowButton(
                          onTagSelected: (tag) {
                            if (!_selectedTags.contains(tag)) {
                              setState(() => _selectedTags.add(tag));
                            }
                          },
                          onPickImage: _pickImage,
                          onAddPoll: () {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => PollInputDialog(
                                    onConfirm: ({
                                      required question,
                                      required option1,
                                      required option2,
                                    }) {
                                      // UI 상태 갱신
                                      setState(() {
                                        uiPollQuestion = question;
                                        uiPollOptions = [option1, option2];
                                      });

                                      // 뷰모델에도 전달
                                      ref
                                          .read(
                                            postWriteViewModelProvider.notifier,
                                          )
                                          .setPollData(
                                            question: question,
                                            options: [option1, option2],
                                          );
                                    },
                                  ),
                            );
                          },
                        ),
                        if (_selectedTags.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children:
                                  _selectedTags.map((tag) {
                                    return Chip(
                                      label: Text(tag),
                                      onDeleted: () {
                                        setState(() {
                                          _selectedTags.remove(tag);
                                        });
                                      },
                                    );
                                  }).toList(),
                            ),
                          ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
