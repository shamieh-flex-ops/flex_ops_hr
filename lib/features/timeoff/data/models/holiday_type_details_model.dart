// lib/features/timeoff/data/models/holiday_type_details_model.dart

import 'package:flex_ops_hr/features/timeoff/domain/entities/holiday_type_details_entity.dart';

class HolidayTypeDetailsModel extends HolidayTypeDetailsEntity {
  const HolidayTypeDetailsModel({
    required super.remainingLeaves,
    required super.virtualRemainingLeaves,
    required super.maxLeaves,
    required super.accrualBonus,
    required super.leavesTaken,
    required super.virtualLeavesTaken,
    required super.leavesRequested,
    required super.leavesApproved,
    required super.closestAllocationRemaining,
    required super.closestAllocationExpire,
    required super.holdsChanges,
    required super.totalVirtualExcess,
    required super.virtualExcessData,
    required super.exceedingDuration,
    required super.requestUnit,
    required super.icon,
    required super.allowsNegative,
    required super.maxAllowedNegative,
    super.closestAllocationDuration,
    required super.overtimeDeductible,
  });

  factory HolidayTypeDetailsModel.fromJson(Map<String, dynamic> json) {
    return HolidayTypeDetailsModel(
      remainingLeaves: (json['remaining_leaves'] as num?)?.toDouble() ?? 0.0,
      virtualRemainingLeaves: (json['virtual_remaining_leaves'] as num?)?.toDouble() ?? 0.0,
      maxLeaves: (json['max_leaves'] as num?)?.toDouble() ?? 0.0,
      accrualBonus: json['accrual_bonus'] as int? ?? 0,
      leavesTaken: (json['leaves_taken'] as num?)?.toDouble() ?? 0.0,
      virtualLeavesTaken: (json['virtual_leaves_taken'] as num?)?.toDouble() ?? 0.0,
      leavesRequested: (json['leaves_requested'] as num?)?.toDouble() ?? 0.0,
      leavesApproved: (json['leaves_approved'] as num?)?.toDouble() ?? 0.0,
      closestAllocationRemaining: (json['closest_allocation_remaining'] as num?)?.toDouble() ?? 0.0,
      closestAllocationExpire: json['closest_allocation_expire'] as bool? ?? false,
      holdsChanges: json['holds_changes'] as bool? ?? false,
      totalVirtualExcess: (json['total_virtual_excess'] as num?)?.toDouble() ?? 0.0,
      virtualExcessData: (json['virtual_excess_data'] as Map<String, dynamic>?) ?? {},
      exceedingDuration: (json['exceeding_duration'] as num?)?.toDouble() ?? 0.0, // <--- يجب أن تكون .toDouble()
      requestUnit: json['request_unit'] as String? ?? 'day',
      icon: json['icon'] as String? ?? '',
      allowsNegative: json['allows_negative'] as bool? ?? false,
      maxAllowedNegative: json['max_allowed_negative'] as int? ?? 0,
      closestAllocationDuration: json['closest_allocation_duration'],
      overtimeDeductible: json['overtime_deductible'] as bool? ?? false,
    );
  }


  HolidayTypeDetailsEntity toEntity() {
    return HolidayTypeDetailsEntity(
      remainingLeaves: remainingLeaves,
      virtualRemainingLeaves: virtualRemainingLeaves,
      maxLeaves: maxLeaves,
      accrualBonus: accrualBonus,
      leavesTaken: leavesTaken,
      virtualLeavesTaken: virtualLeavesTaken,
      leavesRequested: leavesRequested,
      leavesApproved: leavesApproved,
      closestAllocationRemaining: closestAllocationRemaining,
      closestAllocationExpire: closestAllocationExpire,
      holdsChanges: holdsChanges,
      totalVirtualExcess: totalVirtualExcess,
      virtualExcessData: virtualExcessData,
      exceedingDuration: exceedingDuration,
      requestUnit: requestUnit,
      icon: icon,
      allowsNegative: allowsNegative,
      maxAllowedNegative: maxAllowedNegative,
      closestAllocationDuration: closestAllocationDuration,
      overtimeDeductible: overtimeDeductible,
    );
  }
}