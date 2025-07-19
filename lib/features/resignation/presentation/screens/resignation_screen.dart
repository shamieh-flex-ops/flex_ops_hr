// lib/features/resignation/presentation/screens/resignation_screen.dart

import 'package:flex_ops_hr/core/utils/enums.dart';
import 'package:flex_ops_hr/features/resignation/presentation/controller/resignation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// ✅ استيراد AppColors و AppTextStyles
import 'package:flex_ops_hr/core/utils/app_theme.dart';

// ✅ استيراد RectangularCardsGrid
import 'package:flex_ops_hr/components/rectangular_cards_grid.dart';

class ResignationScreen extends StatefulWidget {
  const ResignationScreen({super.key});

  @override
  State<ResignationScreen> createState() => _ResignationScreenState();
}

class _ResignationScreenState extends State<ResignationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ResignationProvider>(context, listen: false)
          .fetchResignationGroups();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLightBlue,
      appBar: AppBar(
        title: Text(
          'Resignation',
          style: AppTextStyles.headline1.copyWith(
              color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryBlue,
        actions: [
          IconButton(
            icon: Icon(Icons.add, size: 24.sp, color: AppColors.white),
            tooltip: 'Create Resignation',
            onPressed: () {
              context.push('/home/resignations/create');
            },
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Consumer<ResignationProvider>(
              builder: (context, provider, _) {
                switch (provider.state) {
                  case AppRequesState.loading:
                    return const Expanded(
                        child: Center(
                            child:
                                CircularProgressIndicator()));
                  case AppRequesState.error:
                    return Expanded(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0.w),
                          child: Text(
                            provider.errorMessage ?? 'Something went wrong',
                            style: AppTextStyles.bodyText1
                                .copyWith(color: AppColors.error),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  case AppRequesState.loaded:
                    if (provider.resignationGroups.isEmpty) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            'No resignation history available.',
                            style: AppTextStyles.bodyText1,
                          ),
                        ),
                      );
                    } else {
                      return Expanded(
                        child: RectangularCardsGrid(
                          cards: provider.resignationGroups.map((group) {
                            return RectangularCardData(
                              title: group.description,
                              icon: Icons.person_off,
                              badgeCount: group.resignationCount,
                              onTap: () {
                                if ((group.resignationCount ?? 0) > 0) {
                                  context.push(
                                      '/home/resignations/resignation_details',
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
                  default:
                    return const Expanded(child: SizedBox());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
