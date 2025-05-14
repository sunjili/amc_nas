// 设备信息展示类
// 封装设备信息的类
import 'dart:io';

class DeviceInfo {
  final String serviceName;
  final String target;
  final int port;
  final InternetAddress? ipAddress;

  var type = "NAS";

  DeviceInfo({
    required this.serviceName,
    required this.target,
    required this.port,
    this.ipAddress,
  });

  // 从 Map 初始化 DeviceInfo 对象
  factory DeviceInfo.fromMap(Map<String, dynamic> map) {
    return DeviceInfo(
      serviceName: map['serviceName'] as String,
      target: map['target'] as String,
      port: map['port'] as int,
      ipAddress: map['ipAddress'] as InternetAddress?,
    );
  }

  @override
  String toString() {
    return 'DeviceInfo{serviceName: $serviceName, target: $target, port: $port, ipAddress: ${ipAddress?.address}}';
  }
}
