// lib/features/time_off/domain/repository/base_time_off_repository.dart
import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/failure.dart';

import 'package:flex_ops_hr/features/timeoff/domain/entities/create_time_off_params_entity.dart';
import 'package:flex_ops_hr/features/timeoff/domain/entities/holiday_status_id_entity.dart';
import 'package:flex_ops_hr/features/timeoff/domain/entities/time_off_message_response_entity.dart';
import 'package:flex_ops_hr/features/timeoff/domain/entities/time_off_status_group_entity.dart';

abstract class BaseTimeOffRepository {
  Future<Either<Failure, List<TimeOffStatusGroupEntity>>> getTimeOffStatusGroups();
  Future<Either<Failure, TimeOffMessageResponseEntity>> createTimeOff(CreateTimeOffParamsEntity params);
  Future<Either<Failure, List<HolidayStatusIdEntity>>> getAvailableLeaveTypes();

}