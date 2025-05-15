import 'package:amc_nas_lib/client/client_device_request.dart';

import 'client_server_request.dart';
import 'network_error.dart';

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

  static Future<Result<dynamic>> deviceGet({
    String? deviceIp,
    required String apiPath,
    Map<String, dynamic>? bodyParams,
    Map<String, dynamic>? pathParams,
    Map<String, dynamic>? headers,
  }) {
    return ClientDeviceRequest().get(
      deviceIp,
      apiPath,
      pathParams,
      bodyParams,
      headers,
    );
  }

  static Future<Result<dynamic>> devicePost({
    String? deviceIp,
    required String apiPath,
    Map<String, dynamic>? bodyParams,
    Map<String, dynamic>? pathParams,
    Map<String, dynamic>? headers,
  }) {
    return ClientDeviceRequest().post(
      deviceIp,
      apiPath,
      pathParams,
      bodyParams,
      headers,
    );
  }
}

class Result<T> {
  final bool isSuccess;
  final T? data;
  final NetworkError? error;

  Result.success(this.data) : isSuccess = true, error = null;

  Result.failure(this.error) : isSuccess = false, data = null;
}
