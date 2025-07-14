import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/core/usecase/base_usecase.dart';
import 'package:flex_ops_hr/features/auth_screens/domain/entities/login.dart';
import 'package:flex_ops_hr/features/auth_screens/domain/repository/base_auth_repository.dart';



class LoginUseCase extends BaseUseCase<Login, LoginParams> {
  final BaseAuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, Login>> call(LoginParams params) {
    return repository.login(params);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
