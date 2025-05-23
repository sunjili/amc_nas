import 'package:amc_nas_lib/client/client_device_request.dart';

import 'network_error.dart';

class Result<T> {
  final bool isSuccess;
  final T? data;
  final NetworkError? error;

  Result.success(this.data) : isSuccess = true, error = null;

  Result.failure(this.error) : isSuccess = false, data = null;
}
