import 'dart:io';

import 'device_info.dart';

class DeviceConfig {
  // 默认的设备地址 107069wbsd854.vicp.fun:8800
  static String defaultAddress = '107069wbsd854.vicp.fun';

  static DeviceInfo defaultNasDevice = DeviceInfo(
    serviceName: 'AI NAS',
    sn: '',
    target: 'Default Target',
    port: 58002,
    ipAddress: defaultAddress,
  );
}
