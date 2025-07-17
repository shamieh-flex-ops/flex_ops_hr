// lib/features/resignation/data/models/resignation_model.dart

import 'package:flex_ops_hr/features/resignation/domain/entities/resignation_entities.dart';

class ResignationModel extends Resignation {
  const ResignationModel({
    required super.name,
    required super.employeeName,
    required super.departmentName,
    required super.jobName,
    required super.resignationDate,
    required super.resignationType,
    required super.typesOfEndServices,
    required super.leaveDate,
    required super.noticePeriod,
    required super.note,
    required super.state,
  });

  factory ResignationModel.fromJson(Map<String, dynamic> json) {
    return ResignationModel(
      name: json['name'],
      employeeName: json['employee_id']['name'],
      departmentName: json['employee_department']['name'],
      jobName: json['employee_job']['name'],
      resignationDate: json['resignation_date'],
      resignationType: json['resignation_type'],
      typesOfEndServices: json['types_of_end_services'],
      leaveDate: json['leave_date'],
      noticePeriod: json['notice_period'],
      note: json['note'],
      state: json['state'],
    );
  }
}

class ResignationGroupModel extends ResignationGroup {
  const ResignationGroupModel({
    required super.description,
    required super.resignationCount,
    required super.resignations,
  });

  factory ResignationGroupModel.fromJson(Map<String, dynamic> json) {
    return ResignationGroupModel(
      description: json['description'],
      resignationCount: json['resignation_count'],
      resignations: (json['resignations'] as List)
          .map((e) => ResignationModel.fromJson(e))
          .toList(),
    );
  }
}
