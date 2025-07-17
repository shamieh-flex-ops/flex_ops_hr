// lib/features/leaves/data/repository/leaves_request_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/exceptions.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/features/leaves/data/datasource/base_leaves_request_remote_data_source.dart';
import 'package:flex_ops_hr/features/leaves/domain/entities/leave_type_entity.dart';
import 'package:flex_ops_hr/features/leaves/domain/entities/time_off_request_entity.dart';
import 'package:flex_ops_hr/features/leaves/domain/entities/leave_request_entity.dart';
import 'package:flex_ops_hr/features/leaves/domain/repository/base_leaves_request_repository.dart';
import 'package:flex_ops_hr/features/leaves/data/models/time_off_request_model.dart';
import 'package:flex_ops_hr/features/leaves/data/models/leave_request_model.dart';

import 'package:flex_ops_hr/features/leaves/domain/repository/base_leave_repository.dart';
import 'package:flex_ops_hr/features/leaves/domain/entities/leave_status_group.dart';

class LeavesRequestRepositoryImpl implements BaseLeavesRequestRepository, LeavesRepository {
  final BaseLeavesRequestRemoteDataSource remoteDataSource;

  LeavesRequestRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, bool>> requestTimeOff(TimeOffRequestEntity params) async {
    final timeOffRequestModel = TimeOffRequestModel(
      leaveTypeId: params.leaveTypeId,
      requestDateFrom: params.requestDateFrom,
      requestDateTo: params.requestDateTo,
      numberOfDays: params.numberOfDays,
      reason: params.reason,
    );
    try {
      final result = await remoteDataSource.requestTimeOff(timeOffRequestModel);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(
        failure.messageModel.statusMessage,
        failure.messageModel.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> requestLeave(LeaveRequestEntity params) async {
    final leaveRequestModel = LeaveRequestModel(
      leaveTypeId: params.leaveTypeId,
      requestDateFrom: params.requestDateFrom,
      requestDateTo: params.requestDateTo,
      requestHourFrom: params.requestHourFrom,
      requestHourTo: params.requestHourTo,
      numberOfDays: params.numberOfDays,
      reason: params.reason,
      attachmentPath: params.attachmentPath,
    );
    try {
      final result = await remoteDataSource.requestLeave(leaveRequestModel);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(
        failure.messageModel.statusMessage,
        failure.messageModel.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, List<LeaveTypeEntity>>> getLeaveTypes() async {
    try {
      final result = await remoteDataSource.getLeaveTypes();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(
        failure.messageModel.statusMessage,
        failure.messageModel.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, List<LeaveStatusGroup>>> getLeaveStatusGroups() async {
    try {

      final result = await remoteDataSource.getLeaveStatusGroups();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(
        failure.messageModel.statusMessage,
        failure.messageModel.statusCode,
      ));
    }
  }
}