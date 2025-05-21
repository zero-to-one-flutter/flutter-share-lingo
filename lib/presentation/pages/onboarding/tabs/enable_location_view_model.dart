import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/geolocator_util.dart';

class LocationState {
  final GeoPoint? geoPoint;
  final bool isLoading;
  final String? errorMessage;

  const LocationState({
    this.geoPoint,
    this.isLoading = false,
    this.errorMessage,
  });

  LocationState copyWith({
    GeoPoint? geoPoint,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LocationState(
      geoPoint: geoPoint ?? this.geoPoint,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class EnableLocationViewModel extends Notifier<LocationState> {
  @override
  LocationState build() => const LocationState();

  Future<void> fetchLocation() async {
    try {
      state = state.copyWith(isLoading: true);

      final locationResult = await GeolocatorUtil.handleLocationRequest();

      state = state.copyWith(
        isLoading: false,
        geoPoint: locationResult.geoPoint,
        errorMessage: locationResult.errorMessage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '위치 정보를 가져오는 중 오류가 발생했습니다. 다시 시도하거나, 위치 없이 진행해 주세요.',
      );
    }
  }
}

final locationViewModelProvider =
    NotifierProvider<EnableLocationViewModel, LocationState>(
      EnableLocationViewModel.new,
    );
