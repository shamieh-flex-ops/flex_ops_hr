import 'package:flex_ops_hr/core/network/error_message_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flex_ops_hr/core/error/failure.dart';
import 'package:flex_ops_hr/features/auth_screens/domain/usecases/change_password_usecase.dart';

enum ChangePasswordState {
  initial,
  loading,
  success,
  error,
}

class ChangePasswordProvider extends ChangeNotifier {
  final ChangePasswordUseCase changePasswordUseCase;

  ChangePasswordProvider({required this.changePasswordUseCase});

  ChangePasswordState _state = ChangePasswordState.initial;
  String? _errorMessage;
  MessageModel? _response;

  ChangePasswordState get state => _state;
  String? get errorMessage => _errorMessage;
  MessageModel? get response => _response;

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    _state = ChangePasswordState.loading;
    _errorMessage = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      _errorMessage = 'No token found. Please log in again.';
      _state = ChangePasswordState.error;
      notifyListeners();
      return;
    }

    final result = await changePasswordUseCase(
      ChangePasswordParams(
        oldPassword: oldPassword,
        newPassword: newPassword,
        token: token,
      ),
    );

    result.fold(
      (Failure failure) {
        _errorMessage = failure.message;
        _state = ChangePasswordState.error;
      },
      (MessageModel message) {
        _response = message;
        _state = ChangePasswordState.success;
      },
    );

    notifyListeners();
  }
}
