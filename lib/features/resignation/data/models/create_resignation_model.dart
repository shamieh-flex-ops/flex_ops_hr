// lib/features/resignation/data/models/create_resignation_response_model.dart

import 'package:flex_ops_hr/features/resignation/domain/entities/create_resignation_response.dart';

class CreateResignationResponseModel extends CreateResignationResponse {
  const CreateResignationResponseModel({
    required super.msg,
    required super.resignationId,
  });

  factory CreateResignationResponseModel.fromJson(Map<String, dynamic> json) {
    final result = json['result'] ?? {};
    return CreateResignationResponseModel(
      msg: result['msg'] ?? '',
      resignationId: result['resignation_id'] ?? 0,
    );
  }
}
