import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:flex_ops_hr/core/utils/app_theme.dart';
import 'package:flex_ops_hr/features/leaves/domain/entities/leave_status_group.dart';
import 'package:flex_ops_hr/features/leaves/presentation/controller/leave_status_provider.dart';
import '../../../../components/rectangular_cards_grid.dart';

class LeavesStatusPage extends StatelessWidget {
  const LeavesStatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LeaveStatusProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundLightBlue,
      appBar: AppBar(
        title: Text(
          'Leave Status',
          style: AppTextStyles.headline1,
        ),
        centerTitle: true,
        backgroundColor: AppColors.cardBackground,
        elevation: 1,
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildTopShortcutCard(
                    icon: Icons.beach_access,
                    label: 'Time Off',
                    color: Colors.blue,
                    onTap: () => context.push('/home/leaves/time_off'),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildTopShortcutCard(
                    icon: Icons.timer,
                    label: 'Leave',
                    color: Colors.green,
                    onTap: () => context.push('/home/leaves/request_leave'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            if (provider.leaveStatusGroups == null)
              const Center(child: CircularProgressIndicator())
            else
              RectangularCardsGrid(
                cards: provider.leaveStatusGroups!.map((group) {
                  return RectangularCardData(
                    title: group.description,
                    icon: Icons.calendar_today,
                    badgeCount: group.leaveCount,
                    onTap: () {
                      if ((group.leaveCount ?? 0) > 0) {
                        context.push('/home/leaves/status_details', extra: group);
                      }
                    },
                    route: '',
                  );
                }).toList(),
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                mainAxisSpacing: 12.h,
                crossAxisSpacing: 12.w,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopShortcutCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: Colors.white, size: 20.sp),
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: AppTextStyles.cardTitle,
            ),
          ],
        ),
      ),
    );
  }
}
