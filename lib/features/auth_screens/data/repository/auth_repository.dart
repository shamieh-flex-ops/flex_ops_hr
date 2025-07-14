import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/core/error/exceptions.dart';
import 'package:flex_ops_hr/core/network/error_message_model.dart';
import 'package:flex_ops_hr/features/auth_screens/data/datasource/auth_remote_data_source.dart';
import 'package:flex_ops_hr/features/auth_screens/domain/entities/login.dart';
import 'package:flex_ops_hr/features/auth_screens/domain/repository/base_auth_repository.dart';
import 'package:flex_ops_hr/features/auth_screens/domain/usecases/change_password_usecase.dart';
import 'package:flex_ops_hr/features/auth_screens/domain/usecases/login_usecase.dart';

class AuthRepository extends BaseAuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepository(this.remoteDataSource);

  @override
  Future<Either<Failure, Login>> login(LoginParams params) async {
    try {
      final result = await remoteDataSource.login(params);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.messageModel.statusMessage));
    }
  }

  @override
  Future<Either<Failure, MessageModel>> changePassword(ChangePasswordParams params) async {
    try {
      final result = await remoteDataSource.changePassword(params);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(failure.messageModel.statusMessage));
    }
  }
}
