import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/features/profile/data/datasource/profile_remote_data_source.dart';
import 'package:flex_ops_hr/features/profile/domain/entities/user_profile.dart';
import 'package:flex_ops_hr/features/profile/domain/repository/base_profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserProfile>> getUserProfile() async {
    try {
      final result = await remoteDataSource.getUserProfile();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString(),500 ));
    }
  }
}
