import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/geolocator_util.dart';
import '../../../../domain/usecase/get_district_by_location_use_case.dart';

class LocationState {
  final GeoPoint? location;
  final String? district;
  final bool isLoading;
  final String? errorMessage;

  const LocationState({
    this.location,
    this.district,
    this.isLoading = false,
    this.errorMessage,
  });

  LocationState copyWith({
    GeoPoint? location,
    String? district,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LocationState(
      location: location ?? this.location,
      district: district ?? this.district,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class EnableLocationViewModel extends Notifier<LocationState> {
  @override
  LocationState build() => const LocationState();

  Future<void> fetchLocation() async {
    state = state.copyWith(isLoading: true);
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
        state = state.copyWith(
          isLoading: false,
          location: locationResult.geoPoint,
          district: '',
        );
        return;
      }

      state = state.copyWith(
        isLoading: false,
        district: district,
        location: locationResult.geoPoint,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: locationResult.errorMessage,
      );
    }
  }
}

final locationViewModelProvider =
    NotifierProvider<EnableLocationViewModel, LocationState>(
      EnableLocationViewModel.new,
    );
