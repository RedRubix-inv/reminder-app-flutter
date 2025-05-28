class HttpResponse {
  final int statusCode;
  final dynamic data;

  HttpResponse({required this.statusCode, required this.data});
}

class SuccessResponse extends HttpResponse {
  SuccessResponse({required super.statusCode, required super.data});
}

class ErrorResponse extends HttpResponse {
  ErrorResponse({required super.statusCode, required super.data});
}

class BaseHttpService {
  final String url = "https://reminder.redrubixin.com";
  final String path = "/api";
}
