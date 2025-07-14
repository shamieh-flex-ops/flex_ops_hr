import 'package:equatable/equatable.dart';

class Login extends Equatable {
  final int employeeId;
  final String employeeName;
  final String token;

  const Login({
    required this.employeeId,
    required this.employeeName,
    required this.token,
  });

  @override
  List<Object?> get props => [employeeId, employeeName, token];
}
