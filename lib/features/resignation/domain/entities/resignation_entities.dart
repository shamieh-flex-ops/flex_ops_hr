// lib/features/resignation/domain/entities/resignation_entities.dart

import 'package:equatable/equatable.dart';

class Resignation extends Equatable {
  final String name;
  final String employeeName;
  final String departmentName;
  final String jobName;
  final String? resignationDate;
  final String resignationType;
  final String typesOfEndServices;
  final String leaveDate;
  final int noticePeriod;
  final String note;
  final String state;

  const Resignation({
    required this.name,
    required this.employeeName,
    required this.departmentName,
    required this.jobName,
    required this.resignationDate,
    required this.resignationType,
    required this.typesOfEndServices,
    required this.leaveDate,
    required this.noticePeriod,
    required this.note,
    required this.state,
  });

  @override
  List<Object?> get props => [
        name,
        employeeName,
        departmentName,
        jobName,
        resignationDate,
        resignationType,
        typesOfEndServices,
        leaveDate,
        noticePeriod,
        note,
        state,
      ];
}

class ResignationGroup extends Equatable {
  final String description;
  final int resignationCount;
  final List<Resignation> resignations;

  const ResignationGroup({
    required this.description,
    required this.resignationCount,
    required this.resignations,
  });

  @override
  List<Object> get props => [description, resignationCount, resignations];
}
