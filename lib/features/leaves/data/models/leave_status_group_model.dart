import 'package:flex_ops_hr/features/leaves/domain/entities/leave_status_group.dart';
import 'package:flex_ops_hr/features/leaves/data/models/leave_status_model.dart';
import 'package:flex_ops_hr/features/leaves/domain/entities/leave_status.dart';

class LeaveStatusGroupModel extends LeaveStatusGroup {
  const LeaveStatusGroupModel({
    required super.leaveCount,
    required super.description,
    required super.leaves,
  });

  factory LeaveStatusGroupModel.fromJson(Map<String, dynamic> json) {
    return LeaveStatusGroupModel(
      leaveCount: json['leave_count'] ?? 0,
      description: json['description'] ?? '',
      leaves: (json['leaves'] as List<dynamic>)
          .map((e) => LeaveStatusModel.fromJson(e))
          .toList(),
    );
  }
}
