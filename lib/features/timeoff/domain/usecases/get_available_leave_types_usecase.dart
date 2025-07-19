// lib/features/timeoff/domain/usecases/get_available_leave_types_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/core/usecase/base_usecase.dart';
import 'package:flex_ops_hr/features/timeoff/domain/entities/holiday_status_id_entity.dart';
import 'package:flex_ops_hr/features/timeoff/domain/repositries/base_time_off_repository.dart';

class GetAvailableLeaveTypesUseCase
    implements BaseUseCase<List<HolidayStatusIdEntity>, NoParameters> {
  final BaseTimeOffRepository repository;

  GetAvailableLeaveTypesUseCase(this.repository);

  @override
  Future<Either<Failure, List<HolidayStatusIdEntity>>> call(
      NoParameters parameters) async {
    return await repository.getAvailableLeaveTypes();
  }
}
