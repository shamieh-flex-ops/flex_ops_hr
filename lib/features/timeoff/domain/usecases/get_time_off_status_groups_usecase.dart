// lib/features/time_off/domain/usecases/get_time_off_status_groups_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/core/usecase/base_usecase.dart';
import 'package:flex_ops_hr/features/timeoff/domain/entities/time_off_status_group_entity.dart';
import 'package:flex_ops_hr/features/timeoff/domain/repositries/base_time_off_repository.dart';

class GetTimeOffStatusGroupsUseCase
    extends BaseUseCase<List<TimeOffStatusGroupEntity>, NoParameters> {
  final BaseTimeOffRepository repository;

  GetTimeOffStatusGroupsUseCase(this.repository);

  @override
  Future<Either<Failure, List<TimeOffStatusGroupEntity>>> call(
      NoParameters parameters) async {
    return await repository.getTimeOffStatusGroups();
  }
}
