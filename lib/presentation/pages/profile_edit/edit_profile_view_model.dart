import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_lingo/domain/usecase/save_user_to_database_usecase.dart';
import 'package:share_lingo/domain/usecase/upload_image_use_case.dart';
import '../../../core/ui_validators/user_validator.dart';
import '../../../core/utils/geolocator_util.dart';
import '../../../domain/entity/app_user.dart';
import '../../../domain/usecase/get_district_by_location_use_case.dart';
import '../../user_global_view_model.dart';

class EditProfileState {
  final bool isSaving;
  final bool isUploadingImage;
  final String? errorMessage;
  final String? district;
  final GeoPoint? location;
  final String? profileImageUrl;
  final String? nativeLanguage;
  final String? targetLanguage;

  const EditProfileState({
    this.isSaving = false,
    this.isUploadingImage = false,
    this.errorMessage,
    this.district,
    this.location,
    this.profileImageUrl,
    this.nativeLanguage,
    this.targetLanguage,
  });

  EditProfileState copyWith({
    bool? isSaving,
    bool? isUploadingImage,
    String? errorMessage,
    String? district,
    GeoPoint? location,
    String? profileImageUrl,
    String? nativeLanguage,
    String? targetLanguage,
  }) {
    return EditProfileState(
      isSaving: isSaving ?? this.isSaving,
      isUploadingImage: isUploadingImage ?? this.isUploadingImage,
      errorMessage: errorMessage,
      district: district ?? this.district,
      location: location ?? this.location,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      nativeLanguage: nativeLanguage ?? this.nativeLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
    );
  }
}

class EditProfileViewModel
    extends AutoDisposeFamilyNotifier<EditProfileState, AppUser> {
  @override
  EditProfileState build(AppUser user) {
    return EditProfileState(
      district: user.district,
      location: user.location,
      profileImageUrl: user.profileImage,
      nativeLanguage: user.nativeLanguage,
      targetLanguage: user.targetLanguage,
    );
  }

  Future<void> saveProfile(AppUser updatedUser) async {
    state = state.copyWith(isSaving: true);
    try {
      // 이미지가 업데이트되었으면 이를 포함
      final finalUser =
          state.profileImageUrl != arg.profileImage
              ? updatedUser.copyWith(profileImage: state.profileImageUrl)
              : updatedUser;

      await ref.read(saveUserToDatabaseUseCaseProvider).execute(finalUser);
      ref.read(userGlobalViewModelProvider.notifier).setUser(finalUser);
      state = state.copyWith(isSaving: false);
    } catch (e) {
      state = state.copyWith(isSaving: false);
      rethrow; // 에러를 UI에서 처리할 수 있도록 다시 던짐
    }
  }

  Future refreshDistrict() async {
    final locationResult = await GeolocatorUtil.handleLocationRequest();

    if (locationResult.geoPoint != null) {
      final String? district;
      try {
        district = await ref
            .read(getDistrictByLocationUseCaseProvider)
            .execute(
              locationResult.geoPoint!.latitude,
              locationResult.geoPoint!.longitude,
            );
      } catch (e) {
        state = state.copyWith(location: locationResult.geoPoint, district: '');
        return;
      }

      state = state.copyWith(
        district: district,
        location: locationResult.geoPoint,
      );
    } else {
      // Optionally handle the error message
      state = state.copyWith(errorMessage: locationResult.errorMessage);
    }
  }

  Future<void> updateProfileImage(XFile imageFile) async {
    try {
      state = state.copyWith(isUploadingImage: true);

      final imageUrl = await ref
          .read(uploadImageFileUseCaseProvider)
          .execute(File(imageFile.path), arg.id, 'profile_images');

      state = state.copyWith(
        isUploadingImage: false,
        profileImageUrl: imageUrl,
      );
    } catch (e) {
      state = state.copyWith(isUploadingImage: false);
      rethrow;
    }
  }

  void setNativeLanguage(String lang) {
    state = state.copyWith(nativeLanguage: lang);
  }

  void setTargetLanguage(String lang) {
    state = state.copyWith(targetLanguage: lang);
  }

  String? validateBio(String? bio) => UserValidator.validateBio(bio);

  String? validateLanguageLearningGoal(String? goal) =>
      UserValidator.validateGoal(goal);
}

final editProfileViewModelProvider = NotifierProvider.autoDispose
    .family<EditProfileViewModel, EditProfileState, AppUser>(
      EditProfileViewModel.new,
    );
