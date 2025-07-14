import 'package:flex_ops_hr/core/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../controller/profile_provider.dart';
import '../widgets/bottom_nav_bar.dart';

class ProfileDetailsPage extends StatefulWidget {
  const ProfileDetailsPage({super.key});

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => Provider.of<ProfileProvider>(context, listen: false)
        .fetchUserProfile());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);
    final profile = provider.profile;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Details', style: AppTextStyles.headline1),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : provider.errorMessage != null
                ? Center(child: Text(provider.errorMessage!))
                : profile == null
                    ? const Center(child: Text("No profile data available."))
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 40.r,
                                  backgroundColor:
                                      AppColors.primaryBlue.withOpacity(0.2),
                                  child: ClipOval(
                                    child: SizedBox(
                                      width: 80.w,
                                      height: 80.h,
                                      child: Image.network(
                                        profile.imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15.w),
                                Text(
                                  'Personal Information',
                                  style: AppTextStyles.headline1
                                      .copyWith(fontSize: 20.sp),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            const Divider(),
                            _buildTile(
                                title: 'Name',
                                value: profile.name,
                                icon: Icons.badge_outlined),
                            _buildTile(
                                title: 'Email',
                                value: profile.email,
                                icon: Icons.email_outlined),
                            _buildTile(
                                title: 'Phone',
                                value: profile.phone,
                                icon: Icons.phone_outlined),
                            _buildTile(
                                title: 'Address',
                                value: profile.address,
                                icon: Icons.location_on_outlined),
                            SizedBox(height: 5.h),
                            Text(
                              'Job Information',
                              style: AppTextStyles.headline1
                                  .copyWith(fontSize: 20.sp),
                            ),
                            const Divider(),
                            _buildTile(
                                title: 'Position',
                                value: profile.position,
                                icon: Icons.work_outline),
                            _buildTile(
                                title: 'Start Date',
                                value: profile.startDate,
                                icon: Icons.calendar_month_outlined),
                            _buildTile(
                                title: 'Salary',
                                value: profile.salary,
                                icon: Icons.attach_money_outlined),
                            SizedBox(height: 24.h),
                          ],
                        ),
                      ),
      ),
      // bottomNavigationBar: const BottomNavBarWithFab(),
    );
  }

  Widget _buildTile(
      {required String title, required String value, required IconData icon}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textMedium),
      title: Text(title, style: AppTextStyles.bodyText1),
      subtitle: Text(
        value,
        style: AppTextStyles.bodyText1.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
