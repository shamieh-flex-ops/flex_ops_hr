// lib/features/time_off/presentation/screens/time_off_status_details_page.dart

import 'package:flex_ops_hr/core/utils/app_theme.dart';
import 'package:flex_ops_hr/features/timeoff/domain/entities/time_off_status_group_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class TimeOffStatusDetailsPage extends StatelessWidget {
  final TimeOffStatusGroupEntity group;

  const TimeOffStatusDetailsPage({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLightBlue,
      appBar: AppBar(
        title: Text(
          group.description,
          style: AppTextStyles.headline1.copyWith(color: AppColors.primaryBlue),
        ),
        centerTitle: true,
        backgroundColor: AppColors.cardBackground,
        elevation: 1,
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: group.leaves.isEmpty
            ? Center(
          child: Text(
            'No time off requests in this group.', 
            style: AppTextStyles.bodyText1,
          ),
        )
            : ListView.separated(
          itemCount: group.leaves.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final timeOff = group.leaves[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    timeOff.holidayStatusId.name,
                    style: AppTextStyles.headline1,
                  ),
                  SizedBox(height: 8.h),
                  _buildDetailRow('Employee:', timeOff.employeeId.name), 
                  _buildDetailRow('Number of Days:', '${timeOff.numberOfDays.toStringAsFixed(1)} days'), 
                  _buildDetailRow('Request Date From:', timeOff.requestDateFrom), 
                  _buildDetailRow('Request Date To:', timeOff.requestDateTo), 
                  _buildDetailRow('Date From:', timeOff.dateFrom), 
                  _buildDetailRow('Date To:', timeOff.dateTo), 
                  _buildDetailRow('State:', timeOff.state), 
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label ', style: AppTextStyles.cardTitle),
          Expanded(
            child: Text(value, style: AppTextStyles.bodyText1),
          ),
        ],
      ),
    );
  }
}