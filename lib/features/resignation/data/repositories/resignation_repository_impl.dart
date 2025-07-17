import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/exceptions.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/features/resignation/data/datasources/resignation_remote_data_source.dart';
import 'package:flex_ops_hr/features/resignation/domain/entities/create_resignation_response.dart';
import 'package:flex_ops_hr/features/resignation/domain/entities/resignation_entities.dart';
import 'package:flex_ops_hr/features/resignation/domain/repositories/base_resignation_repository.dart';
import 'package:flex_ops_hr/features/resignation/domain/usecases/create_resignation_usecase.dart';

class ResignationRepositoryImpl implements BaseResignationRepository {
  final ResignationRemoteDataSource remoteDataSource;

  ResignationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ResignationGroup>>> getResignationGroups() async {
    try {
      final result = await remoteDataSource.getResignationGroups();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(
        failure.messageModel.statusMessage,
        failure.messageModel.statusCode,
      ));
    }
  }

  @override
  Future<Either<Failure, CreateResignationResponse>> createResignation(
      CreateResignationParams resignation) async {
    try {
      final result = await remoteDataSource.createResignation(resignation);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(
          e.messageModel.statusMessage, e.messageModel.statusCode));
    }
  }
}
