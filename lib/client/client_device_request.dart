import 'client_request.dart';
import 'network_config.dart';

class ClientDeviceRequest extends ClientRequest {
  @override
  String getDefaultPath() {
    return NetworkConfig.localDeviceUrl;
  }
}