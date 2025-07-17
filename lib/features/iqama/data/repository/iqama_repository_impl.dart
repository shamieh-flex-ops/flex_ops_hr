import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/exceptions.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/features/iqama/data/datasources/iqama_remote_data_source.dart';
import 'package:flex_ops_hr/features/iqama/domain/entities/create_iqama_renewal_response.dart';
import 'package:flex_ops_hr/features/iqama/domain/entities/iqama_entities.dart';
import 'package:flex_ops_hr/features/iqama/domain/repository/base_iqama_repository.dart';
import 'package:flex_ops_hr/features/iqama/domain/usecases/create_iqama_renewal_usecase.dart';

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

   @override
  Future<Either<Failure, CreateIqamaRenewalResponse>> createIqamaRenewal(
    CreateIqamaRenewalParams params,
  ) async {
    try {
      final result = await remoteDataSource.createIqamaRenewal(params);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(
        e.messageModel.statusMessage,
        e.messageModel.statusCode,
      ));
    }
  }
}
