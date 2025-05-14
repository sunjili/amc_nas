import 'dart:io';

import 'device_info.dart';

class DeviceConfig {
  // 默认的设备地址
  static DeviceInfo defaultNasDevice = DeviceInfo(
    serviceName: 'AI NAS',
    target: 'Default Target',
    port: 8080,
    ipAddress: InternetAddress('192.168.0.1'),
  );
}
