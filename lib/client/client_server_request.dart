import 'client_request.dart';
import 'network_config.dart';

class ClientServerRequest extends ClientRequest {
  @override
  String getDefaultPath() {
    return NetworkConfig.baseUrl;
  }
}
