import 'package:flex_ops_hr/core/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';


class DateInputWidget extends StatelessWidget {
  final String label;
  final DateTime? date;
  final Function(BuildContext) onTap;
  final String hint;
  final bool isRequired;

  const DateInputWidget({
    Key? key,
    required this.label,
    required this.date,
    required this.onTap,
    required this.hint,
    this.isRequired = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyText1.copyWith(color: AppColors.textDark),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: () => onTap(context),
          child: AbsorbPointer(
            child: TextFormField(
              readOnly: true,
              controller: TextEditingController(
                text: date != null ? DateFormat('yyyy-MM-dd').format(date!) : '',
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide.none,
                ),
                hintText: hint,
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              validator: (value) {
                if (isRequired && (value == null || value.isEmpty)) {
                  return 'Please select a $label';
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}