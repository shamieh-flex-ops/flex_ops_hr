import 'package:flex_ops_hr/features/iqama/domain/entities/create_iqama_renewal_response.dart';

class CreateIqamaRenewalResponseModel extends CreateIqamaRenewalResponse {
  const CreateIqamaRenewalResponseModel({
    required super.message,
    required super.renewIqamaId,
  });

  factory CreateIqamaRenewalResponseModel.fromJson(Map<String, dynamic> json) {
    final result = json['result'] ?? {};
    return CreateIqamaRenewalResponseModel(
      message: result['msg'] ?? '',
      renewIqamaId: result['renew_iqama_id'] ?? 0,
    );
  }
}
