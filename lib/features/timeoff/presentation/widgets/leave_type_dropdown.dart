// lib/features/timeoff/presentation/widgets/leave_type_dropdown.dart

import 'package:collection/collection.dart';
import 'package:flex_ops_hr/core/utils/app_theme.dart';
import 'package:flex_ops_hr/core/utils/enums.dart';
import 'package:flex_ops_hr/features/timeoff/domain/entities/holiday_status_id_entity.dart';
import 'package:flex_ops_hr/features/timeoff/presentation/controllers/time_off_status_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class LeaveTypeDropdown extends StatelessWidget {
  final HolidayStatusIdEntity? selectedLeaveType;
  final ValueChanged<HolidayStatusIdEntity?> onChanged;
  final bool isForTimeOffPage; // <--- هذا الاسم سيبقى كما هو

  const LeaveTypeDropdown({
    Key? key,
    required this.selectedLeaveType,
    required this.onChanged,
    this.isForTimeOffPage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TimeOffStatusProvider>(
      builder: (context, provider, child) {
        if (provider.state == AppRequesState.loading) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isForTimeOffPage ? 'Time Off Type' : 'Leave Type',
                style: AppTextStyles.bodyText1.copyWith(color: AppColors.textDark),
              ),
              SizedBox(height: 8.h),
              const Center(child: CircularProgressIndicator()),
              SizedBox(height: 16.h),
            ],
          );
        }
        if (provider.state == AppRequesState.error) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isForTimeOffPage ? 'Time Off Type' : 'Leave Type',
                style: AppTextStyles.bodyText1.copyWith(color: AppColors.textDark),
              ),
              SizedBox(height: 8.h),
              Center(
                child: Text(
                  'Error loading types: ${provider.errorMessage ?? "Unknown error"}',
                  style: AppTextStyles.bodyText1.copyWith(color: AppColors.error),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          );
        }

        List<HolidayStatusIdEntity> apiTypes = provider.availableTimeOffTypes;
        List<HolidayStatusIdEntity> displayTypes = [];


        const String sickLeaveAPIName = "Sick Time Off";
        const String permissionAPIName = "Permission";

        if (isForTimeOffPage) {
          displayTypes = apiTypes.where((type) {
            return type.name != sickLeaveAPIName && type.name != permissionAPIName;
          }).toList();
        } else {
          final sickLeaveType = apiTypes.firstWhereOrNull(
                (type) => type.name == sickLeaveAPIName,
          );
          if (sickLeaveType != null) {
            displayTypes.add(sickLeaveType);
          }

          final permissionType = apiTypes.firstWhereOrNull(
                (type) => type.name == permissionAPIName,
          );
          if (permissionType != null) {
            displayTypes.add(permissionType);
          } else {
            displayTypes.add(HolidayStatusIdEntity(id: -1, name: 'Permission (Hourly) - Not available'));
          }
        }

        if (displayTypes.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isForTimeOffPage ? 'Time Off Type' : 'Leave Type',
                style: AppTextStyles.bodyText1.copyWith(color: AppColors.textDark),
              ),
              SizedBox(height: 8.h),
              Text(
                isForTimeOffPage
                    ? 'No relevant time off types available.'
                    : 'No sick or permission leave types available from API.',
                style: AppTextStyles.bodyText1.copyWith(color: AppColors.error),
              ),
              SizedBox(height: 16.h),
            ],
          );
        }

        final HolidayStatusIdEntity? currentValue = selectedLeaveType != null &&
            displayTypes.any((type) => type.id == selectedLeaveType!.id)
            ? selectedLeaveType
            : null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isForTimeOffPage ? 'Time Off Type' : 'Leave Type',
              style: AppTextStyles.bodyText1.copyWith(color: AppColors.textDark),
            ),
            SizedBox(height: 8.h),
            DropdownButtonFormField<HolidayStatusIdEntity>(
              value: currentValue,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide.none,
                ),
                hintText: isForTimeOffPage ? 'Select Time Off Type' : 'Select Leave Type',
              ),
              items: displayTypes.map((HolidayStatusIdEntity type) {
                bool isDisabled = type.id == -1 && type.name == 'Permission (Hourly) - Not available';
                return DropdownMenuItem<HolidayStatusIdEntity>(
                  value: type,
                  enabled: !isDisabled,
                  child: Text(
                    type.name,
                    style: TextStyle(
                      color: isDisabled ? AppColors.grey : AppColors.textDark,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (HolidayStatusIdEntity? newValue) {
                if (newValue != null && newValue.id == -1 && newValue.name == 'Permission (Hourly) - Not available') {
                  print('Attempted to select disabled placeholder.');
                  return;
                }
                onChanged(newValue);
              },
              validator: (value) {
                if (value == null) {
                  return isForTimeOffPage ? 'Please select a time off type' : 'Please select a leave type';
                }
                if (value.id == -1 && value.name == 'Permission (Hourly) - Not available') {
                  return 'This leave type is not available.';
                }
                return null;
              },
            ),
            SizedBox(height: 16.h),
          ],
        );
      },
    );
  }
}