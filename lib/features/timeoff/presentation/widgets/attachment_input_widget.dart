import 'package:flex_ops_hr/core/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttachmentInputWidget extends StatelessWidget {
  final String? selectedAttachmentPath;
  final VoidCallback onBrowsePressed;

  const AttachmentInputWidget({
    Key? key,
    required this.selectedAttachmentPath,
    required this.onBrowsePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attachment',
          style: AppTextStyles.bodyText1.copyWith(color: AppColors.textDark),
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                readOnly: true,
                controller:
                    TextEditingController(text: selectedAttachmentPath ?? ''),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'No file selected',
                ),
              ),
            ),
            SizedBox(width: 8.w),
            ElevatedButton(
              onPressed: onBrowsePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Text(
                'Browse',
                style:
                    AppTextStyles.buttonText.copyWith(color: AppColors.white),
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
      ],
    );
  }
}
