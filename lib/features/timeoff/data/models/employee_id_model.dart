// lib/features/time_off/data/models/employee_id_model.dart
import 'package:flex_ops_hr/features/timeoff/domain/entities/employee_id_entity.dart';

class EmployeeIdModel extends EmployeeIdEntity {
  const EmployeeIdModel({
    required super.id,
    required super.name,
  });

  factory EmployeeIdModel.fromJson(Map<String, dynamic> json) {
    return EmployeeIdModel(
      id: (json["id"] as int?) ?? 0,
      name: (json["name"] as String?) ?? '',
    );
  }
}