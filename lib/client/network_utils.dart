String appendQueryParameters(String baseUrl, Map<String, dynamic>? pathParams) {
  if (pathParams == null || pathParams.isEmpty) return baseUrl;

  final uri = Uri.parse(baseUrl);
  final newUri = uri.replace(
    queryParameters: {
      ...uri.queryParameters, // 保留原有的查询参数
      ...pathParams.map((key, value) => MapEntry(key, value.toString())),
    },
  );
  return newUri.toString();
}
