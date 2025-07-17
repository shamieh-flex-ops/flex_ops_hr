// lib/features/payslips/presentation/pages/payslips_page.dart

import 'package:flex_ops_hr/core/network/api_constance.dart';
import 'package:flex_ops_hr/core/utils/app_theme.dart';
import 'package:flex_ops_hr/core/utils/enums.dart';
import 'package:flex_ops_hr/features/payslips/presentation/controller/payslip_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PayslipsPage extends StatefulWidget {
  const PayslipsPage({super.key});

  @override
  State<PayslipsPage> createState() => _PayslipsPageState();
}

class _PayslipsPageState extends State<PayslipsPage> {
  @override
  void initState() {
    super.initState();
    // Future.microtask(() =>
    //     Provider.of<PayslipProvider>(context, listen: false).fetchPayslips());
  }

  Future<void> _launchPdf(String? url) async {
    if (url == null || url.isEmpty) return;
    final uri = Uri.parse("${ApiConstance.domain}$url.pdf");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to launch PDF')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Payslips',
          style: AppTextStyles.headline1.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primaryBlue,
      ),
      backgroundColor: AppColors.backgroundLightBlue,
      body: Consumer<PayslipProvider>(
        builder: (context, provider, _) {
          if (provider.state == AppRequesState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.state == AppRequesState.error) {
            return Center(
              child: Text(
                provider.errorMessage ?? 'Something went wrong.',
                style: TextStyle(fontSize: 16.sp, color: Colors.red),
              ),
            );
          }

          final payslipGroups = provider.payslipGroups;

          return Padding(
            padding: EdgeInsets.all(16.w),
            child: ListView.builder(
              itemCount: payslipGroups.length,
              itemBuilder: (context, groupIndex) {
                final group = payslipGroups[groupIndex];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (group.payslipCount > 0)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Text(
                          'Status: ${group.state}',
                          style: AppTextStyles.headline1
                              .copyWith(fontSize: 18.sp),
                        ),
                      ),
                    ...group.payslips.map(
                      (payslip) => Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        elevation: 3,
                        margin: EdgeInsets.symmetric(vertical: 10.h),
                        child: InkWell(
                          onTap: () => _launchPdf(payslip.reportPdfUrlEn),
                          borderRadius: BorderRadius.circular(16.r),
                          child: Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Icon(
                                    Icons.picture_as_pdf,
                                    size: 40.sp,
                                    color: AppColors.primaryBlue,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  'Employee: ${payslip.employeeName}',
                                  style: AppTextStyles.headline1,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'Period: ${payslip.dateFrom} → ${payslip.dateTo}',
                                  style: AppTextStyles.bodyText1,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'Basic Salary: ${payslip.basicSalary} \$',
                                  style: AppTextStyles.bodyText1,
                                ),
                                SizedBox(height: 12.h),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    'Tap to view PDF',
                                    style: AppTextStyles.bodyText1.copyWith(
                                      fontSize: 12.sp,
                                      color: AppColors.success,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
