// lib/features/loans/data/models/loan_model.dart

import 'package:flex_ops_hr/features/loans/domain/entities/loan_entities.dart';

class LoanModel extends Loan {
  const LoanModel({
    required super.name,
    required super.reason,
    required super.loanAmount,
    required super.installment,
    required super.paymentDate,
    required super.date,
    required super.state,
    required super.employeeName,
    required super.departmentName,
    required super.jobName,
  });

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    return LoanModel(
      name: json['name'],
      reason: json['reason'],
      loanAmount: (json['loan_amount'] as num).toDouble(),
      installment: json['installment'],
      paymentDate: json['payment_date'],
      date: json['date'],
      state: json['state'],
      employeeName: json['employee_id']['name'],
      departmentName: json['employee_department']['name'],
      jobName: json['employee_job']['name'],
    );
  }
}

class LoanGroupModel extends LoanGroup {
  const LoanGroupModel({
    required super.description,
    required super.loanCount,
    required super.loans,
  });

  factory LoanGroupModel.fromJson(Map<String, dynamic> json) {
    return LoanGroupModel(
      description: json['description'],
      loanCount: json['loan_count'],
      loans: (json['loans'] as List)
          .map((e) => LoanModel.fromJson(e))
          .toList(),
    );
  }
}
