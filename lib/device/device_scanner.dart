import 'dart:async';
import 'dart:io';

import 'package:multicast_dns/multicast_dns.dart';

import 'device_config.dart';
import 'device_info.dart';

class NasDeviceScanner {
  final MDnsClient _client = MDnsClient();
  StreamSubscription? _subscription;
  List<DeviceInfo> _devices = [];
  Function(List<DeviceInfo>)? _callback;
  bool _isScanning = false;

  bool get isScanning => _isScanning;

  /// 开始扫描
  Future<void> start(Function(List<DeviceInfo>) callback) async {
    if (_isScanning) {
      return;
    }
    _isScanning = true;
    _callback = callback;
    await _client!.start();

    const String nasServiceName = '_smb._tcp.local';
    _subscription = _client!
        .lookup<PtrResourceRecord>(
          ResourceRecordQuery.serverPointer(nasServiceName),
        )
        .listen(
          (PtrResourceRecord ptr) async {
            await for (final SrvResourceRecord srv in _client!
                .lookup<SrvResourceRecord>(
                  ResourceRecordQuery.service(ptr.domainName),
                )) {
              final String serviceName = ptr.domainName;
              final String sn = ptr.hashCode.toString();
              final String target = srv.target;
              final int port = srv.port;
              InternetAddress? ipAddress;
              // 先尝试获取 IPv4 地址
              await for (final IPAddressResourceRecord ip in _client!
                  .lookup<IPAddressResourceRecord>(
                    ResourceRecordQuery.addressIPv4(target),
                  )) {
                ipAddress = ip.address;
                break;
              }
              // 如果没有获取到 IPv4 地址，再尝试获取 IPv6 地址
              if (ipAddress == null) {
                await for (final IPAddressResourceRecord ip in _client!
                    .lookup<IPAddressResourceRecord>(
                      ResourceRecordQuery.addressIPv6(target),
                    )) {
                  ipAddress = ip.address;
                  break;
                }
              }

              final deviceInfo = DeviceInfo(
                serviceName: serviceName,
                sn: sn,
                target: target,
                port: port,
                ipAddress: ipAddress?.address ?? "",
              );
              _devices.add(deviceInfo);
            }
          },
          onDone: () {
            _isScanning = false;
            // 添加默认的设备地址
            _devices.add(DeviceConfig.defaultNasDevice);
            _callback?.call(_devices);
          },
        );
  }

  /// 停止扫描
  void stop() {
    if (!_isScanning) {
      return;
    }
    _isScanning = false;
    _subscription?.cancel();
    _client?.stop();
    _callback?.call(_devices);
  }
}
