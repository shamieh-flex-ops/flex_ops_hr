// lib/features/leaves/data/models/time_off_request_model.dart

import 'package:flex_ops_hr/features/leaves/domain/entities/time_off_request_entity.dart';

class TimeOffRequestModel extends TimeOffRequestEntity {
  const TimeOffRequestModel({
    required super.leaveTypeId,
    required super.requestDateFrom,
    required super.requestDateTo,
    required super.numberOfDays,
    required super.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      'leave_type_id': leaveTypeId,
      'request_date_from': requestDateFrom,
      'request_date_to': requestDateTo,
      'number_of_days': numberOfDays,
      'reason': reason,
    };
  }
}