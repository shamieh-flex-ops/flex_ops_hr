// lib/features/leaves/data/models/leave_type_model.dart

import 'package:flex_ops_hr/features/leaves/domain/entities/leave_type_entity.dart'; // تأكد من صحة هذا المسار

class LeaveTypeModel extends LeaveTypeEntity {
  const LeaveTypeModel({
    required super.id,
    required super.name,
  });

  factory LeaveTypeModel.fromJson(Map<String, dynamic> json) {
    return LeaveTypeModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}