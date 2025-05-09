// Dio实现
import 'package:dio/dio.dart';

import 'http_client.dart';

class DioClient implements HttpClient {
  final Dio _dio = Dio();

  DioClient() {
    _setup();
  }

  void _setup() {
    // ('初始化完成');
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  @override
  Future<dynamic> get(String url, {Map<String, dynamic>? params}) async {
    final response = await _dio.get(
      url,
      queryParameters: params,
      options: Options(contentType: Headers.jsonContentType),
    );

    return response.data;
  }

  @override
  Future post(String url, {data}) async {
    final response = await _dio.post(
      url,
      data: data,
      options: Options(contentType: Headers.jsonContentType),
    );
    return response.data;
  }

  // 其他方法实现...
}
