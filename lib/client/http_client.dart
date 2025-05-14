// 定义抽象接口
abstract class HttpClient {
  Future<dynamic> get(
    String url,
    Map<String, dynamic>? bodyParams,
    Map<String, dynamic>? headers,
  );

  Future<dynamic> post(
    String url,
    Map<String, dynamic>? bodyParams,
    Map<String, dynamic>? headers,
  );

  // // 定义 HttpClient 接口
  // Future<dynamic> deviceGet({
  //   String? deviceIp,
  //   required String apiPath,
  //   Map<String, dynamic>? bodyParams,
  //   Map<String, dynamic>? pathParams,
  // });
  //
  // Future<dynamic> devicePost({
  //   String? deviceIp,
  //   required String apiPath,
  //   Map<String, dynamic>? bodyParams,
  //   Map<String, dynamic>? pathParams,
  // });
}
