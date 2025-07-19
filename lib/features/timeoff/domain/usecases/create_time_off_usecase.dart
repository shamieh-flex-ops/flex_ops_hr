// lib/features/time_off/domain/usecases/create_time_off_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/core/usecase/base_usecase.dart';

import 'package:flex_ops_hr/features/timeoff/domain/entities/create_time_off_params_entity.dart';
import 'package:flex_ops_hr/features/timeoff/domain/entities/time_off_message_response_entity.dart';
import 'package:flex_ops_hr/features/timeoff/domain/repositries/base_time_off_repository.dart';

class CreateTimeOffUseCase extends BaseUseCase<TimeOffMessageResponseEntity,
    CreateTimeOffParamsEntity> {
  final BaseTimeOffRepository repository;

  CreateTimeOffUseCase(this.repository);

  @override
  Future<Either<Failure, TimeOffMessageResponseEntity>> call(
      CreateTimeOffParamsEntity parameters) async {
    return await repository.createTimeOff(parameters);
  }
}
