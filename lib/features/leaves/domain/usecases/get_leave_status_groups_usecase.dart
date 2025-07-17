import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/features/leaves/domain/entities/leave_status_group.dart';

import '../../../../core/usecase/base_usecase.dart';
import '../repository/base_leave_repository.dart';

class GetLeaveStatusGroupsUseCase extends BaseUseCase<List<LeaveStatusGroup>, NoParameters> {
  final LeavesRepository repository;

  GetLeaveStatusGroupsUseCase(this.repository);

  @override
  Future<Either<Failure, List<LeaveStatusGroup>>> call(NoParameters parameters) async {
    return await repository.getLeaveStatusGroups();
  }
}
