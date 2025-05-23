// 设备信息展示类
// 封装设备信息的类
import 'dart:io';

class DeviceInfo {
  final String serviceName;
  final String sn;
  final String target;
  final int port;
  final String ipAddress;

  var type = "NAS";

  DeviceInfo({
    required this.serviceName,
    required this.sn,
    required this.target,
    required this.port,
    required this.ipAddress,
  });

  // 从 Map 初始化 DeviceInfo 对象
  factory DeviceInfo.fromMap(Map<String, dynamic> map) {
    return DeviceInfo(
      serviceName: map['serviceName'] as String,
      sn: map['sn'] as String,
      target: map['target'] as String,
      port: map['port'] as int,
      ipAddress: map['ipAddress'] as String,
    );
  }

  @override
  String toString() {
    return 'DeviceInfo{serviceName: $serviceName, sn: $sn,  target: $target, port: $port, ipAddress: $ipAddress}';
  }
}
