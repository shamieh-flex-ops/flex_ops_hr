// lib/features/timeoff/data/models/holiday_status_id_model.dart

import 'package:flex_ops_hr/features/timeoff/domain/entities/holiday_status_id_entity.dart';
import 'package:flex_ops_hr/features/timeoff/data/models/holiday_type_details_model.dart';

class HolidayStatusIdModel extends HolidayStatusIdEntity {
  const HolidayStatusIdModel({
    required super.name,
    required super.id,
    super.details,
    super.requiresAllocation,
  });

  factory HolidayStatusIdModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? detailsJson =
    json['details'] as Map<String, dynamic>?;

    final String? requiresAllocationValue =
    json['requires_allocation'] as String?;

    return HolidayStatusIdModel(
      name: json['name'] as String? ?? json['leave_type_name'] as String? ?? '',
      id: json['id'] as int? ?? json['leave_type_id'] as int? ?? 0,
      details: detailsJson != null
          ? HolidayTypeDetailsModel.fromJson(detailsJson) // هنا يتم إنشاء HolidayTypeDetailsModel
          : null,
      requiresAllocation: requiresAllocationValue,
    );
  }

  @override
  HolidayStatusIdEntity toEntity() {
    return HolidayStatusIdEntity(
      name: name,
      id: id,

      details: (details as HolidayTypeDetailsModel?)?.toEntity(),
      requiresAllocation: requiresAllocation,
    );
  }
}