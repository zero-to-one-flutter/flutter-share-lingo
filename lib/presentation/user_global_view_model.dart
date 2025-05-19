import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_lingo/core/extensions/geopoint_extensions.dart';

import '../domain/entity/app_user.dart';

class UserGlobalViewModel extends Notifier<AppUser?> {
  @override
  AppUser? build() => null;

  void setUser(AppUser user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }

  /// Calculates the distance in kilometers between the user's location and [otherLocation].
  /// Returns a formatted string like "3.2 km".
  String? calculateDistanceFrom(GeoPoint? otherLocation) {
    final userLocation = state?.location;
    if (userLocation == null || otherLocation == null) return null;
    return userLocation.distanceFrom(otherLocation);
  }

  void setName(String name) {
    state = state!.copyWith(name: name);
  }

  void setEmail(String email) {
    state = state!.copyWith(email: email);
  }

  void setProfileImage(String profileImage) {
    state = state!.copyWith(profileImage: profileImage);
  }

  void setNativeLanguage(String nativeLanguage) {
    state = state!.copyWith(nativeLanguage: nativeLanguage);
  }

  void setTargetLanguage(String targetLanguage) {
    state = state!.copyWith(targetLanguage: targetLanguage);
  }

  void setBio(String bio) {
    state = state!.copyWith(bio: bio);
  }

  void setBirthdate(DateTime birthdate) {
    state = state!.copyWith(birthdate: birthdate);
  }

  void setPartnerPreference(String partnerPreference) {
    state = state!.copyWith(partnerPreference: partnerPreference);
  }

  void setLanguageLearningGoal(String languageLearningGoal) {
    state = state!.copyWith(languageLearningGoal: languageLearningGoal);
  }

  void setDistrict(String district) {
    state = state!.copyWith(district: district);
  }

  void setLocation(GeoPoint location) {
    state = state!.copyWith(location: location);
  }
}

final userGlobalViewModelProvider =
    NotifierProvider<UserGlobalViewModel, AppUser?>(UserGlobalViewModel.new);
