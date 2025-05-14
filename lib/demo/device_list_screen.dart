import 'package:flutter/material.dart';

import '../device/device_info.dart';
import '../device/device_scanner.dart';

class DeviceListScreen extends StatefulWidget {
  const DeviceListScreen({Key? key}) : super(key: key);

  @override
  State<DeviceListScreen> createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  final NasDeviceScanner _scanner = NasDeviceScanner();
  List<DeviceInfo> _devices = [];
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  @override
  void dispose() {
    _scanner.stop();
    super.dispose();
  }

  // 开始扫描
  void _startScan() {
    setState(() {
      _isScanning = true;
      _devices = [];
    });
    _scanner.start((devices) {
      setState(() {
        _devices = devices;
        _isScanning = _scanner.isScanning;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('发现的设备'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isScanning ? null : _startScan,
            tooltip: '重新扫描',
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isScanning) const LinearProgressIndicator(),
          Expanded(
            child:
                _devices.isEmpty
                    ? const Center(child: Text('未发现设备'))
                    : ListView.builder(
                      itemCount: _devices.length,
                      itemBuilder: (context, index) {
                        final device = _devices[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ListTile(
                            title: Text(device.serviceName),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (device.ipAddress != null)
                                  Text('IP: ${device.ipAddress}'),
                                if (device.port != null)
                                  Text('端口: ${device.port}'),
                                if (device.target != null)
                                  Text('target: ${device.target}'),
                              ],
                            ),
                            trailing: const Icon(Icons.device_hub),
                            onTap: () => _showDeviceDetails(device),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  // 显示设备详情
  void _showDeviceDetails(DeviceInfo device) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(device.serviceName),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('设备信息'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('类型: ${device.type}'),
                      if (device.ipAddress != null)
                        Text('主机: ${device.ipAddress}'),
                      if (device.port != null) Text('端口: ${device.port}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('关闭'),
            ),
          ],
        );
      },
    );
  }
}
