// lib/features/time_off/data/models/time_off_message_response_model.dart
import 'package:flex_ops_hr/features/timeoff/domain/entities/time_off_message_response_entity.dart';

class TimeOffMessageResponseModel extends TimeOffMessageResponseEntity {
  const TimeOffMessageResponseModel({
    required super.message,
    super.timeOffId,
  });

  factory TimeOffMessageResponseModel.fromJson(Map<String, dynamic> json) {
    return TimeOffMessageResponseModel(
      message: (json["msg"] as String?) ?? "Unknown message",
      timeOffId: (json["time_off_id"] as int?),
    );
  }
}