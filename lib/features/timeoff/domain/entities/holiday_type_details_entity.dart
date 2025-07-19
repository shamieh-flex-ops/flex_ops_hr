// lib/features/timeoff/domain/entities/holiday_type_details_entity.dart
import 'package:equatable/equatable.dart';

class HolidayTypeDetailsEntity extends Equatable {
  final double remainingLeaves;
  final double virtualRemainingLeaves;
  final double maxLeaves;
  final int accrualBonus;
  final double leavesTaken;
  final double virtualLeavesTaken;
  final double leavesRequested;
  final double leavesApproved;
  final double closestAllocationRemaining;
  final bool closestAllocationExpire;
  final bool holdsChanges;
  final double totalVirtualExcess;
  final Map<String, dynamic> virtualExcessData;
  final double exceedingDuration; // <--- نتركها double
  final String requestUnit;
  final String icon;
  final bool allowsNegative;
  final int maxAllowedNegative;
  final dynamic closestAllocationDuration;
  final bool overtimeDeductible; // <--- تم التصحيح: overtimeDeductible

  const HolidayTypeDetailsEntity({
    required this.remainingLeaves,
    required this.virtualRemainingLeaves,
    required this.maxLeaves,
    required this.accrualBonus,
    required this.leavesTaken,
    required this.virtualLeavesTaken,
    required this.leavesRequested,
    required this.leavesApproved,
    required this.closestAllocationRemaining,
    required this.closestAllocationExpire,
    required this.holdsChanges,
    required this.totalVirtualExcess,
    required this.virtualExcessData,
    required this.exceedingDuration,
    required this.requestUnit,
    required this.icon,
    required this.allowsNegative,
    required this.maxAllowedNegative,
    this.closestAllocationDuration, // هذا يجب أن يبقى اختياري (غير required)
    required this.overtimeDeductible, // <--- الاسم الصحيح
  });

  @override
  List<Object?> get props => [
    remainingLeaves,
    virtualRemainingLeaves,
    maxLeaves,
    accrualBonus,
    leavesTaken,
    virtualLeavesTaken,
    leavesRequested,
    leavesApproved,
    closestAllocationRemaining,
    closestAllocationExpire,
    holdsChanges,
    totalVirtualExcess,
    virtualExcessData,
    exceedingDuration,
    requestUnit,
    icon,
    allowsNegative,
    maxAllowedNegative,
    closestAllocationDuration,
    overtimeDeductible,
  ];
}