// lib/core/app_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primaryBlue = Color(0xFF1A73E8); // أزرق أساسي
  static const Color accentBlue = Color(0xFF4285F4); // أزرق مكمل/مميز
  static const Color darkBlue = Color(0xFF0D47A1); // أزرق داكن
  static const Color lightBlue = Color(0xFFBBDEFB); // أزرق فاتح جداً
  static const Color backgroundLightBlue = Color(0xFFE8F0FE);//هاد فاتح كثير

  // ألوان النص
  static const Color textDark = Color(0xFF212121); // نص داكن
  static const Color textMedium = Color(0xFF757575); // نص متوسط
  static const Color textLight = Color(0xFFBDBDBD); // نص فاتح

  // ألوان الخلفية
  static const Color background = Color(0xFFF5F5F5); // خلفية التطبيق
  static const Color cardBackground = Color(0xFFFFFFFF); // خلفية البطاقات

  // ألوان الحالات (النجاح، الخطأ، التحذير)
  static const Color success = Color(0xFF4CAF50); // أخضر للنجاح
  static const Color error = Color(0xFFF44336); // أحمر للخطأ
  static const Color warning = Color(0xFFFFC107); // أصفر للتحذير


  static const Color iconColorDarkBlue =
  Color(0xFF1A73E8); // لون الأيقونة الأزرق الداكن
  static const Color iconBgLightBlue =
  Color(0xFFE3F2FD); // لون خلفية الأيقونة الأزرق الفاتح

  // الألوان المتعلقة بالزيادة/النقصان إذا كنت ستستخدمها لاحقاً
  static const Color increaseColor = Color(0xFF4CAF50); // أخضر للزيادة
  static const Color decreaseColor = Color(0xFFF44336); // أحمر للنقصان
  static const Color noChangeColor = Color(0xFF757575); // رمادي لعدم التغيير

  static const Color white = Colors.white; // أبيض
  static const Color black = Colors.black; // أسود
  static const Color grey = Color(0xFF9E9E9E); // رمادي
  static const Color darkGrey = Color(0xFF616161); // رمادي داكن
  static const Color lightGrey = Color(0xFFEEEEEE); // رمادي فاتح جداً
}

// هذا الـ extension يجب أن يكون هنا، خارج أي كلاس
extension ColorToHex on Color {
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

class AppTextStyles {
  // نمط الخط العام
  static TextStyle get _baseTextStyle =>
      GoogleFonts.cairo(); // استخدام خط Cairo

  // العناوين الرئيسية في الـ AppBar
  static TextStyle get headline1 => _baseTextStyle.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  // أنماط نصوص البطاقات الرئيسية
  static TextStyle get cardTitle => _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  // أنماط الأزرار والـ Bottom Navigation Bar
  static TextStyle get buttonText => _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static TextStyle get bottomNavItemText => _baseTextStyle.copyWith(
    fontSize: 12,
    color: AppColors.textMedium, // لون افتراضي
  );

  // أنماط الـ Drawer
  static TextStyle get drawerItemTitle => _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );

  // أنماط أخرى قد تحتاجها
  static TextStyle get bodyText1 => _baseTextStyle.copyWith(
    fontSize: 14,
    color: AppColors.textDark,
  );
}

// تعريف الثيم الرئيسي للتطبيق
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primaryBlue,
      scaffoldBackgroundColor: AppColors.backgroundLightBlue,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.cardBackground, // خلفية AppBar بيضاء
        elevation: 0, // إزالة الظل من AppBar
        iconTheme:
        IconThemeData(color: AppColors.textDark), // لون أيقونات AppBar
      ),
      cardTheme: CardTheme(
        color: AppColors.cardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      // إعدادات الخطوط الافتراضية
      fontFamily: GoogleFonts.cairo().fontFamily,
      textTheme: TextTheme(
        displayLarge: AppTextStyles.headline1,
        bodyLarge: AppTextStyles.bodyText1,
        // يمكنك إضافة المزيد من أنماط النصوص هنا حسب الحاجة
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor:
        AppColors.cardBackground, // خلفية بيضاء للـ BottomNavBar
        selectedItemColor: AppColors.primaryBlue, // لون العنصر المختار
        unselectedItemColor: AppColors.textMedium, // لون العنصر غير المختار
        showUnselectedLabels: true,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}