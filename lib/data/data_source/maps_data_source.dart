import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Utility for generating Google Maps-related URLs
class MapUrlUtil {
  /// Generates a Google Maps Static API URL for a given location
  ///
  /// If [location] is provided, centers the map on that location with a marker
  /// Otherwise, shows a default view of Korea
  static String getStaticMapUrl(GeoPoint? location) {
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';

    // Build query parameters based on location
    Map<String, dynamic> queryParams = {'size': '600x270', 'key': apiKey};

    if (location != null) {
      // Specific location parameters
      queryParams.addAll({
        'center': '${location.latitude},${location.longitude}',
        'zoom': '6',
        'markers': 'color:red|${location.latitude},${location.longitude}',
      });
    } else {
      // Default Korea view parameters
      queryParams.addAll({'center': '37.4979,127.0276', 'zoom': '5'});
    }

    // Convert params to query string
    final queryString = queryParams.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}')
        .join('&');

    // Return the complete URL
    return 'https://maps.googleapis.com/maps/api/staticmap?$queryString';
  }
}