// lib/features/leaves/domain/usecases/request_leave_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/core/usecase/base_usecase.dart';
import 'package:flex_ops_hr/features/leaves/domain/entities/leave_request_entity.dart';
import 'package:flex_ops_hr/features/leaves/domain/repository/base_leaves_request_repository.dart';

class RequestLeaveUseCase extends BaseUseCase<bool, LeaveRequestEntity> {
  final BaseLeavesRequestRepository repository;

  RequestLeaveUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(LeaveRequestEntity params) async {
    return await repository.requestLeave(params);
  }
}