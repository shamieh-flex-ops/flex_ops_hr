// lib/features/leaves/domain/entities/leave_type_entity.dart

import 'package:equatable/equatable.dart';

class LeaveTypeEntity extends Equatable {
  final int id;
  final String name;

  const LeaveTypeEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}