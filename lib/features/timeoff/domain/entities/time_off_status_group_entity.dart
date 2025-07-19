// lib/features/time_off/domain/entities/time_off_status_group_entity.dart
import 'package:equatable/equatable.dart';
import 'package:flex_ops_hr/features/timeoff/domain/entities/time_off_status_entity.dart';

class TimeOffStatusGroupEntity extends Equatable { 
  final int leaveCount;
  final String description;
  final List<TimeOffStatus> leaves;

  const TimeOffStatusGroupEntity({
    required this.leaveCount,
    required this.description,
    required this.leaves,
  });

  @override
  List<Object?> get props => [leaveCount, description, leaves];
}