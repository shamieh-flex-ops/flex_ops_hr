// lib/features/time_off/data/models/time_off_status_group_model.dart

import 'package:flex_ops_hr/features/timeoff/data/models/time_off_status_model.dart';
import 'package:flex_ops_hr/features/timeoff/domain/entities/time_off_status_group_entity.dart';

class TimeOffStatusGroupModel extends TimeOffStatusGroupEntity {
  const TimeOffStatusGroupModel({
    required super.leaveCount,
    required super.description,
    required super.leaves,
  });

  factory TimeOffStatusGroupModel.fromJson(Map<String, dynamic> json) {
    return TimeOffStatusGroupModel(
      leaveCount: (json["leave_count"] as int?) ?? 0,
      description: (json["description"] as String?) ?? '',
      leaves: List<TimeOffStatusModel>.from(
          (json["leaves"] as List? ?? []).map((e) => TimeOffStatusModel.fromJson(e as Map<String, dynamic>))),
    );
  }
}