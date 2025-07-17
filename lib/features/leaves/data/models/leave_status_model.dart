import 'package:flex_ops_hr/features/leaves/domain/entities/leave_status.dart';

class LeaveStatusModel extends LeaveStatus {
  const LeaveStatusModel({
    required super.employeeName,
    required super.leaveType,
    required super.numberOfDays,
    required super.requestDateFrom,
    required super.requestDateTo,
    required super.dateFrom,
    required super.dateTo,
    required super.state,
  });

  factory LeaveStatusModel.fromJson(Map<String, dynamic> json) {
    return LeaveStatusModel(
      employeeName: json['employee_id']?['name'] ?? '',
      leaveType: json['holiday_status_id']?['name'] ?? '',
      numberOfDays: (json['number_of_days'] ?? 0).toDouble(),
      requestDateFrom: json['request_date_from'] ?? '',
      requestDateTo: json['request_date_to'] ?? '',
      dateFrom: DateTime.parse(json['date_from']),
      dateTo: DateTime.parse(json['date_to']),
      state: json['state'] ?? '',
    );
  }
}
