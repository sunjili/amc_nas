// 定义抽象接口
abstract class HttpClient {
  Future<dynamic> get(String url, {Map<String, dynamic>? params});

  Future<dynamic> post(String url, {dynamic data});
  // 其他HTTP方法...
}
