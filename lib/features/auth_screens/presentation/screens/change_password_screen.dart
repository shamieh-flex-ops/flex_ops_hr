// lib/features/login/presentation/screens/change_password_screen.dart

import 'package:flex_ops_hr/components/app_text_field.dart';
import 'package:flex_ops_hr/core/utils/app_theme.dart';
import 'package:flex_ops_hr/features/auth_screens/presentation/controller/change_password_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isObscureOld = true;
  bool _isObscureNew = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _handleChangePassword() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<ChangePasswordProvider>(context, listen: false);
      provider.changePassword(
        oldPassword: _oldPasswordController.text.trim(),
        newPassword: _newPasswordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Change Password',
          style: AppTextStyles.headline1.copyWith(color: AppColors.textDark, fontSize: 20.sp),
        ),
        centerTitle: true,
      ),
      body: Consumer<ChangePasswordProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 40.h),

                    Text(
                      'Change your password securely',
                      style: AppTextStyles.bodyText1.copyWith(color: AppColors.textMedium),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40.h),

                    AppTextField(
                      controller: _oldPasswordController,
                      labelText: 'Old Password',
                      hintText: 'Enter old password',
                      obscureText: _isObscureOld,
                      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textMedium),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscureOld ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.textMedium,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscureOld = !_isObscureOld;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter old password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.h),

                    AppTextField(
                      controller: _newPasswordController,
                      labelText: 'New Password',
                      hintText: 'Enter new password',
                      obscureText: _isObscureNew,
                      prefixIcon: const Icon(Icons.lock_open, color: AppColors.textMedium),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isObscureNew ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.textMedium,
                        ),
                        onPressed: () {
                          setState(() {
                            _isObscureNew = !_isObscureNew;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter new password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30.h),

                    SizedBox(
                      width: double.infinity,
                      child: provider.state == ChangePasswordState.loading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: _handleChangePassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryBlue,
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              child: Text(
                                'Change Password',
                                style: AppTextStyles.buttonText.copyWith(color: AppColors.white),
                              ),
                            ),
                    ),

                    if (provider.state == ChangePasswordState.error)
                      Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: Text(
                          provider.errorMessage ?? 'Something went wrong',
                          style: TextStyle(color: Colors.red, fontSize: 14.sp),
                        ),
                      ),

                    if (provider.state == ChangePasswordState.success)
                      Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: Text(
                          provider.response?.statusMessage ?? 'Password changed successfully',
                          style: TextStyle(color: Colors.green, fontSize: 14.sp),
                        ),
                      ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
