// lib/features/leaves/domain/entities/time_off_request_entity.dart

import 'package:equatable/equatable.dart';

class TimeOffRequestEntity extends Equatable {
  final int leaveTypeId;
  final String requestDateFrom;
  final String requestDateTo;
  final double numberOfDays;
  final String reason;

  const TimeOffRequestEntity({
    required this.leaveTypeId,
    required this.requestDateFrom,
    required this.requestDateTo,
    required this.numberOfDays,
    required this.reason,
  });

  @override
  List<Object?> get props => [
    leaveTypeId,
    requestDateFrom,
    requestDateTo,
    numberOfDays,
    reason,
  ];
}