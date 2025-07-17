// lib/features/loans/presentation/screens/loans_screen.dart

import 'package:flex_ops_hr/core/utils/app_theme.dart';
import 'package:flex_ops_hr/core/utils/constances.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flex_ops_hr/core/utils/enums.dart';
import 'package:flex_ops_hr/features/loans/presentation/controller/loan_provider.dart';
import 'package:flex_ops_hr/features/loans/domain/entities/loan_entities.dart';

class LoansScreen extends StatefulWidget {
  const LoansScreen({super.key});

  @override
  State<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends State<LoansScreen> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<LoanProvider>(context, listen: false).fetchLoanGroups();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLightBlue,
      appBar: AppBar(
        title: Text('Loans', style: AppTextStyles.headline1.copyWith(color: AppColors.white)),
        backgroundColor: AppColors.primaryBlue,
         actions: [
    IconButton(
      icon: const Icon(Icons.add),
      tooltip: 'Create Loan',
      onPressed: () {
        context.push('/home/loans/create');
      },
    ),
  ],
      ),
      body: Consumer<LoanProvider>(
        builder: (context, provider, _) {
          if (provider.state == AppRequesState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.state == AppRequesState.error) {
            return Center(
              child: Text(
                provider.errorMessage ?? 'Error occurred',
                style: TextStyle(color: Colors.red, fontSize: 16.sp),
              ),
            );
          } else if (provider.loanGroups.isEmpty) {
            return const Center(child: Text(AppConstants.noDataAvailable));
          } else {
            return ListView.separated(
              padding: EdgeInsets.all(16.w),
              itemCount: provider.loanGroups.length,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final group = provider.loanGroups[index];
                return _buildLoanGroupCard(group);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildLoanGroupCard(LoanGroup group) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              group.description,
              style: AppTextStyles.headline1.copyWith(fontSize: 18.sp),
            ),
            SizedBox(height: 8.h),
            Text('Total Loans: ${group.loanCount}', style: AppTextStyles.headline1),
            SizedBox(height: 8.h),
            if (group.loans.isNotEmpty)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: group.loans.length,
                separatorBuilder: (_, __) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  final loan = group.loans[index];
                  return _buildLoanTile(loan);
                },
              )
          ],
        ),
      ),
    );
  }

  Widget _buildLoanTile(Loan loan) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Loan: ${loan.name}', style: AppTextStyles.headline1),
          SizedBox(height: 4.h),
          Text('Employee: ${loan.employeeName}', style: AppTextStyles.headline1),
          Text('Department: ${loan.departmentName}', style: AppTextStyles.headline1),
          Text('Job: ${loan.jobName}', style: AppTextStyles.headline1),
          Text('Amount: \$${loan.loanAmount.toStringAsFixed(2)}', style: AppTextStyles.headline1),
          Text('Installments: ${loan.installment}', style: AppTextStyles.headline1),
          Text('Payment Date: ${loan.paymentDate}', style: AppTextStyles.headline1),
          Text('Requested On: ${loan.date}', style: AppTextStyles.headline1),
          Text('Reason: ${loan.reason}', style: AppTextStyles.headline1),
        ],
      ),
    );
  }
}
