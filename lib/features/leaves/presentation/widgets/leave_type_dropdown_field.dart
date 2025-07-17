// lib/presentation/pages/leaves/widgets/leave_type_dropdown_field.dart

import 'package:flex_ops_hr/core/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flex_ops_hr/features/leaves/domain/entities/leave_type_entity.dart'; // تأكد من المسير الصحيح للـ LeaveTypeEntity

class LeaveTypeDropdownField extends StatelessWidget {
  final LeaveTypeEntity? value;
  final List<LeaveTypeEntity> items;
  final ValueChanged<LeaveTypeEntity?> onChanged;
  final FormFieldValidator<LeaveTypeEntity?>? validator;
  final String hintText;

  const LeaveTypeDropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.hintText = 'Select an option',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Leave Type',
          style: AppTextStyles.bodyText1.copyWith(color: AppColors.textDark, fontSize: 14.sp),
        ),
        SizedBox(height: 8.h),
        DropdownButtonFormField<LeaveTypeEntity>(
          value: value,
          items: items.map((LeaveTypeEntity type) {
            return DropdownMenuItem<LeaveTypeEntity>(
              value: type,
              child: Text(
                type.name,
                style: AppTextStyles.bodyText1.copyWith(fontSize: 14.sp, color: AppColors.textDark),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator ?? (val) => val == null ? 'Please select a leave type' : null,
          hint: Text(
            hintText,
            style: AppTextStyles.bodyText1.copyWith(color: AppColors.textMedium, fontSize: 14.sp),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide.none, // DropdownButtonFormField usually uses underline, but border can be customized
            ),
            enabledBorder: OutlineInputBorder( // هذا مهم للحفاظ على نفس شكل الـ AppTextField
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: AppColors.textDark, width: 1.w),
            ),
            focusedBorder: OutlineInputBorder( // عندما يتم التركيز عليه
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: AppColors.primaryBlue, width: 2.w),
            ),
            errorBorder: OutlineInputBorder( // عند وجود خطأ في التحقق
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: AppColors.primaryBlue, width: 2.w), // عادة يكون أحمر، لكن استخدمت الأزرق حسب الـ AppTextField
            ),
            focusedErrorBorder: OutlineInputBorder( // عند التركيز على حقل به خطأ
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: AppColors.primaryBlue, width: 2.w),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          ),
          dropdownColor: AppColors.white, // لون خلفية القائمة المنسدلة عند فتحها
          icon: Icon(Icons.arrow_drop_down, color: AppColors.textMedium, size: 24.w), // أيقونة السهم
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}