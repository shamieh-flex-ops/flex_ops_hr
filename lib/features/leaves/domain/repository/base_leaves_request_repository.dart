// lib/features/leaves/domain/repository/base_leaves_request_repository.dart

import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/features/leaves/domain/entities/leave_type_entity.dart';
import 'package:flex_ops_hr/features/leaves/domain/entities/time_off_request_entity.dart';
import 'package:flex_ops_hr/features/leaves/domain/entities/leave_request_entity.dart';

abstract class BaseLeavesRequestRepository {
  Future<Either<Failure, bool>> requestTimeOff(TimeOffRequestEntity params);
  Future<Either<Failure, bool>> requestLeave(LeaveRequestEntity params);
  Future<Either<Failure, List<LeaveTypeEntity>>> getLeaveTypes();
}