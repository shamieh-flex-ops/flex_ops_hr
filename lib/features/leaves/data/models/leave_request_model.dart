// lib/features/leaves/data/models/leave_request_model.dart

import 'package:flex_ops_hr/features/leaves/domain/entities/leave_request_entity.dart';

class LeaveRequestModel extends LeaveRequestEntity {
  const LeaveRequestModel({
    required super.leaveTypeId,
    required super.requestDateFrom,
    required super.requestDateTo,
    super.requestHourFrom,
    super.requestHourTo,
    required super.numberOfDays,
    required super.reason,
    super.attachmentPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'leave_type_id': leaveTypeId,
      'request_date_from': requestDateFrom,
      'request_date_to': requestDateTo,
      'request_hour_from': requestHourFrom,
      'request_hour_to': requestHourTo,
      'number_of_days': numberOfDays,
      'reason': reason,
      'attachment_path': attachmentPath,
    };
  }
}