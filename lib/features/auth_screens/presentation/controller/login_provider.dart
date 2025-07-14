import 'package:flex_ops_hr/core/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/features/auth_screens/domain/entities/login.dart';
import 'package:flex_ops_hr/features/auth_screens/domain/usecases/login_usecase.dart';

class LoginProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;

  LoginProvider({required this.loginUseCase});

  RequestState loginState = RequestState.loaded;
  String? errorMessage;
  Login? loginResult;

  Future<void> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    loginState = RequestState.loading;
    errorMessage = null;
    notifyListeners();

    final Either<Failure, Login> result =
        await loginUseCase(LoginParams(email: email, password: password));

    result.fold(
      (failure) {
        errorMessage = failure.message;
        loginState = RequestState.error;
      },
      (data) async {
        loginResult = data;
        await _cacheToken(data.token, rememberMe);
        loginState = RequestState.loaded;
      },
    );

    notifyListeners();
  }

  Future<void> _cacheToken(String token, bool rememberMe) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setBool('remember_me', rememberMe);
  }
}
