// main.dart
import 'dart:io';

import 'package:amc_nas_lib/client/client_device.dart';
import 'package:amc_nas_lib/device/device_config.dart';
import 'package:flutter/material.dart';

import 'client/client.dart';
import 'device_manager.dart';
import 'demo/device_list_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NAS Client',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const WebRTCClientPage(),
    );
  }
}

class WebRTCClientPage extends StatefulWidget {
  const WebRTCClientPage({super.key});

  @override
  State<WebRTCClientPage> createState() => _WebRTCClientPageState();
}

class _WebRTCClientPageState extends State<WebRTCClientPage> {
  String _response = '';

  @override
  void initState() {
    super.initState();
    // _initializeConnection();
  }

  // Future<void> _initializeConnection() async {
  //   _webRTCManager = WebRTCManager(
  //     onResponseUpdate: (message) => _updateStatus(message),
  //   );
  //   await _webRTCManager.initialize();
  //   setState(() => _isConnecting = false);
  // }

  void _updateStatus(String message) {
    if (mounted) setState(() => _response = message);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => {onFetchData()},
              child: Text('获取数据'),
            ),
            const SizedBox(height: 20),
            Text(
              '响应: $_response',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            ElevatedButton(
              onPressed: () {
                onScanDevice();
              },
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('开始扫描设备', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onFetchData() async {
    // var result = await AMCClient.post(
    //   apiPath: "/api/v1/verifications/sms",
    //   bodyParams: {"mobile": "18612984620"},
    // );
    // "/api/v1/verifications/sms/verify",
    //  data: {
    //   "mobile": "18612984620",
    // "/api/v1/users/register-with-device",
    // data: {
    //   "userRegisterCmd": {
    //     "nickname": "sssss",
    //     "password": "string",
    //     "mobile": "string",
    //     "verifyCode": "123456",
    //   },
    //   "deviceAddCmd": {
    //     "deviceName": "string",
    //     "serialNumber": "string",
    //     "ipAddress": "string",
    //     "port": 0,
    //     "macAddress": "string",
    //   },
    // },
    // );
    // deviceIp: "107069wbsd854.vicp.fun:8800",
    //
    // http://107069wbsd854.vicp.fun:8800/api/v1.0/app_center_info.cgi
    // deviceIp: "219.134.221.113:8800",
    //
    var result = await AMCDeviceClient.post(
      // apiPath: "/api/v1.0/get_disk_grpinfo.cgi",
      apiPath: "/api/v1.0/register.cgi",
      bodyParams: {
        "username": "13713716411",
        "password": "123456",
        "role": 0,
        "create_time": "2025-04-17T03:10:59.969Z",
      },
    );

    // var result = await AMCClient.devicePost(
    //   deviceIp: "107069wbsd854.vicp.fun:8800",
    //   // apiPath: "/api/v1.0/get_disk_grpinfo.cgi",
    //   apiPath: "/api/v1.0/login.cgi",
    //   // apiPath: "/api/v1.0/register.cgi",
    //   bodyParams: {
    //     "username": "13713716411",
    //     "password": "123456",
    //     // "role": 0,
    //     // "create_time": "2025-04-17T03:10:59.969Z",
    //   },
    // );

    // {"code":"00000","data":{"access_token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjbGllbnRJZCI6IndlYiIsImV4cCI6MTc0NzkxOTI0OSwiaWF0IjoxNzQ3OTE1NjQ5LCJ0eXBlIjoiYWNjZXNzIiwidXNlcm5hbWUiOiIxMzcxMzcxNjQxMSJ9.zryXN5ewF5O-sKPtpehhfKg73e_THEv0h_76o-iYwRY",
    // "refresh_token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjbGllbnRJZCI6IndlYiIsImV4cCI6MTc1MDUwNzY0OSwiaWF0IjoxNzQ3OTE1NjQ5LCJ0eXBlIjoicmVmcmVzaCIsInVzZXJuYW1lIjoiMTM3MTM3MTY0MTEifQ.UW5iu5Lm7bxzrVbEa_BY1brbhaDelp_hqLMG82E7ARk","username":"13713716411"},
    // "msg":"User operation successful","request_id":"USER_OK_0196f7e43249_fe8427b9","timestamp":1747915649,"version":"v1.0"}
    var result2 = await AMCDeviceClient.login(
      DeviceConfig.defaultNasDevice,
      "13713716411",
      "123456",
    );
    String status = result.data.toString();
    debugPrint("sssss result.isSucess: ${result.isSuccess}");
    if (result2.isSuccess) {
      final data = (result.data as Map<String, dynamic>?)?["data"];
      final accessToken = data?["access-token"];
      final refreshToken = data?["refresh-token"];
      Future.delayed(const Duration(seconds: 5), () {
        getDeviceInfo(accessToken, refreshToken);
      });
    } else {
      status = result.error.toString();
    }
    _updateStatus(status);
  }

  String apiDomain = "107069wbsd854.vicp.fun:8800"; // 你的 API 域名，不带协议

  Future<void> getDeviceInfo(accessToken, refreshToken) async {
    var result = await AMCDeviceClient.get(
      apiPath: "/api/v1.0/get_disk_grpinfo.cgi",
    );
    debugPrint("getDeviceInfo result: $result");
    _updateStatus(result.toString());
  }

  onScanDevice() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DeviceListScreen()),
    );
  }
}
