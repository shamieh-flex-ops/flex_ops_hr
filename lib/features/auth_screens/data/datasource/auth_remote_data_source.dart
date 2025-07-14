import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flex_ops_hr/core/network/error_message_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flex_ops_hr/core/error/exceptions.dart';
import 'package:flex_ops_hr/core/network/api_constance.dart';
import 'package:flex_ops_hr/features/auth_screens/data/models/login_model.dart';
import 'package:flex_ops_hr/features/auth_screens/domain/usecases/change_password_usecase.dart';
import 'package:flex_ops_hr/features/auth_screens/domain/usecases/login_usecase.dart';

abstract class AuthRemoteDataSource {
  Future<LoginModel> login(LoginParams params);
  Future<MessageModel> changePassword(ChangePasswordParams params);
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<LoginModel> login(LoginParams params) async {
    try {
      final credentials = '${params.email}:${params.password}';
      final encodedCredentials = base64Encode(utf8.encode(credentials));

      final header = Options(
        headers: {
          'Authorization': 'Basic $encodedCredentials',
          'Content-Type': 'application/json',
        },
      );

      final response = await dio.get(
        ApiConstance.login,
        options: header,
      );

      return LoginModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<MessageModel> changePassword(ChangePasswordParams params) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final header = Options(
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    try {
      final response = await dio.post(
        ApiConstance.changePassword,
        data: params.toJson(),
        options: header,
      );
      return MessageModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  ServerException _handleError(dynamic e) {
    if (e is DioError && e.response?.data is Map<String, dynamic>) {
      final data = e.response!.data;
      final result = data['result'];
      final message = result is Map<String, dynamic> && result['error'] != null
          ? result['error']
          : 'Something went wrong with the server response.';

      return ServerException(
        messageModel: MessageModel(
          statusCode: e.response?.statusCode ?? 500,
          statusMessage: message,
          success: false,
        ),
      );
    } else {
      return const ServerException(
        messageModel: MessageModel(
          statusCode: 500,
          statusMessage: 'Unexpected error occurred.',
          success: false,
        ),
      );
    }
  }
}
