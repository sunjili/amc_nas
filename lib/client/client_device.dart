import 'package:amc_nas_lib/client/client_device_request.dart';
import 'package:amc_nas_lib/device_manager.dart';
import 'package:amc_nas_lib/utils.dart';
import '../device/device_config.dart';
import '../device/device_info.dart';
import 'client_result.dart';

class AMCDeviceClient {
  static Future<Result<dynamic>> login(
    DeviceInfo info,
    String userName,
    String password,
  ) async {
    DeviceConfig.defaultNasDevice = info;
    var result = await post(
      deviceIp: "${info.ipAddress}:${info.port}",
      apiPath: "/api/v1.0/login.cgi",
      bodyParams: {"username": userName, "password": password},
    );
    if (result.isSuccess) {
      final data = (result.data as Map<String, dynamic>?)?["data"];
      DeviceRequestManager.accessToken = data?["access-token"];
      DeviceRequestManager.refreshToken = data?["refresh-token"];
    }
    return result;
  }

  static Future<Result<dynamic>> get({
    String? deviceIp,
    required String apiPath,
    Map<String, dynamic>? bodyParams,
    Map<String, dynamic>? pathParams,
    Map<String, dynamic>? headers,
  }) {
    return ClientDeviceRequest().get(
      createFinalIp(deviceIp),
      apiPath,
      pathParams,
      bodyParams,
      createFinalHeader(headers),
    );
  }

  static Future<Result<dynamic>> post({
    String? deviceIp,
    required String apiPath,
    Map<String, dynamic>? bodyParams,
    Map<String, dynamic>? pathParams,
    Map<String, dynamic>? headers,
  }) {
    return ClientDeviceRequest().post(
      createFinalIp(deviceIp),
      apiPath,
      pathParams,
      bodyParams,
      createFinalHeader(headers),
    );
  }

  static Map<String, dynamic> createFinalHeader(Map<String, dynamic>? header) {
    final finalHeader = header ?? <String, dynamic>{};
    finalHeader["access-token"] = DeviceRequestManager.accessToken;
    finalHeader["refresh-token"] = DeviceRequestManager.refreshToken;
    return finalHeader;
  }

  static String? createFinalIp(String? deviceIp) {
    if (StringUtils.isNullOrEmpty(deviceIp)) {
      DeviceInfo info = DeviceConfig.defaultNasDevice;
      deviceIp = "${info.ipAddress}:${info.port}";
    }
    return deviceIp;
  }
}
