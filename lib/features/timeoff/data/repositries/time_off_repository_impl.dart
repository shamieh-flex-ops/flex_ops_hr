// lib/features/time_off/data/repository/time_off_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/exceptions.dart';
import 'package:flex_ops_hr/core/error/failure.dart';

import 'package:flex_ops_hr/features/timeoff/data/datasource/base_time_off_remote_data_source.dart';
import 'package:flex_ops_hr/features/timeoff/domain/entities/create_time_off_params_entity.dart';
import 'package:flex_ops_hr/features/timeoff/domain/entities/time_off_message_response_entity.dart';
import 'package:flex_ops_hr/features/timeoff/domain/entities/time_off_status_group_entity.dart';
import 'package:flex_ops_hr/features/timeoff/domain/repositries/base_time_off_repository.dart';

import 'package:flex_ops_hr/features/timeoff/domain/entities/holiday_status_id_entity.dart';

class TimeOffRepositoryImpl implements BaseTimeOffRepository {
  final BaseTimeOffRemoteDataSource remoteDataSource;

  TimeOffRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<TimeOffStatusGroupEntity>>>
      getTimeOffStatusGroups() async {
    try {
      final result = await remoteDataSource.getTimeOffStatusGroups();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(
        failure.messageModel.statusMessage,
        failure.messageModel.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, TimeOffMessageResponseEntity>> createTimeOff(
      CreateTimeOffParamsEntity params) async {
    try {
      final result = await remoteDataSource.createTimeOff(params);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(
        failure.messageModel.statusMessage,
        failure.messageModel.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, List<HolidayStatusIdEntity>>>
      getAvailableLeaveTypes() async {
    try {
      final result = await remoteDataSource.getAvailableLeaveTypes();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException catch (failure) {
      return Left(ServerFailure(
        failure.messageModel.statusMessage,
        failure.messageModel.statusCode,
      ));
    }
  }
}
