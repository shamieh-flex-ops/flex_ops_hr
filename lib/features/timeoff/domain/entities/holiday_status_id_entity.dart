// lib/features/timeoff/domain/entities/holiday_status_id_entity.dart
import 'package:equatable/equatable.dart';
import 'package:flex_ops_hr/features/timeoff/domain/entities/holiday_type_details_entity.dart'; // تأكد من الاستيراد

class HolidayStatusIdEntity extends Equatable {
  final String name;
  final int id;
  final HolidayTypeDetailsEntity? details; // هذا النوع صحيح
  final String? requiresAllocation;

  const HolidayStatusIdEntity({
    required this.name,
    required this.id,
    this.details,
    this.requiresAllocation,
  });

  @override
  List<Object?> get props => [name, id, details, requiresAllocation];


}