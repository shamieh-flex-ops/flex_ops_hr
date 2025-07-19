// lib/features/time_off/domain/entities/time_off_status_entity.dart
import 'package:equatable/equatable.dart';

import 'package:flex_ops_hr/features/timeoff/domain/entities/employee_id_entity.dart';
import 'package:flex_ops_hr/features/timeoff/domain/entities/holiday_status_id_entity.dart';

class TimeOffStatus extends Equatable {
  final EmployeeIdEntity employeeId;
  final HolidayStatusIdEntity holidayStatusId;
  final double numberOfDays;
  final String requestDateFrom;
  final String requestDateTo;
  final String dateFrom;
  final String dateTo;
  final String state;

  const TimeOffStatus({
    required this.employeeId,
    required this.holidayStatusId,
    required this.numberOfDays,
    required this.requestDateFrom,
    required this.requestDateTo,
    required this.dateFrom,
    required this.dateTo,
    required this.state,
  });

  @override
  List<Object?> get props => [
    employeeId,
    holidayStatusId,
    numberOfDays,
    requestDateFrom,
    requestDateTo,
    dateFrom,
    dateTo,
    state,
  ];
}