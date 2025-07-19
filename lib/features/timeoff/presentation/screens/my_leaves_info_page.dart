// lib/features/timeoff/presentation/screens/my_leaves_info_page.dart

import 'package:flex_ops_hr/core/utils/app_theme.dart';
import 'package:flex_ops_hr/core/utils/enums.dart'; // نحتاج لـ AppRequesState
import 'package:flex_ops_hr/features/timeoff/domain/entities/holiday_status_id_entity.dart';
import 'package:flex_ops_hr/features/timeoff/presentation/controllers/time_off_status_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // تم التصحيح هنا
import 'package:provider/provider.dart';

class MyLeavesInfoPage extends StatefulWidget {
  const MyLeavesInfoPage({super.key});

  @override
  State<MyLeavesInfoPage> createState() => _MyLeavesInfoPageState();
}

class _MyLeavesInfoPageState extends State<MyLeavesInfoPage> {
  @override
  void initState() {
    super.initState();
    // تأكد من جلب بيانات الإجازات عند فتح هذه الصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 🚨 هذا هو التعديل الوحيد المطلوب في هذا الملف
      // استدعاء fetchAvailableLeaveTypes() لجلب تفاصيل أرصدة الإجازات
      Provider.of<TimeOffStatusProvider>(context, listen: false)
          .fetchAvailableLeaveTypes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLightBlue,
      appBar: AppBar(
        title: Text(
          'My Leaves Info',
          style: AppTextStyles.headline1.copyWith(color: AppColors.primaryBlue),
        ),
        centerTitle: true,
        backgroundColor: AppColors.cardBackground,
        elevation: 1,
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: Consumer<TimeOffStatusProvider>(
        builder: (context, provider, child) {
          if (provider.state == AppRequesState.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.state == AppRequesState.error) {
            return Center(
              child: Text(
                'Error loading leaves info: ${provider.errorMessage ?? "Unknown error"}',
                style: AppTextStyles.bodyText1.copyWith(color: AppColors.error),
                textAlign: TextAlign.center,
              ),
            );
          }
          if (provider.availableTimeOffTypes.isEmpty) {
            return Center(
              child: Text(
                'No leave types information available.',
                style: AppTextStyles.bodyText1,
                textAlign: TextAlign.center,
              ),
            );
          }

          // تصفية الأنواع التي تحتوي على تفاصيل (details)
          // هذا يضمن أننا نعرض فقط أنواع الإجازات التي لديها معلومات رصيد.
          final List<HolidayStatusIdEntity> leavesWithDetails =
          provider.availableTimeOffTypes.where((leave) => leave.details != null).toList();

          if (leavesWithDetails.isEmpty) {
            return Center(
              child: Text(
                'No detailed leave information available.',
                style: AppTextStyles.bodyText1,
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(16.w),
            itemCount: leavesWithDetails.length,
            separatorBuilder: (_, __) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final leaveType = leavesWithDetails[index];
              final details = leaveType.details!; // نعرف أنها ليست null بسبب التصفية

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        leaveType.name,
                        style: AppTextStyles.headline1.copyWith(color: AppColors.primaryBlue),
                      ),
                      SizedBox(height: 12.h),
                      // عرض التفاصيل باستخدام _buildDetailRow
                      _buildDetailRow('Remaining Leaves:', '${details.remainingLeaves.toStringAsFixed(1)} ${details.requestUnit}s'),
                      _buildDetailRow('Virtual Remaining Leaves:', '${details.virtualRemainingLeaves.toStringAsFixed(1)} ${details.requestUnit}s'),
                      _buildDetailRow('Max Leaves:', '${details.maxLeaves.toStringAsFixed(1)} ${details.requestUnit}s'),
                      _buildDetailRow('Leaves Taken:', '${details.leavesTaken.toStringAsFixed(1)} ${details.requestUnit}s'),
                      _buildDetailRow('Leaves Requested:', '${details.leavesRequested.toStringAsFixed(1)} ${details.requestUnit}s'),
                      _buildDetailRow('Leaves Approved:', '${details.leavesApproved.toStringAsFixed(1)} ${details.requestUnit}s'),
                      _buildDetailRow('Request Unit:', details.requestUnit.toUpperCase()),
                      _buildDetailRow('Allows Negative:', details.allowsNegative ? 'Yes' : 'No'),
                      if (details.allowsNegative) // عرض هذا الحقل فقط إذا كانت 'allowsNegative' صحيحة
                        _buildDetailRow('Max Allowed Negative:', '${details.maxAllowedNegative.toStringAsFixed(0)} ${details.requestUnit}s'),
                      // يمكنك إضافة المزيد من التفاصيل هنا حسب الحاجة مثل accrualBonus, icon, إلخ.
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label ', style: AppTextStyles.bodyText1.copyWith(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(value, style: AppTextStyles.bodyText1),
          ),
        ],
      ),
    );
  }
}