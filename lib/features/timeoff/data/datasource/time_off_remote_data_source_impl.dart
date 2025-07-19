// lib/features/timeoff/data/datasource/time_off_remote_data_source_impl.dart
import 'package:dio/dio.dart';
import 'package:flex_ops_hr/core/error/exceptions.dart';
import 'package:flex_ops_hr/core/network/api_constance.dart';
import 'package:flex_ops_hr/core/network/error_message_model.dart';

import 'package:flex_ops_hr/features/timeoff/data/datasource/base_time_off_remote_data_source.dart';
import 'package:flex_ops_hr/features/timeoff/data/models/create_time_off_params_model.dart';
import 'package:flex_ops_hr/features/timeoff/data/models/time_off_message_response_model.dart';
import 'package:flex_ops_hr/features/timeoff/data/models/time_off_status_group_model.dart';
import 'package:flex_ops_hr/features/timeoff/domain/entities/create_time_off_params_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flex_ops_hr/features/timeoff/data/models/holiday_status_id_model.dart';

class TimeOffRemoteDataSourceImpl implements BaseTimeOffRemoteDataSource {
  final Dio dio;

  TimeOffRemoteDataSourceImpl(this.dio);

  @override
  Future<List<TimeOffStatusGroupModel>> getTimeOffStatusGroups() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await dio.get(
        ApiConstance.timeOffState,
        options: Options(
          headers: {
            'token': token,
            'Content-Type': 'application/json',
          },
        ),
      );

      final result = response.data['result'] as List;
      return result.map((e) => TimeOffStatusGroupModel.fromJson(e)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<TimeOffMessageResponseModel> createTimeOff(
      CreateTimeOffParamsEntity params) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final createTimeOffModel = CreateTimeOffParamsModel.fromEntity(params);

      final response = await dio.post(
        ApiConstance.createTimeOff,
        data: createTimeOffModel.toJson(),
        options: Options(headers: {
          'token': token,
          'Content-Type': 'application/json',
        }),
      );

      final resultData = response.data;

      return TimeOffMessageResponseModel.fromJson(
          resultData['result'] ?? resultData);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<HolidayStatusIdModel>> getAvailableLeaveTypes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await dio.get(
        ApiConstance.leavesInfo,
        options: Options(
          headers: {
            'token': token,
            'Content-Type': 'application/json',
          },
        ),
      );

      final result = response.data['result'] as List;
      return result
          .map((json) =>
              HolidayStatusIdModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  ServerException _handleError(dynamic e) {
    if (e is DioException && e.response?.data is Map<String, dynamic>) {
      final data = e.response!.data;
      final result = data['result'];
      final message = result is Map<String, dynamic> && result['error'] != null
          ? result['error']
          : data['error'] ?? 'Something went wrong with the server response.';

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
