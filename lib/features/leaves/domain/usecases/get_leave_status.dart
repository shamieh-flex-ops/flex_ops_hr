import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/core/usecase/base_usecase.dart';
import 'package:flex_ops_hr/features/leaves/domain/entities/leave_status_group.dart';
import 'package:flex_ops_hr/features/leaves/domain/repository/base_leave_repository.dart';

class GetLeaveStatusUseCase extends BaseUseCase<List<LeaveStatusGroup>, NoParameters> {
  final LeavesRepository repository;

  GetLeaveStatusUseCase(this.repository);

  @override
  Future<Either<Failure, List<LeaveStatusGroup>>> call(NoParameters parameters) async {
    return await repository.getLeaveStatusGroups();
  }
}