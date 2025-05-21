import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_lingo/domain/usecase/save_user_to_database_usecase.dart';
import '../../../core/ui_validators/user_validator.dart';
import '../../../core/utils/geolocator_util.dart';
import '../../../domain/entity/app_user.dart';
import '../../../domain/usecase/get_district_by_location_use_case.dart';
import '../../user_global_view_model.dart';

class EditProfileState {
  final bool isSaving;
  final String? district;
  final GeoPoint? location;
  final String? profileImageUrl;
  final bool isUploadingImage;
  final String? errorMessage;

  const EditProfileState({
    this.isSaving = false,
    this.district,
    this.location,
    this.profileImageUrl,
    this.isUploadingImage = false,
    this.errorMessage,
  });

  EditProfileState copyWith({
    bool? isSaving,
    String? district,
    GeoPoint? location,
    String? profileImageUrl,
    bool? isUploadingImage,
    String? errorMessage,
  }) {
    return EditProfileState(
      isSaving: isSaving ?? this.isSaving,
      district: district ?? this.district,
      location: location ?? this.location,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isUploadingImage: isUploadingImage ?? this.isUploadingImage,
      errorMessage: errorMessage,
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
      final district = await ref
          .read(getDistrictByLocationUseCaseProvider)
          .execute(
            locationResult.geoPoint!.latitude,
            locationResult.geoPoint!.longitude,
          );

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

      final storage = FirebaseStorage.instance;
      final storageRef = storage.ref();
      final imageRef = storageRef.child(
        'profile_images/${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}',
      );

      await imageRef.putFile(File(imageFile.path));
      final imageUrl = await imageRef.getDownloadURL();

      state = state.copyWith(
        profileImageUrl: imageUrl,
        isUploadingImage: false,
      );
    } catch (e) {
      state = state.copyWith(isUploadingImage: false);
      rethrow;
    }
  }

  String? validateBio(String? bio) => UserValidator.validateBio(bio);
}

final editProfileViewModelProvider = NotifierProvider.autoDispose
    .family<EditProfileViewModel, EditProfileState, AppUser>(
      EditProfileViewModel.new,
    );
