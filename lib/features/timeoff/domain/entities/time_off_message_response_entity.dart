// lib/features/time_off/domain/entities/time_off_message_response_entity.dart
import 'package:equatable/equatable.dart';

class TimeOffMessageResponseEntity extends Equatable {
  final String message;
  final int? timeOffId;

  const TimeOffMessageResponseEntity({
    required this.message,
    this.timeOffId,
  });

  @override
  List<Object?> get props => [message, timeOffId];
}