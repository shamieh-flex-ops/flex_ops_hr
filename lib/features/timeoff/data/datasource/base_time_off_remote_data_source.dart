// lib/features/time_off/data/datasource/base_time_off_remote_data_source.dart

import 'package:flex_ops_hr/features/timeoff/data/models/time_off_message_response_model.dart';
import 'package:flex_ops_hr/features/timeoff/data/models/time_off_status_group_model.dart';
import 'package:flex_ops_hr/features/timeoff/domain/entities/create_time_off_params_entity.dart';
// <--- إضافة استيراد HolidayStatusIdModel
import 'package:flex_ops_hr/features/timeoff/data/models/holiday_status_id_model.dart';

abstract class BaseTimeOffRemoteDataSource {
  Future<List<TimeOffStatusGroupModel>> getTimeOffStatusGroups();
  Future<TimeOffMessageResponseModel> createTimeOff(CreateTimeOffParamsEntity params);

  Future<List<HolidayStatusIdModel>> getAvailableLeaveTypes();
}