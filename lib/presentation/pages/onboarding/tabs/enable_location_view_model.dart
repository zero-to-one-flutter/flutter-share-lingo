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

      final (status, position) = await GeolocatorUtil.getPosition();

      switch (status) {
        case LocationStatus.success:
          state = state.copyWith(
            geoPoint: GeoPoint(position!.latitude, position.longitude),
            isLoading: false,
          );
          break;

        case LocationStatus.deniedTemporarily:
          state = state.copyWith(
            isLoading: false,
            errorMessage: '위치 권한이 거부되었습니다. 권한을 허용하거나, 위치 없이 진행해 주세요.',
          );
          break;

        case LocationStatus.deniedForever:
          state = state.copyWith(
            isLoading: false,
            errorMessage:
                '위치 권한이 완전히 차단되었습니다.\n설정 > 앱 > ShareLingo에서 권한을 허용하거나, 위치 없이 진행해 주세요.',
          );
          break;

        case LocationStatus.error:
          state = state.copyWith(
            isLoading: false,
            errorMessage: '위치 정보를 가져오는 중 오류가 발생했습니다. 다시 시도하거나, 위치 없이 진행해 주세요.',
          );
          break;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '위치 정보를 가져오는 중 오류가 발생했습니다. 다시 시도하거나, 위치 없이 진행해 주세요.',
      );
    }
  }
}

final locationViewModelProvider =
    NotifierProvider<EnableLocationViewModel, LocationState>(EnableLocationViewModel.new);
