// lib/features/leaves/domain/entities/leave_request_entity.dart

import 'package:equatable/equatable.dart';

class LeaveRequestEntity extends Equatable {
  final int leaveTypeId;
  final String requestDateFrom;
  final String requestDateTo;
  final String? requestHourFrom; // قد تكون null إذا لم تكن ساعية
  final String? requestHourTo;   // قد تكون null إذا لم تكن ساعية
  final double numberOfDays;
  final String reason;
  final String? attachmentPath; // مسار الملف المرفق (لشهادة مرضية مثلاً)

  const LeaveRequestEntity({
    required this.leaveTypeId,
    required this.requestDateFrom,
    required this.requestDateTo,
    this.requestHourFrom,
    this.requestHourTo,
    required this.numberOfDays,
    required this.reason,
    this.attachmentPath,
  });

  @override
  List<Object?> get props => [
    leaveTypeId,
    requestDateFrom,
    requestDateTo,
    requestHourFrom,
    requestHourTo,
    numberOfDays,
    reason,
    attachmentPath,
  ];
}