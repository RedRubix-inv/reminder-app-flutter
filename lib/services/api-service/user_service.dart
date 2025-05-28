import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:reminder_app/services/api-service/base_http_service.dart';

class UserService extends BaseHttpService {
  Future<HttpResponse> createUser({
    required String userId,
    required String name,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$url$path/users'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId, 'name': name}),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return SuccessResponse(
          statusCode: response.statusCode,
          data: jsonDecode(response.body),
        );
      } else {
        return ErrorResponse(
          statusCode: response.statusCode,
          data: jsonDecode(response.body),
        );
      }
    } catch (e) {
      return ErrorResponse(statusCode: 500, data: {'message': e.toString()});
    }
  }
}
