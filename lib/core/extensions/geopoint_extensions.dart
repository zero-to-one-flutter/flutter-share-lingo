import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

extension GeoPointExtensions on GeoPoint {
  /// Returns the distance from this point to [other] in kilometers, formatted like "3.2 km".
  double distanceFrom(GeoPoint other) {
    final distanceInMeters = Geolocator.distanceBetween(
      latitude,
      longitude,
      other.latitude,
      other.longitude,
    );
    return distanceInMeters / 1000;
  }
}
