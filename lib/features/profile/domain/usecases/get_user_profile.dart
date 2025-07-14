import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/core/usecase/base_usecase.dart';

import '../entities/user_profile.dart';
import '../repository/base_profile_repository.dart';

class GetUserProfile implements BaseUseCase<UserProfile, NoParameters> {
  final ProfileRepository repository;

  GetUserProfile(this.repository);

  @override
  Future<Either<Failure, UserProfile>> call(NoParameters parameters) async {
    return await repository.getUserProfile();
  }
}
