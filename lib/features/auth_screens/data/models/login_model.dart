import 'package:flex_ops_hr/features/auth_screens/domain/entities/login.dart';


class LoginModel extends Login {
  const LoginModel({
    required super.employeeId,
    required super.employeeName,
    required super.token,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    final result = json['result'];
    return LoginModel(
      employeeId: result['employee_id'],
      employeeName: result['employee_name'],
      token: result['token'],
    );
  }
}
