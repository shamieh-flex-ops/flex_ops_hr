import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flex_ops_hr/core/network/api_constance.dart';

class DioHelper {
  final Dio dio;

  DioHelper(this.dio);

  Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    bool includeToken = true,
  }) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (includeToken) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null && token.isNotEmpty) {
        headers['token'] = token;
      }
    }

    return await dio.get(
      ApiConstance.baseUrl + url,
      queryParameters: query,
      options: Options(headers: headers),
    );
  }
}
