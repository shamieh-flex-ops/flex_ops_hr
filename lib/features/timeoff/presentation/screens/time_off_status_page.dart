// lib/features/timeoff/presentation/screens/time_off_status_page.dart

import 'package:flex_ops_hr/features/timeoff/presentation/controllers/time_off_status_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:flex_ops_hr/core/utils/app_theme.dart';
import 'package:flex_ops_hr/components/rectangular_cards_grid.dart';
import 'package:flex_ops_hr/core/utils/enums.dart';



class TimeOffStatusPage extends StatefulWidget {
  const TimeOffStatusPage({super.key});

  @override
  State<TimeOffStatusPage> createState() => _TimeOffStatusPageState();
}

class _TimeOffStatusPageState extends State<TimeOffStatusPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<TimeOffStatusProvider>(context, listen: false)
            .fetchTimeOffStatusGroupsAndTypes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLightBlue,
      appBar: AppBar(
        title: Text(
          'Time Off Status',
          style: AppTextStyles.headline1.copyWith(color: AppColors.textDark),
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
                    label: 'Request Time Off',
                    color: Colors.blue,
                    onTap: () {
                      context.push('/home/time_off/request_time_off', extra: {
                        'formType': TimeOffFormType.timeOff,
                        'availableTypes': Provider.of<TimeOffStatusProvider>(
                            context,
                            listen: false)
                            .availableTimeOffTypes,
                      });
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildTopShortcutCard(
                    icon: Icons.timer,
                    label: 'Request Leave',
                    color: Colors.green,
                    onTap: () {
                      context.push('/home/time_off/request_leave', extra: {
                        'formType': TimeOffFormType.specificLeaves,
                        'availableTypes': Provider.of<TimeOffStatusProvider>(
                            context,
                            listen: false)
                            .availableTimeOffTypes,
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Consumer<TimeOffStatusProvider>(
              builder: (context, provider, child) {
                if (provider.state == AppRequesState.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (provider.state == AppRequesState.error) {
                  return Center(
                      child: Text(provider.errorMessage ??
                          'Failed to load time off status.'));
                } else if (provider.timeOffStatusGroups.isEmpty) {
                  return const Center(
                      child: Text('No time off history available.'));
                } else {
                  return Expanded(
                    child: RectangularCardsGrid(
                      cards: provider.timeOffStatusGroups.map((group) {
                        return RectangularCardData(
                          title: group.description,
                          icon: Icons.calendar_today,
                          badgeCount: group.leaveCount,
                          onTap: () {
                            if ((group.leaveCount ?? 0) > 0) {
                              context.push('/home/time_off/status_details',
                                  extra: group);
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
                  );
                }
              },
            ),
            SizedBox(height: 24.h),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  context.push('/home/time_off/my_leaves_info');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'My Leaves Info',
                  style: AppTextStyles.buttonText.copyWith(color: AppColors.white),
                ),
              ),
            ),
            SizedBox(height: 16.h),
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
          boxShadow: const [
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