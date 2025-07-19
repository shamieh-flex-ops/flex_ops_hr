// lib/features/resignation/presentation/screens/resignation_status_details_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flex_ops_hr/core/utils/app_theme.dart';
import 'package:flex_ops_hr/features/resignation/domain/entities/resignation_entities.dart';

class ResignationStatusDetailsPage extends StatelessWidget {
  final ResignationGroup group;

  const ResignationStatusDetailsPage({super.key, required this.group});

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
        child: group.resignations.isEmpty
            ? Center(
                child: Text(
                  'No resignations available in this group.',
                  style: AppTextStyles.bodyText1,
                ),
              )
            : ListView.separated(
                itemCount: group.resignations.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final resignation =
                      group.resignations[index];
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
                        _buildDetailRow('Name:', resignation.name),
                        _buildDetailRow(
                            'Employee Name:', resignation.employeeName),
                        _buildDetailRow(
                            'Department:', resignation.departmentName),
                        _buildDetailRow('Job:', resignation.jobName),
                        _buildDetailRow('Resignation Date:',
                            resignation.resignationDate ?? 'N/A'),
                        _buildDetailRow(
                            'Resignation Type:', resignation.resignationType),
                        _buildDetailRow('Types of End Services:',
                            resignation.typesOfEndServices),
                        _buildDetailRow('Leave Date:', resignation.leaveDate),
                        _buildDetailRow(
                            'Notice Period:', '${resignation.noticePeriod}'),
                        _buildDetailRow('Note:', resignation.note),
                        _buildDetailRow('State:', resignation.state),
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
