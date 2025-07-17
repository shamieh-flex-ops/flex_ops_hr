// lib/presentation/widgets/main_cards_grid.dart

import 'package:flex_ops_hr/features/home/presentation/widgets/main_card.dart';
import 'package:flex_ops_hr/features/loans/presentation/controller/loan_provider.dart';
import 'package:flex_ops_hr/features/payslips/presentation/controller/payslip_provider.dart';
import 'package:flex_ops_hr/features/resignation/presentation/controller/resignation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../leaves/presentation/controller/leave_status_provider.dart';

class MainCardsGrid extends StatelessWidget {
  final int crossAxisCount;
  const MainCardsGrid({super.key, required this.crossAxisCount});

  @override
  Widget build(BuildContext context) {
    final cards = _staticCardData();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      itemCount: cards.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 16.w,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final item = cards[index];
        return MainCard(
          title: item.title,
          icon: item.icon,
          iconColor: item.iconColor,
          iconBackgroundColor: item.backgroundColor,
          onTap: () async {
            switch (item.title) {
              case 'Leaves':
                context.push('/home/leaves');
                final provider =
                    Provider.of<LeaveStatusProvider>(context, listen: false);
                await provider.fetchLeaveStatusGroups();
                break;
              case 'Payslips':
                context.push('/home/payslips');
                final provider =
                    Provider.of<PayslipProvider>(context, listen: false);
                await provider.fetchPayslips();
                break;
              case 'Loans':
                context.push('/home/loans');
                final loanProvider =
                    Provider.of<LoanProvider>(context, listen: false);
                await loanProvider.fetchLoanGroups();
                break;
              case 'Resignations':
                context.push('/home/resignations');
                final provider =
                    Provider.of<ResignationProvider>(context, listen: false);
                await provider.fetchResignationGroups();
                break;
                  case 'Renew Iqama':
                context.push('/home/iqama-renewals');
                final provider =
                    Provider.of<ResignationProvider>(context, listen: false);
                await provider.fetchResignationGroups();
                break;
              default:
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Coming Soon...")),
                );
                break;
            }
          },
        );
      },
    );
  }
}

class CardDataModel {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  CardDataModel({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });
}

List<CardDataModel> _staticCardData() => [
      CardDataModel(
        title: 'Attendance',
        icon: Icons.access_time,
        iconColor: Colors.orange,
        backgroundColor: Colors.orange.shade100,
      ),
      CardDataModel(
        title: 'Leaves',
        icon: Icons.beach_access,
        iconColor: Colors.teal,
        backgroundColor: Colors.teal.shade100,
      ),
      CardDataModel(
        title: 'Payslips',
        icon: Icons.receipt_long,
        iconColor: Colors.blue,
        backgroundColor: Colors.blue.shade100,
      ),
      CardDataModel(
        title: 'Loans',
        icon: Icons.request_page,
        iconColor: Colors.purple,
        backgroundColor: Colors.purple.shade100,
      ),
      CardDataModel(
        title: 'Resignations',
        icon: Icons.timelapse,
        iconColor: Colors.indigo,
        backgroundColor: Colors.indigo.shade100,
      ),
      CardDataModel(
        title: 'Renew Iqama',
        icon: Icons.folder,
        iconColor: Colors.green,
        backgroundColor: Colors.green.shade100,
      ),
      CardDataModel(
        title: 'Employees',
        icon: Icons.group,
        iconColor: Colors.red,
        backgroundColor: Colors.red.shade100,
      ),
      CardDataModel(
        title: 'Settings',
        icon: Icons.settings,
        iconColor: Colors.grey,
        backgroundColor: Colors.grey.shade300,
      ),
    ];
