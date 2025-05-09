// lib/webrtc_manager.dart
import 'dart:async';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WebRTCManager {
  RTCPeerConnection? _peerConnection;
  RTCDataChannel? _dataChannel;
  bool _isConnected = false;
  final void Function(String) onResponseUpdate;

  WebRTCManager({required this.onResponseUpdate});

  Future<void> initialize() async {
    try {
      final config = <String, dynamic>{
        'iceServers': [{'urls': 'stun:stun.l.google.com:19302'}]
      };

      _peerConnection = await createPeerConnection(config);
      
      // ICE候选处理
      _peerConnection!.onIceCandidate = (candidate) {
        // 实际应发送给远端
        print('ICE Candidate: ${candidate.candidate}');
      };

      _peerConnection!.onIceConnectionState = (state) {
        print('ICE Connection State: $state');
        if (state == RTCIceConnectionState.RTCIceConnectionStateConnected) {
          _isConnected = true;
        }
      };

      final channelConfig = RTCDataChannelInit();
      _dataChannel = await _peerConnection!
          .createDataChannel('dataChannel', channelConfig);

      _dataChannel!.onMessage = (message) {
        onResponseUpdate(message.text);
      };

      final offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);
      
      // 模拟远程应答（生产环境应通过信令服务器）
      await Future.delayed(Duration(seconds: 1));
      await _peerConnection!.setRemoteDescription(
        RTCSessionDescription(offer.sdp!, 'answer')
      );
    } catch (e) {
      onResponseUpdate('初始化失败: ${e.toString()}');
    }
  }

  Future<void> fetchData() async {
    if (!_isConnected) {
      onResponseUpdate('连接未建立');
      return;
    }

    try {
      final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos/1'))
        .timeout(Duration(seconds: 10));
      
      final data = jsonDecode(response.body);
      _dataChannel!.send(RTCDataChannelMessage(jsonEncode(data)));
    } on TimeoutException {
      onResponseUpdate('请求超时');
    } catch (e) {
      onResponseUpdate('数据传输失败: ${e.toString()}');
    }
  }

  Future<void> dispose() async {
    await _dataChannel?.close();
    await _peerConnection?.close();
  }
}
