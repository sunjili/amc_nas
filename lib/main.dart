// main.dart
import 'package:flutter/material.dart';

import 'client/client.dart';
import 'webrtc_manager.dart';

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
  late WebRTCManager _webRTCManager;
  String _response = '';
  bool _isConnecting = true;

  @override
  void initState() {
    super.initState();
    // _initializeConnection();
  }

  Future<void> _initializeConnection() async {
    _webRTCManager = WebRTCManager(
      onResponseUpdate: (message) => _updateStatus(message),
    );
    await _webRTCManager.initialize();
    setState(() => _isConnecting = false);
  }

  void _updateStatus(String message) {
    if (mounted) setState(() => _response = message);
  }

  @override
  void dispose() {
    _webRTCManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WebRTC Client')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => {onFetchData()},
              child: Text(_isConnecting ? '连接中...' : '获取数据'),
            ),
            const SizedBox(height: 20),
            Text(
              '响应: $_response',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onFetchData() async {
    // _isConnecting ? null : _webRTCManager.fetchData;

    var result = await AMCClient.post(
     // "/api/v1/verifications/sms/verify",
     //  data: {
     //   "mobile": "18612984620",
     //    "code": "123456",
      "/api/v1/users/register-with-device",
      data: {
        "userRegisterCmd": {
          "nickname": "sssss",
          "password": "string",
          "mobile": "string",
          "verifyCode": "123456",
        },
        "deviceAddCmd": {
          "deviceName": "string",
          "serialNumber": "string",
          "ipAddress": "string",
          "port": 0,
          "macAddress": "string",
        },
      },
    );
    _updateStatus(result.toString());
  }
}
