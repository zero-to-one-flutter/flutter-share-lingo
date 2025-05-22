import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

enum LocationStatus { success, deniedTemporarily, deniedForever, error }

typedef LocationFetchResult = ({GeoPoint? geoPoint, String? errorMessage});

abstract class GeolocatorUtil {
  static Future<(LocationStatus, Position?)> getPosition() async {
    try {
      final permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        final requested = await Geolocator.requestPermission();

        if (requested == LocationPermission.denied) {
          return (LocationStatus.deniedTemporarily, null);
        }

        if (requested == LocationPermission.deniedForever) {
          return (LocationStatus.deniedForever, null);
        }
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 100,
        ),
      );

      return (LocationStatus.success, position);
    } catch (e) {
      log('위치 정보 가져오기 오류');
      return (LocationStatus.error, null);
    }
  }

  /// Handles location permission flow and returns either a GeoPoint or an error message.
  static Future<LocationFetchResult> handleLocationRequest() async {
    try {
      final (status, position) = await GeolocatorUtil.getPosition();

      switch (status) {
        case LocationStatus.success:
          return (
            geoPoint: GeoPoint(position!.latitude, position.longitude),
            errorMessage: null,
          );

        case LocationStatus.deniedTemporarily:
          return (
            geoPoint: null,
            errorMessage: '위치 권한이 거부되었습니다. 권한을 허용하거나, 위치 없이 진행해 주세요.',
          );

        case LocationStatus.deniedForever:
          return (
            geoPoint: null,
            errorMessage:
                '위치 권한이 완전히 차단되었습니다.\n설정 > 앱 > ShareLingo에서 권한을 허용하거나, 위치 없이 진행해 주세요.',
          );

        case LocationStatus.error:
          return (
            geoPoint: null,
            errorMessage: '위치 정보를 가져오는 중 오류가 발생했습니다. 다시 시도하거나, 위치 없이 진행해 주세요.',
          );
      }
    } catch (e) {
      return (
        geoPoint: null,
        errorMessage: '위치 정보를 가져오는 중 오류가 발생했습니다. 다시 시도하거나, 위치 없이 진행해 주세요.',
      );
    }
  }
}
