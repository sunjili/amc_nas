// 自定义网络错误类
class NetworkError {
  final String errorCode;
  final String errorMessage;

  NetworkError({required this.errorCode, required this.errorMessage});

  @override
  String toString() {
    return 'NetworkError{errorCode: $errorCode, errorMessage: $errorMessage}';
  }
}
