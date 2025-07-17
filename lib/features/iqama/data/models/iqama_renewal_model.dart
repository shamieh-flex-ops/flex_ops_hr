import 'package:flex_ops_hr/features/iqama/domain/entities/iqama_entities.dart';

//
// ✅ IqamaRenewalModel
//
class IqamaRenewalModel extends IqamaRenewal {
  const IqamaRenewalModel({
    required super.name,
    super.newIqamaId,
    super.note,
    super.state,
    super.createDate,
    super.renewalDate,
    super.endOfIqama,
    required super.employeeName,
    required super.employeeDepartment,
    required super.employeeJob,
  });

  factory IqamaRenewalModel.fromJson(Map<String, dynamic> json) {
    return IqamaRenewalModel(
      name: json['name'] ?? '',
      newIqamaId: json['new_iqama_id'],
      note: json['note'],
      state: json['state'],
      createDate: json['create_date'],
      renewalDate: json['renewal_date'],
      endOfIqama: json['end_of_iqama'],
      employeeName: json['employee_id']?['name'] ?? '',
      employeeDepartment: json['employee_department']?['name'] ?? '',
      employeeJob: json['employee_job']?['name'] ?? '',
    );
  }
}

//
// ✅ IqamaRenewalGroupModel
//
class IqamaRenewalGroupModel extends IqamaRenewalGroup {
  const IqamaRenewalGroupModel({
    required int renewIqamaCount,
    required String description,
    required List<IqamaRenewalModel> renewIqamas,
  }) : super(
          renewIqamaCount: renewIqamaCount,
          description: description,
          renewIqamas: renewIqamas,
        );

  factory IqamaRenewalGroupModel.fromJson(Map<String, dynamic> json) {
    return IqamaRenewalGroupModel(
      renewIqamaCount: json['renew_iqama_count'] ?? 0,
      description: json['description'] ?? '',
      renewIqamas: (json['renew_iqamas'] as List<dynamic>?)
              ?.map((e) => IqamaRenewalModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
