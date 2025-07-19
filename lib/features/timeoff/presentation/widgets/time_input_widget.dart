import 'package:flex_ops_hr/core/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimeInputWidget extends StatelessWidget {
  final String label;
  final TimeOfDay? time;
  final Function(BuildContext) onTap;
  final String hint;
  final bool isRequired;

  const TimeInputWidget({
    Key? key,
    required this.label,
    required this.time,
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
                text: time != null ? time!.format(context) : '',
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide.none,
                ),
                hintText: hint,
                suffixIcon: const Icon(Icons.access_time),
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
