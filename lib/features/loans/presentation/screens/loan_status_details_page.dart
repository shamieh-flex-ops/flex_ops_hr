// lib/features/loans/presentation/screens/loan_status_details_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flex_ops_hr/core/utils/app_theme.dart';
import 'package:flex_ops_hr/features/loans/domain/entities/loan_entities.dart';

class LoanStatusDetailsPage extends StatelessWidget {
  final LoanGroup group;

  const LoanStatusDetailsPage({super.key, required this.group});

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
        child: group.loans.isEmpty
            ? Center(
          child: Text(
            'No loans available in this group.',
            style: AppTextStyles.bodyText1,
          ),
        )
            : ListView.separated(
          itemCount: group.loans.length,
          separatorBuilder: (_, __) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            final loan = group.loans[index];
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
                    loan.name, // اسم القرض
                    style: AppTextStyles.headline1,
                  ),
                  SizedBox(height: 8.h),
                  _buildDetailRow('Employee:', loan.employeeName),
                  _buildDetailRow('Department:', loan.departmentName),
                  _buildDetailRow('Job:', loan.jobName),
                  _buildDetailRow('Amount:', '\$${loan.loanAmount.toStringAsFixed(2)}'),
                  _buildDetailRow('Installments:', '${loan.installment}'),
                  _buildDetailRow('Payment Date:', loan.paymentDate),
                  _buildDetailRow('Requested On:', loan.date),
                  _buildDetailRow('Reason:', loan.reason),
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