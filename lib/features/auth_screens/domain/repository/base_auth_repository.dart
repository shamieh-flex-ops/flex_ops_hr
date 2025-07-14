import 'package:dartz/dartz.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/core/network/error_message_model.dart';
import 'package:flex_ops_hr/features/auth_screens/domain/entities/login.dart';
import 'package:flex_ops_hr/features/auth_screens/domain/usecases/change_password_usecase.dart';
import 'package:flex_ops_hr/features/auth_screens/domain/usecases/login_usecase.dart';

abstract class BaseAuthRepository {
  Future<Either<Failure, Login>> login(LoginParams params);
    Future<Either<Failure, MessageModel>> changePassword(ChangePasswordParams params);

}