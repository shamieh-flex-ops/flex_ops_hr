import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/exceptions.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/features/iqama/data/datasources/iqama_remote_data_source.dart';
import 'package:flex_ops_hr/features/iqama/domain/entities/iqama_entities.dart';
import 'package:flex_ops_hr/features/iqama/domain/repository/base_iqama_repository.dart';

class IqamaRepositoryImpl extends BaseIqamaRepository {
  final IqamaRemoteDataSource remoteDataSource;

  IqamaRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<IqamaRenewalGroup>>> getIqamaRenewalGroups() async {
    try {
      final result = await remoteDataSource.getIqamaRenewalGroups();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(
        failure.messageModel.statusMessage,
        failure.messageModel.statusCode,
      ));
    }
  }
}
