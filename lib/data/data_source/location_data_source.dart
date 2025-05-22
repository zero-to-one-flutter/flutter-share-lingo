import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../core/exceptions/data_exceptions.dart';
import '../dto/vworld_district_dto.dart';

abstract class LocationDataSource {
  Future<String?> getDistrictByCoordinates(double latitude, double longitude);
}

class VworldLocationDataSource implements LocationDataSource {
  final Dio _dio;

  VworldLocationDataSource(this._dio);

  @override
  Future<String?> getDistrictByCoordinates(double latitude, double longitude) async {
    final vworldApiKey = dotenv.env['VWORLD_API_KEY'];
    if (vworldApiKey == null) {
      throw EnvFileException('VWORLD_API_KEY is not set in .env file');
    }

    try {
      final response = await _dio.get(
        '/data',
        queryParameters: {
          'request': 'GetFeature',
          'key': vworldApiKey,
          'data': 'LT_C_ADEMD_INFO',
          'geomFilter': 'POINT($longitude $latitude)',
          'geometry': false,
          'size': 100,
        },
      );

      if (response.statusCode == 200 &&
          response.data['response']['status'] == 'OK') {
        return VworldDistrictDto.fromJson(response.data)
            .response
            ?.result
            ?.featureCollection
            ?.features
            .first
            .properties
            ?.fullNm;
      }
      throw ApiException(statusCode: response.statusCode, data: response.data);
    } on DioException catch (e) {
      throw NetworkException(e.toString());
    }
  }
}
