import 'dart:io';

import 'device_info.dart';

class DeviceConfig {
  // 默认的设备地址 107069wbsd854.vicp.fun:8800
  static DeviceInfo defaultNasDevice = DeviceInfo(
    serviceName: 'AI NAS',
    target: 'Default Target',
    port: 8800,
    ipAddress: InternetAddress('107069wbsd854.vicp.fun'),
  );
}
