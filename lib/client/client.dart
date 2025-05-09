import 'network_config.dart';

class AMCClient {
  static Future<dynamic> get(String urlPath, {Map<String, dynamic>? params}) {
    return NetworkConfig.getClient().get(
      NetworkConfig.baseUrl + urlPath,
      params: params,
    );
  }

  static Future<dynamic> post(String urlPath, {dynamic data}) {
    return NetworkConfig.getClient().post(
      NetworkConfig.baseUrl + urlPath,
      data: data,
    );
  }
}
