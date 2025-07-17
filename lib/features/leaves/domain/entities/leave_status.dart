import 'package:equatable/equatable.dart';

class LeaveStatus extends Equatable {
  final String employeeName;
  final String leaveType;
  final double numberOfDays;
  final String requestDateFrom;
  final String requestDateTo;
  final DateTime dateFrom;
  final DateTime dateTo;
  final String state;

  const LeaveStatus({
    required this.employeeName,
    required this.leaveType,
    required this.numberOfDays,
    required this.requestDateFrom,
    required this.requestDateTo,
    required this.dateFrom,
    required this.dateTo,
    required this.state,
  });

  @override
  List<Object?> get props => [
    employeeName,
    leaveType,
    numberOfDays,
    requestDateFrom,
    requestDateTo,
    dateFrom,
    dateTo,
    state,
  ];
}
