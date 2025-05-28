import 'dart:convert';

import 'package:http/http.dart' as http;

import 'base_http_service.dart';

class EventService extends BaseHttpService {
  Future<HttpResponse> createEvent({
    required String title,
    required String time,
    required String frequency,
    required String description,
    required String startDate,
    required String endDate,
    required List<String> selectedDays,
    required String userId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$url$path/events'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'time': time,
          'frequency': frequency,
          'description': description,
          'start_date': startDate,
          'end_date': endDate,
          'selected_days': selectedDays,
          'user_id': userId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
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
      return ErrorResponse(statusCode: 500, data: {'error': e.toString()});
    }
  }

  Future<HttpResponse> getEvents(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$url$path/events/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
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
      return ErrorResponse(statusCode: 500, data: {'error': e.toString()});
    }
  }
}
