import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/features/leaves/domain/entities/leave_status_group.dart';

abstract class LeavesRepository {
  Future<Either<Failure, List<LeaveStatusGroup>>> getLeaveStatusGroups();
}
