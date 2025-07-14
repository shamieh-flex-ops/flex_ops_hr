import 'package:flex_ops_hr/components/app_text_field.dart';
import 'package:flex_ops_hr/core/utils/app_assets.dart';
import 'package:flex_ops_hr/core/utils/app_theme.dart';
import 'package:flex_ops_hr/features/auth_screens/presentation/controller/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';




class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      final loginProvider = context.read<LoginProvider>();
      await loginProvider.login(
        email: _emailController.text,
        password: _passwordController.text,
          rememberMe: _rememberMe,

      );

      if (loginProvider.loginResult != null) {
        print(loginProvider.loginResult);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تسجيل الدخول بنجاح')),
        );
        // context.go('/home');
      } else if (loginProvider.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loginProvider.errorMessage!)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.watch<LoginProvider>();

    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 100.h),
                Center(
                  child: SvgPicture.asset(
                    AppAssets.logoSvg,
                    height: 200.h,
            
                    colorFilter: ColorFilter.mode(AppColors.primaryBlue, BlendMode.srcIn),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'Human Resources Application',
                  style: AppTextStyles.headline1.copyWith(color: AppColors.textDark),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Login to your account',
                  style: AppTextStyles.bodyText1.copyWith(color: AppColors.textMedium),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40.h),
                AppTextField(
                  controller: _emailController,
                  labelText: 'Email Address',
                  hintText: 'Enter your email',
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textMedium),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter your email';
                    // if (!value.contains('@')) return 'Please enter a valid email';
                    return null;
                  },
                ),
                SizedBox(height: 20.h),
                AppTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  obscureText: _obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textMedium),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textMedium,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter your password';
                    // if (value.length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (newValue) => setState(() => _rememberMe = newValue ?? false),
                          activeColor: AppColors.primaryBlue,
                          checkColor: AppColors.white,
                        ),
                        Text(
                          'Remember me',
                          style: AppTextStyles.bodyText1.copyWith(color: AppColors.textDark),
                        ),
                      ],
                    ),
  //                   TextButton(
  //                     onPressed: () {
  //  Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
  //   );
  //                     },
  //                     child: Text(
  //                       'Forgot Password?',
  //                       style: AppTextStyles.bodyText1.copyWith(color: AppColors.primaryBlue),
  //                     ),
  //                   ),
                  ],
                ),
                SizedBox(height: 24.h),
                loginProvider.loginState.name == "loading"
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        child: Text(
                          'Login',
                          style: AppTextStyles.buttonText.copyWith(color: AppColors.white),
                        ),
                      ),
       
  
         
              ],
            ),
          ),
        ),
      ),
    );
  }
}
