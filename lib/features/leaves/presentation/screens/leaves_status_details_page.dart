import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:flex_ops_hr/core/utils/app_theme.dart';
import 'package:flex_ops_hr/features/leaves/domain/entities/leave_status_group.dart';

class LeaveStatusDetailsPage extends StatelessWidget {
  final LeaveStatusGroup group;

  const LeaveStatusDetailsPage({super.key, required this.group});

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
            'No leaves available.',
            style: AppTextStyles.bodyText1,
          ),
        )
            : ListView.separated(
          itemCount: group.leaves.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final leave = group.leaves[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
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
                    leave.leaveType,
                    style: AppTextStyles.headline1,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Text('Employee: ', style: AppTextStyles.cardTitle),
                      Expanded(
                        child: Text(leave.employeeName, style: AppTextStyles.bodyText1),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Days: ', style: AppTextStyles.cardTitle),
                      Text('${leave.numberOfDays}', style: AppTextStyles.bodyText1),
                    ],
                  ),
                  Row(
                    children: [
                      Text('From: ', style: AppTextStyles.cardTitle),
                      Text(leave.requestDateFrom, style: AppTextStyles.bodyText1),
                    ],
                  ),
                  Row(
                    children: [
                      Text('To: ', style: AppTextStyles.cardTitle),
                      Text(leave.requestDateTo, style: AppTextStyles.bodyText1),
                    ],
                  ),
                  Row(
                    children: [
                      Text('State: ', style: AppTextStyles.cardTitle),
                      Text(leave.state, style: AppTextStyles.bodyText1),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// GoRouter usage:
// context.push('/home/leaves/status_details', extra: group);
