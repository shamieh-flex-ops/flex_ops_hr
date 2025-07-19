// lib/features/leaves/domain/usecases/get_leave_types_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/core/usecase/base_usecase.dart';
import 'package:flex_ops_hr/features/leaves/domain/entities/leave_type_entity.dart';
import 'package:flex_ops_hr/features/leaves/domain/repository/base_leaves_request_repository.dart';

class GetLeaveTypesUseCase extends BaseUseCase<List<LeaveTypeEntity>, NoParameters> {
  final BaseLeavesRequestRepository repository;

  GetLeaveTypesUseCase(this.repository);

  @override
  Future<Either<Failure, List<LeaveTypeEntity>>> call(NoParameters parameters) async {
    return await repository.getLeaveTypes();
  }
}