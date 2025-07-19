// lib/features/time_off/domain/entities/employee_id_entity.dart
import 'package:equatable/equatable.dart';

class EmployeeIdEntity extends Equatable {
  final int id;
  final String name;

  const EmployeeIdEntity({
    required this.id,
    required this.name,
  });

  @override
  List<Object?> get props => [id, name];
}