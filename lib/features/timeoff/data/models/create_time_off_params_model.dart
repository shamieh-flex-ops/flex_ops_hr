// lib/features/time_off/data/models/create_time_off_params_model.dart
import 'package:flex_ops_hr/features/timeoff/domain/entities/create_time_off_params_entity.dart';

class CreateTimeOffParamsModel extends CreateTimeOffParamsEntity {
  const CreateTimeOffParamsModel({
    required super.holidayStatusId,
    required super.numberOfDays,
    required super.requestDateFrom,
    required super.requestDateTo,
    super.notes,
    super.attachment,
  });

  factory CreateTimeOffParamsModel.fromEntity(CreateTimeOffParamsEntity entity) {
    return CreateTimeOffParamsModel(
      holidayStatusId: entity.holidayStatusId,
      numberOfDays: entity.numberOfDays,
      requestDateFrom: entity.requestDateFrom,
      requestDateTo: entity.requestDateTo,
      notes: entity.notes,
      attachment: entity.attachment,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "holiday_status_id": holidayStatusId,
      "number_of_days": numberOfDays,
      "request_date_from": requestDateFrom,
      "request_date_to": requestDateTo,
      if (notes != null && notes!.isNotEmpty) "notes": notes,
      if (attachment != null && attachment!.isNotEmpty) "attachment": attachment,
    };
  }
}