import 'package:flex_ops_hr/core/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserProfileSection extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userProfilePicUrl;

  const UserProfileSection({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userProfilePicUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Profile Image
        CircleAvatar(
          radius: 32.r,
          backgroundImage: NetworkImage(userProfilePicUrl),
        ),
        SizedBox(width: 16.w),

        // Name and Email
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: AppTextStyles.headline1.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                userEmail,
                style: AppTextStyles.bodyText1.copyWith(
                  color: AppColors.textMedium,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

