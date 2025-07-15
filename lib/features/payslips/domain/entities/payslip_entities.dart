// lib/features/payslips/domain/entities/payslip_entities.dart

import 'package:equatable/equatable.dart';

// Payslip Line
class PayslipLine extends Equatable {
  final String name;
  final double quantity;
  final double total;

  const PayslipLine({
    required this.name,
    required this.quantity,
    required this.total,
  });

  @override
  List<Object> get props => [name, quantity, total];
}

// Worked Day
class WorkedDay extends Equatable {
  final String name;
  final double numberOfHours;
  final double amount;

  const WorkedDay({
    required this.name,
    required this.numberOfHours,
    required this.amount,
  });

  @override
  List<Object> get props => [name, numberOfHours, amount];
}

// Payslip
class Payslip extends Equatable {
  final int payslipId;
  final String employeeName;
  final String contractName;
  final String contractType;
  final double workingSchedule;
  final String dateFrom;
  final String dateTo;
  final String salaryType;
  final double basicSalary;
  final List<WorkedDay> workedDays;
  final List<PayslipLine> payslipLines;
  final String reportPdfUrlEn;
  final String reportPdfUrlAr;

  const Payslip({
    required this.payslipId,
    required this.employeeName,
    required this.contractName,
    required this.contractType,
    required this.workingSchedule,
    required this.dateFrom,
    required this.dateTo,
    required this.salaryType,
    required this.basicSalary,
    required this.workedDays,
    required this.payslipLines,
    required this.reportPdfUrlEn,
    required this.reportPdfUrlAr,
  });

  @override
  List<Object> get props => [
        payslipId,
        employeeName,
        contractName,
        contractType,
        workingSchedule,
        dateFrom,
        dateTo,
        salaryType,
        basicSalary,
        workedDays,
        payslipLines,
        reportPdfUrlEn,
        reportPdfUrlAr,
      ];
}

// Payslip Group
class PayslipGroup extends Equatable {
  final String state;
  final int payslipCount;
  final List<Payslip> payslips;

  const PayslipGroup({
    required this.state,
    required this.payslipCount,
    required this.payslips,
  });

  @override
  List<Object> get props => [state, payslipCount, payslips];
}
