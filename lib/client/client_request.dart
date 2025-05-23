// 定义抽象接口
import 'package:dio/dio.dart';

import 'client_result.dart';
import 'network_config.dart';
import 'network_error.dart';
import 'network_utils.dart';

class ClientRequest {
  Future<Result<dynamic>> post(
    String? deviceIp,
    String apiPath,
    Map<String, dynamic>? pathParams,
    Map<String, dynamic>? bodyParams,
    Map<String, dynamic>? headers,
  ) {
    final fullPath = rebuildUrl(deviceIp, apiPath, pathParams);
    return request(fullPath, bodyParams, headers, true);
  }

  Future<Result<dynamic>> get(
    String? deviceIp,
    String apiPath,
    Map<String, dynamic>? pathParams,
    Map<String, dynamic>? bodyParams,
    Map<String, dynamic>? headers,
  ) {
    final fullPath = rebuildUrl(deviceIp, apiPath, pathParams);
    return request(fullPath, bodyParams, headers, false);
  }

  Future<Result<dynamic>> request(
    String fullPath,
    Map<String, dynamic>? bodyParams,
    Map<String, dynamic>? headers,
    bool isPost,
  ) async {
    try {
      var rawResponse = await getResponse(
        isPost,
        fullPath,
        bodyParams,
        headers,
      );
      if (rawResponse is Map<String, dynamic>) {
        bool isSuccess = isResponseSuccess(rawResponse);
        if (isSuccess) {
          return Result.success(rawResponse);
        } else {
          final code = rawResponse['code'] ?? rawResponse['errCode'] ?? -1;
          final message =
              rawResponse['msg'] ??
              rawResponse['errorMessage'] ??
              rawResponse['message'] ??
              "unknown error message";
          return Result.failure(
            NetworkError(errorCode: code, errorMessage: message),
          );
        }
      } else if (rawResponse is Response) {
        if (rawResponse.statusCode == 200) {
          return Result.success(rawResponse.data);
        } else {
          return Result.failure(
            NetworkError(
              errorCode: rawResponse.statusCode.toString() ?? "-1",
              errorMessage: rawResponse.data,
            ),
          );
        }
      } else {
        return Result.failure(
          NetworkError(errorCode: "-2", errorMessage: "unknown data type"),
        );
      }
    } on DioException catch (e) {
      return Result.failure(
        NetworkError(
          errorCode: e.response?.statusCode.toString() ?? "-1",
          errorMessage: '网络错误 response: ${e.response} ；message:${e.message}',
        ),
      );
    } catch (e) {
      return Result.failure(
        NetworkError(errorCode: "-1", errorMessage: '发生异常: $e'),
      );
    }
  }

  Future<dynamic> getResponse(
    bool isPost,
    String fullPath,
    Map<String, dynamic>? bodyParams,
    Map<String, dynamic>? headers,
  ) async {
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
    return rawResponse;
  }

  String rebuildUrl(
    String? deviceIp,
    String apiPath,
    Map<String, dynamic>? pathParams,
  ) {
    String baseUrl = deviceIp != null ? 'http://$deviceIp' : getDefaultPath();
    String fullPath = '$baseUrl$apiPath';
    fullPath = appendQueryParameters(fullPath, pathParams);
    return fullPath;
  }

  String getDefaultPath() {
    return NetworkConfig.baseUrl;
  }

  bool isResponseSuccess(Map<String, dynamic> rawResponse) {
    final bool isSuccess = rawResponse['success'] ?? false;
    final String code = rawResponse['code'] ?? "-1";
    return code == "00000" || isSuccess;
  }
}
