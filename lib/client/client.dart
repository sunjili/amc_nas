import 'package:amc_nas_lib/client/client_device_request.dart';

import 'client_server_request.dart';
import 'client_result.dart';

class AMCClient {
  static Future<Result<dynamic>> get({
    String? deviceIp,
    required String apiPath,
    Map<String, dynamic>? pathParams,
    Map<String, dynamic>? bodyParams,
    Map<String, dynamic>? headers,
  }) {
    return ClientServerRequest().get(
      deviceIp,
      apiPath,
      pathParams,
      bodyParams,
      headers,
    );
  }

  static Future<Result<dynamic>> post({
    String? deviceIp,
    required String apiPath,
    Map<String, dynamic>? pathParams,
    Map<String, dynamic>? bodyParams,
    Map<String, dynamic>? headers,
  }) {
    return ClientServerRequest().post(
      deviceIp,
      apiPath,
      pathParams,
      bodyParams,
      headers,
    );
  }
}