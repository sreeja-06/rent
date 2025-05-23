import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  AppTheme._();
  
  static const String _fontFamily = 'Poppins';
  
  static final TextTheme _textTheme = TextTheme(
    displayLarge: _baseTextStyle(32, FontWeight.bold, letterSpacing: -0.5),
    displayMedium: _baseTextStyle(28, FontWeight.bold),
    displaySmall: _baseTextStyle(24, FontWeight.w600),
    headlineMedium: _baseTextStyle(20, FontWeight.w600),
    titleLarge: _baseTextStyle(18, FontWeight.w600),
    titleMedium: _baseTextStyle(16, FontWeight.w500),
    titleSmall: _baseTextStyle(14, FontWeight.w500),
    bodyLarge: _baseTextStyle(16, FontWeight.normal),
    bodyMedium: _baseTextStyle(14, FontWeight.normal),
    bodySmall: _baseTextStyle(12, FontWeight.normal),
    labelLarge: _baseTextStyle(14, FontWeight.w500),
  );

  static TextStyle _baseTextStyle(double fontSize, FontWeight fontWeight, {double? letterSpacing}) {
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
      height: 1.2,
    );
  }
  
  static ThemeData _baseTheme(Brightness brightness, ColorScheme colorScheme) {
    final isDark = brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      fontFamily: _fontFamily,
      textTheme: _textTheme,
      
      // App wide configurations
      scaffoldBackgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      cardColor: colorScheme.surface,
      dividerColor: isDark ? Colors.white12 : Colors.black12,
      
      // Component themes
      appBarTheme: _appBarTheme(colorScheme, _textTheme),
      cardTheme: _cardTheme(),
      elevatedButtonTheme: _elevatedButtonTheme(colorScheme, _textTheme),
      outlinedButtonTheme: _outlinedButtonTheme(colorScheme, _textTheme),
      textButtonTheme: _textButtonTheme(_textTheme),
      inputDecorationTheme: _inputDecorationTheme(colorScheme, _textTheme),
      bottomNavigationBarTheme: _bottomNavTheme(colorScheme, _textTheme),
      dialogTheme: _dialogTheme(colorScheme, _textTheme),
      chipTheme: _chipTheme(colorScheme, _textTheme),
      snackBarTheme: _snackBarTheme(colorScheme, _textTheme),
      tabBarTheme: _tabBarTheme(colorScheme, _textTheme),
      listTileTheme: _listTileTheme(colorScheme, _textTheme),
    );
  }

  // Component theme definitions
  static AppBarTheme _appBarTheme(ColorScheme colors, TextTheme text) {
    return AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: colors.surface,
      foregroundColor: colors.onSurface,
      titleTextStyle: text.titleLarge?.copyWith(color: colors.onSurface),
      iconTheme: IconThemeData(color: colors.onSurface),
    );
  }

  static CardTheme _cardTheme() {
    return CardTheme(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(ColorScheme colors, TextTheme text) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: text.labelLarge,
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme(ColorScheme colors, TextTheme text) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.primary,
        side: BorderSide(color: colors.primary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: text.labelLarge,
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme(TextTheme text) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: text.labelLarge,
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(ColorScheme colors, TextTheme text) {
    return InputDecorationTheme(
      filled: true,
      fillColor: colors.surfaceVariant.withOpacity(0.3),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: colors.primary,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(
          color: colors.error,
          width: 1.5,
        ),
      ),
      labelStyle: text.bodyMedium?.copyWith(
        color: colors.onSurfaceVariant,
      ),
      hintStyle: text.bodyMedium?.copyWith(
        color: colors.onSurfaceVariant.withOpacity(0.6),
      ),
    );
  }

  static BottomNavigationBarThemeData _bottomNavTheme(ColorScheme colors, TextTheme text) {
    return BottomNavigationBarThemeData(
      backgroundColor: colors.surface,
      selectedItemColor: colors.primary,
      unselectedItemColor: colors.onSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: text.bodySmall,
      unselectedLabelStyle: text.bodySmall,
    );
  }

  static DialogTheme _dialogTheme(ColorScheme colors, TextTheme text) {
    return DialogTheme(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      titleTextStyle: text.titleLarge?.copyWith(
        color: colors.onSurface,
      ),
      contentTextStyle: text.bodyMedium?.copyWith(
        color: colors.onSurfaceVariant,
      ),
    );
  }

  static ChipThemeData _chipTheme(ColorScheme colors, TextTheme text) {
    return ChipThemeData(
      backgroundColor: colors.surfaceVariant,
      labelStyle: text.bodySmall?.copyWith(
        color: colors.onSurfaceVariant,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  static SnackBarThemeData _snackBarTheme(ColorScheme colors, TextTheme text) {
    return SnackBarThemeData(
      backgroundColor: colors.inverseSurface,
      contentTextStyle: text.bodyMedium?.copyWith(color: colors.onInverseSurface),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      behavior: SnackBarBehavior.floating,
    );
  }

  static TabBarTheme _tabBarTheme(ColorScheme colors, TextTheme text) {
    return TabBarTheme(
      labelColor: colors.primary,
      unselectedLabelColor: colors.onSurfaceVariant,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: text.titleSmall,
      unselectedLabelStyle: text.titleSmall,
    );
  }

  static ListTileThemeData _listTileTheme(ColorScheme colors, TextTheme text) {
    return ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      dense: true,
      horizontalTitleGap: 8,
      minLeadingWidth: 24,
      titleTextStyle: text.bodyLarge,
      subtitleTextStyle: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
    );
  }

  static final ThemeData lightTheme = _baseTheme(
    Brightness.light,
    ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      surface: Colors.white,
      background: AppColors.backgroundLight,
    ),
  );
  
  static final ThemeData darkTheme = _baseTheme(
    Brightness.dark,
    ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      surface: const Color(0xFF1E1E1E),
      background: AppColors.backgroundDark,
    ),
  );
}

