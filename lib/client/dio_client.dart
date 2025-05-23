// Dio实现
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

import '../device_manager.dart';
import 'http_client.dart';

class DioClient implements HttpClient {
  final Dio _dio = Dio();

  DioClient() {
    _setup();
  }

  void _setup() {
    // _dio.interceptors.add(CookieManager(DeviceCookieManager.globalCookieJar));
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  @override
  Future<dynamic> get(
    String url,
    Map<String, dynamic>? bodyParams,
    Map<String, dynamic>? headers,
  ) async {
    final response = await _dio.get(
      url,
      queryParameters: bodyParams,
      options: Options(headers: headers, contentType: Headers.jsonContentType),
    );

    return response.data;
  }

  @override
  Future<dynamic> post(
    String url,
    Map<String, dynamic>? bodyParams,
    Map<String, dynamic>? headers,
  ) async {
    final response = await _dio.post(
      url,
      data: bodyParams,
      options: Options(headers: headers, contentType: Headers.jsonContentType),
    );
    return response.data;
  }
}
