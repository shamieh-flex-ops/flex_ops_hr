import 'package:flex_ops_hr/core/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onSubmit;

  const SubmitButton({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: onSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child: Text(
          'Submit Request',
          style: AppTextStyles.buttonText.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}
