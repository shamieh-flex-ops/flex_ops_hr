// lib/features/time_off/domain/entities/create_time_off_params_entity.dart
import 'package:equatable/equatable.dart';

class CreateTimeOffParamsEntity extends Equatable { 
  final int holidayStatusId;
  final double numberOfDays;
  final String requestDateFrom;
  final String requestDateTo;
  final String? notes;
  final String? attachment;

  const CreateTimeOffParamsEntity({
    required this.holidayStatusId,
    required this.numberOfDays,
    required this.requestDateFrom,
    required this.requestDateTo,
    this.notes,
    this.attachment,
  });

  @override
  List<Object?> get props => [
    holidayStatusId,
    numberOfDays,
    requestDateFrom,
    requestDateTo,
    notes,
    attachment,
  ];
}