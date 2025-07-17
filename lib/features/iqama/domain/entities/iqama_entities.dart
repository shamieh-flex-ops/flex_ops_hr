import 'package:equatable/equatable.dart';

class IqamaRenewal extends Equatable {
  final String name;
  final String? newIqamaId;
  final String? note;
  final String? state;
  final String? createDate;
  final String? renewalDate;
  final String? endOfIqama;

  final String employeeName;
  final String employeeDepartment;
  final String employeeJob;

  const IqamaRenewal({
    required this.name,
    required this.newIqamaId,
    required this.note,
    required this.state,
    required this.createDate,
    required this.renewalDate,
    required this.endOfIqama,
    required this.employeeName,
    required this.employeeDepartment,
    required this.employeeJob,
  });

  @override
  List<Object?> get props => [
        name,
        newIqamaId,
        note,
        state,
        createDate,
        renewalDate,
        endOfIqama,
        employeeName,
        employeeDepartment,
        employeeJob,
      ];
}


class IqamaRenewalGroup extends Equatable {
  final int renewIqamaCount;
  final String description;
  final List<IqamaRenewal> renewIqamas;

  const IqamaRenewalGroup({
    required this.renewIqamaCount,
    required this.description,
    required this.renewIqamas,
  });

  @override
  List<Object?> get props => [
        renewIqamaCount,
        description,
        renewIqamas,
      ];
}
