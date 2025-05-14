// 配置管理

import 'dio_client.dart';
import 'http_client.dart';
import 'webrtc/webrtc_client.dart';

class NetworkConfig {
  static HttpClientType currentType = HttpClientType.dio;

  static String baseUrl = 'http://113.45.53.200:18050';
  static String localDeviceUrl = 'http://localhost:8080';

  static HttpClient getClient() {
    switch (currentType) {
      case HttpClientType.dio:
        return DioClient();
      case HttpClientType.webrtc:
        return WebRTCClient();
    }
  }
}

enum HttpClientType { webrtc, dio }
