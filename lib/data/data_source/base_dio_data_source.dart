import 'package:dio/dio.dart';

abstract class BaseDioDataSource {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: '',
      validateStatus: (status) => true,
      connectTimeout: const Duration(seconds: 6),
      receiveTimeout: const Duration(seconds: 6),
    ),
  );

  Dio get dio => _dio;
}