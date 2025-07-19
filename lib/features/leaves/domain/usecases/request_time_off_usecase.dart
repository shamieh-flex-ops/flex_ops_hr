// lib/features/leaves/domain/usecases/request_time_off_usecase.dart (والمشابه لـ RequestLeaveUseCase)

import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/core/usecase/base_usecase.dart';
import 'package:flex_ops_hr/features/leaves/domain/repository/base_leaves_request_repository.dart';
import 'package:flex_ops_hr/features/leaves/domain/entities/time_off_request_entity.dart'; // أو LeaveRequestEntity

class RequestTimeOffUseCase extends BaseUseCase<bool, TimeOffRequestEntity> {
  final BaseLeavesRequestRepository repository;

  RequestTimeOffUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(TimeOffRequestEntity parameters) async {
    return await repository.requestTimeOff(parameters);
  }
}