class NetworkResponse {
  final int statusCode;
  final bool isSuccess;
  final dynamic response;
  final String? errorMsg;

  NetworkResponse(
      {required this.statusCode,
      required this.isSuccess,
      this.response,
      this.errorMsg = 'Something went wrong'});
}
