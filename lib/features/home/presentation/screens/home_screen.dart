import 'package:flex_ops_hr/core/utils/app_theme.dart';
import 'package:flex_ops_hr/features/home/presentation/widgets/bottom_nav_bar_with_fab.dart';
import 'package:flex_ops_hr/features/home/presentation/widgets/leave_options_bottom_sheet.dart';
import 'package:flex_ops_hr/features/home/presentation/widgets/main_cards_grid.dart';
import 'package:flex_ops_hr/features/home/presentation/widgets/user_profile_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = "Husam Mustafa";
  String userEmail = "husam.mustafa@example.com";
  String userProfilePicUrl =
      "https://cdn.pixabay.com/photo/2013/05/24/18/06/person-113427_1280.jpg";

  final LatLng companyFixedLocation = const LatLng(31.9539, 35.9106);
  LatLng? currentDeviceLocation;

  void updateCurrentDeviceLocation(LatLng? location) {
    setState(() {
      currentDeviceLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 900 ? 4 : (screenWidth > 600 ? 3 : 2);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlue,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: AppColors.cardBackground),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          'HR Management',
          style: AppTextStyles.headline1.copyWith(
            color: AppColors.cardBackground,
            fontSize: 22.sp,
          ),
        ),
        centerTitle: true,
      ),
      // drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),
            UserProfileSection(
              userName: userName,
              userEmail: userEmail,
              userProfilePicUrl: userProfilePicUrl,
            ),
            SizedBox(height: 20.h),
            // CompanyLocationMap(
            //   companyLocation: _companyFixedLocation,
            //   onLocationDetermined: _updateCurrentDeviceLocation,
            // ),
            SizedBox(height: 15.h),
            // ChangeNotifierProvider(
            //   create: (context) => AttendanceProvider(),
            //   child: AttendanceTimerSection(
            //     currentDeviceLocation: _currentDeviceLocation,
            //   ),
            // ),
            SizedBox(height: 20.h),
            MainCardsGrid(crossAxisCount: crossAxisCount),
            SizedBox(height: 24.h),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => BottomSheetHelper.showLeaveOptions(context),
        backgroundColor: AppColors.primaryBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.r),
        ),
        elevation: 5,
        child: Icon(Icons.add, color: AppColors.white, size: 30.sp),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomNavBarWithFab(),
    );
  }
}


