// lib/features/resignation/data/datasources/resignation_remote_data_source.dart

import 'package:dio/dio.dart';
import 'package:flex_ops_hr/features/resignation/data/models/create_resignation_model.dart';
import 'package:flex_ops_hr/features/resignation/domain/usecases/create_resignation_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flex_ops_hr/core/error/exceptions.dart';
import 'package:flex_ops_hr/core/network/api_constance.dart';
import 'package:flex_ops_hr/core/network/error_message_model.dart';
import 'package:flex_ops_hr/features/resignation/data/models/resignation_model.dart';

abstract class ResignationRemoteDataSource {
  Future<List<ResignationGroupModel>> getResignationGroups();
    Future<CreateResignationResponseModel> createResignation(CreateResignationParams resignation);

}

class ResignationRemoteDataSourceImpl implements ResignationRemoteDataSource {
  final Dio dio;

  ResignationRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<ResignationGroupModel>> getResignationGroups() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await dio.get(
        ApiConstance.resignations,
        options: Options(
          headers: {
            'token': token,
            'Content-Type': 'application/json',
          },
        ),
      );

      final result = response.data['result'] as List;
      return result.map((e) => ResignationGroupModel.fromJson(e)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

 @override
  Future<CreateResignationResponseModel> createResignation(CreateResignationParams resignation) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await dio.post(
        ApiConstance.createResignation,
        data: {
          "notice_period": resignation.noticePeriod,
          "leave_date": resignation.leaveDate,
          "note": resignation.note,
          "document": resignation.document,
        },
        options: Options(headers: {'token': token}),
      );
print(response.data);
      return CreateResignationResponseModel.fromJson(response.data);
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
