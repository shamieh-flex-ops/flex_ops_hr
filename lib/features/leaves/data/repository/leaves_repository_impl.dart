import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/exceptions.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/features/leaves/data/datasource/leaves_remote_data_source.dart';
import 'package:flex_ops_hr/features/leaves/domain/entities/leave_status_group.dart';
import 'package:flex_ops_hr/features/leaves/domain/repository/base_leave_repository.dart';

class LeavesRepositoryImpl extends LeavesRepository {
  final LeavesRemoteDataSource remoteDataSource;

  LeavesRepositoryImpl(this.remoteDataSource);

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
