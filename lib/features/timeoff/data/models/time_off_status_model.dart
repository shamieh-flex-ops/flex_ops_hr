// lib/features/time_off/data/models/time_off_status_model.dart

import 'package:flex_ops_hr/features/timeoff/data/models/employee_id_model.dart';
import 'package:flex_ops_hr/features/timeoff/data/models/holiday_status_id_model.dart';
import 'package:flex_ops_hr/features/timeoff/domain/entities/time_off_status_entity.dart';

class TimeOffStatusModel extends TimeOffStatus {
  const TimeOffStatusModel({
    required super.employeeId,
    required super.holidayStatusId,
    required super.numberOfDays,
    required super.requestDateFrom,
    required super.requestDateTo,
    required super.dateFrom,
    required super.dateTo,
    required super.state,
  });

  factory TimeOffStatusModel.fromJson(Map<String, dynamic> json) {
    return TimeOffStatusModel(
      employeeId: EmployeeIdModel.fromJson(json["employee_id"] ?? {}),
      holidayStatusId: HolidayStatusIdModel.fromJson(json["holiday_status_id"] ?? {}),
      numberOfDays: (json["number_of_days"] as num?)?.toDouble() ?? 0.0,
      requestDateFrom: (json["request_date_from"] as String?) ?? '',
      requestDateTo: (json["request_date_to"] as String?) ?? '',
      dateFrom: (json["date_from"] as String?) ?? '',
      dateTo: (json["date_to"] as String?) ?? '',
      state: (json["state"] as String?) ?? '',
    );
  }
}