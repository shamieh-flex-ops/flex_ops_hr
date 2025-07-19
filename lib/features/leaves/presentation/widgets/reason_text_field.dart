// lib/presentation/pages/leaves/widgets/reason_text_field.dart

import 'package:flex_ops_hr/core/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReasonTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final FormFieldValidator<String?>? validator;

  const ReasonTextField({
    super.key,
    required this.controller,
    this.hintText = 'Enter reason for leave...',
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reason',
          style: AppTextStyles.bodyText1.copyWith(color: AppColors.textDark, fontSize: 14.sp),
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          maxLines: 3,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none,
            ),
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 14.sp),
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          ),
          validator: validator ?? (value) => value!.isEmpty ? 'Please enter a reason' : null,
        ),
      ],
    );
  }
}