// lib/features/loans/domain/entitiesentitiesentitiesentitiesentitiesentities/loan_entities.dart

import 'package:equatable/equatable.dart';

class LoanGroup extends Equatable {
  final String description;
  final int loanCount;
  final List<Loan> loans;

  const LoanGroup({
    required this.description,
    required this.loanCount,
    required this.loans,
  });

  @override
  List<Object?> get props => [description, loanCount, loans];
}

class Loan extends Equatable {
  final String name;
  final String reason;
  final double loanAmount;
  final int installment;
  final String paymentDate;
  final String date;
  final String state;
  final String employeeName;
  final String departmentName;
  final String jobName;

  const Loan({
    required this.name,
    required this.reason,
    required this.loanAmount,
    required this.installment,
    required this.paymentDate,
    required this.date,
    required this.state,
    required this.employeeName,
    required this.departmentName,
    required this.jobName,
  });

  @override
  List<Object?> get props => [
    name,
    reason,
    loanAmount,
    installment,
    paymentDate,
    date,
    state,
    employeeName,
    departmentName,
    jobName,
  ];
}
