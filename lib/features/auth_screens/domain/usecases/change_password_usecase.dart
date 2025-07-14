// lib/features/login/domain/usecases/change_password_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/core/network/error_message_model.dart';
import 'package:flex_ops_hr/core/usecase/base_usecase.dart';
import 'package:flex_ops_hr/features/auth_screens/domain/repository/base_auth_repository.dart';

class ChangePasswordUseCase extends BaseUseCase<MessageModel, ChangePasswordParams> {
  final BaseAuthRepository repository;

  ChangePasswordUseCase(this.repository);

  @override
  Future<Either<Failure, MessageModel>> call(ChangePasswordParams params) async {
    return await repository.changePassword(params);
  }
}

class ChangePasswordParams extends Equatable {
  final String oldPassword;
  final String newPassword;
    final String token;


  const ChangePasswordParams({
    required this.oldPassword,
    required this.newPassword,
        required this.token,

  });

  Map<String, dynamic> toJson() {
    return {
      "old_password": oldPassword,
      "new_password": newPassword,
    };
  }

  @override
  List<Object?> get props => [oldPassword, newPassword];
}
