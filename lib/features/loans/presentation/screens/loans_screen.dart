// lib/features/loans/presentation/screens/loans_screen.dart

import 'package:flex_ops_hr/core/utils/app_theme.dart';
import 'package:flex_ops_hr/core/utils/constances.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flex_ops_hr/core/utils/enums.dart';
import 'package:flex_ops_hr/features/loans/presentation/controller/loan_provider.dart';
// لا نحتاج Loan_entities هنا لأننا لن نعرض تفاصيل فردية مباشرة
// import 'package:flex_ops_hr/features/loans/domain/entities/loan_entities.dart';

// ✅ استيراد RectangularCardsGrid
import 'package:flex_ops_hr/components/rectangular_cards_grid.dart';


class LoansScreen extends StatefulWidget {
  const LoansScreen({super.key});

  @override
  State<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends State<LoansScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LoanProvider>(context, listen: false).fetchLoanGroups();
    });
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
            icon: const Icon(Icons.add,color:Colors.white,),
            tooltip: 'Create Loan',
            onPressed: () {
              context.push('/home/loans/create');
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [

            Consumer<LoanProvider>(
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
                  return Expanded(
                    child: RectangularCardsGrid(
                      cards: provider.loanGroups.map((group) {
                        return RectangularCardData(
                          title: group.description,
                          icon: Icons.attach_money,
                          badgeCount: group.loanCount,
                          onTap: () {
                            if ((group.loanCount ?? 0) > 0) {
                              context.push('/home/loans/loan_details',
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
          ],
        ),
      ),
    );
  }
}