import 'package:dio/dio.dart';

import 'network_config.dart';
import 'network_error.dart';
import 'network_utils.dart';

class AMCClient {
  static Future<Result<dynamic>> get({
    String? deviceIp,
    required String apiPath,
    Map<String, dynamic>? pathParams,
    Map<String, dynamic>? bodyParams,
    Map<String, dynamic>? headers,
  }) {
    String fullPath = rebuildUrl(deviceIp, apiPath, pathParams);
    return request(fullPath, bodyParams, headers, true);
  }

  static String rebuildUrl(
    String? deviceIp,
    String apiPath,
    Map<String, dynamic>? pathParams,
  ) {
    String baseUrl =
        deviceIp != null ? 'http://$deviceIp' : NetworkConfig.baseUrl;
    String fullPath = '$baseUrl$apiPath';
    fullPath = appendQueryParameters(fullPath, pathParams);
    return fullPath;
  }

  static Future<Result<dynamic>> post({
    String? deviceIp,
    required String apiPath,
    Map<String, dynamic>? pathParams,
    Map<String, dynamic>? bodyParams,
    Map<String, dynamic>? headers,
  }) {
    String fullPath = rebuildUrl(deviceIp, apiPath, pathParams);
    return request(fullPath, bodyParams, headers, true);
  }

  static String rebuildLocalUrl(
    String? deviceIp,
    String apiPath,
    Map<String, dynamic>? pathParams,
  ) {
    String baseUrl =
        deviceIp != null ? 'http://$deviceIp' : NetworkConfig.localDeviceUrl;
    String fullPath = '$baseUrl$apiPath';
    fullPath = appendQueryParameters(fullPath, pathParams);
    return fullPath;
  }

  static Future<Result<dynamic>> deviceGet({
    String? deviceIp,
    required String apiPath,
    Map<String, dynamic>? bodyParams,
    Map<String, dynamic>? pathParams,
    Map<String, dynamic>? headers,
  }) {
    String fullPath = rebuildLocalUrl(deviceIp, apiPath, pathParams);
    return request(fullPath, bodyParams, headers, false);
  }

  static Future<Result<dynamic>> devicePost({
    String? deviceIp,
    required String apiPath,
    Map<String, dynamic>? bodyParams,
    Map<String, dynamic>? pathParams,
    Map<String, dynamic>? headers,
  }) {
    String fullPath = rebuildLocalUrl(deviceIp, apiPath, pathParams);
    return request(fullPath, bodyParams, headers, true);
  }

  static Future<Result<dynamic>> request(
    String fullPath,
    Map<String, dynamic>? bodyParams,
    Map<String, dynamic>? headers,
    bool isPost,
  ) async {
    try {
      dynamic rawResponse;
      if (isPost) {
        rawResponse = await NetworkConfig.getClient().post(
          fullPath,
          bodyParams,
          headers,
        );
      } else {
        rawResponse = await NetworkConfig.getClient().get(
          fullPath,
          bodyParams,
          headers,
        );
      }
      if (rawResponse is Map<String, dynamic>) {
        // 将Map转换为自定义Response类
        final bool isSuccess = rawResponse['success'];
        if (isSuccess) {
          return Result.success(rawResponse);
        } else {
          return Result.failure(
            NetworkError(
              errorCode: rawResponse['errCode'],
              errorMessage: rawResponse['errMessage'],
            ),
          );
        }
      } else if (rawResponse is Response) {
        if (rawResponse.statusCode == 200 || rawResponse.statusCode == 201) {
          return Result.success(rawResponse.data);
        } else {
          return Result.failure(
            NetworkError(
              errorCode: rawResponse.statusCode ?? -1,
              errorMessage: rawResponse.data,
            ),
          );
        }
      } else {
        return Result.failure(
          NetworkError(errorCode: -2, errorMessage: "unknown data type"),
        );
      }
    } on DioException catch (e) {
      return Result.failure(
        NetworkError(
          errorCode: e.response?.statusCode ?? -1,
          errorMessage: '网络错误 response: ${e.response} ；message:${e.message}',
        ),
      );
    } catch (e) {
      return Result.failure(
        NetworkError(errorCode: -1, errorMessage: '发生异常: $e'),
      );
    }
  }
}

class Result<T> {
  final bool isSuccess;
  final T? data;
  final NetworkError? error;

  Result.success(this.data) : isSuccess = true, error = null;

  Result.failure(this.error) : isSuccess = false, data = null;
}
