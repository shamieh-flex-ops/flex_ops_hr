// lib/features/payslips/data/models/payslip_model.dart

import 'package:flex_ops_hr/features/payslips/domain/entities/payslip_entities.dart';

// PayslipLineModel
class PayslipLineModel extends PayslipLine {
  const PayslipLineModel({
    required super.name,
    required super.quantity,
    required super.total,
  });

  factory PayslipLineModel.fromJson(Map<String, dynamic> json) {
    return PayslipLineModel(
      name: json['name'],
      quantity: (json['quantity'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }
}

// WorkedDayModel
class WorkedDayModel extends WorkedDay {
  const WorkedDayModel({
    required super.name,
    required super.numberOfHours,
    required super.amount,
  });

  factory WorkedDayModel.fromJson(Map<String, dynamic> json) {
    return WorkedDayModel(
      name: json['name'],
      numberOfHours: (json['number_of_hours'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
    );
  }
}

// PayslipModel
class PayslipModel extends Payslip {
  const PayslipModel({
    required super.payslipId,
    required super.employeeName,
    required super.contractName,
    required super.contractType,
    required super.workingSchedule,
    required super.dateFrom,
    required super.dateTo,
    required super.salaryType,
    required super.basicSalary,
    required super.workedDays,
    required super.payslipLines,
    required super.reportPdfUrlEn,
    required super.reportPdfUrlAr,
  });

  factory PayslipModel.fromJson(Map<String, dynamic> json) {
    return PayslipModel(
      payslipId: json['payslip_id'],
      employeeName: json['employee_name'],
      contractName: json['contract_name'],
      contractType: json['contract_type'],
      workingSchedule: (json['working_schedule'] as num).toDouble(),
      dateFrom: json['date_from'],
      dateTo: json['date_to'],
      salaryType: json['salary_type'],
      basicSalary: (json['basic_salary'] as num).toDouble(),
      workedDays: (json['worked_days'] as List)
          .map((e) => WorkedDayModel.fromJson(e))
          .toList(),
      payslipLines: (json['payslip_lines'] as List)
          .map((e) => PayslipLineModel.fromJson(e))
          .toList(),
      reportPdfUrlEn: json['report_pdf_url_en'],
      reportPdfUrlAr: json['report_pdf_url_ar'],
    );
  }
}

// PayslipGroupModel
class PayslipGroupModel extends PayslipGroup {
  const PayslipGroupModel({
    required super.state,
    required super.payslipCount,
    required super.payslips,
  });

  factory PayslipGroupModel.fromJson(Map<String, dynamic> json) {
    return PayslipGroupModel(
      state: json['state'],
      payslipCount: json['payslip_count'],
      payslips: (json['payslips'] as List)
          .map((e) => PayslipModel.fromJson(e))
          .toList(),
    );
  }
}
