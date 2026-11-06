import 'package:flutter/material.dart';

/// Paleta de colores del Sistema de Gestión Pet Shop.
/// Basada en el diseño del documento: rosa coral sobre fondo crema.
class AppColors {
  static const primary = Color(0xFFFF5C86);
  static const primaryDark = Color(0xFFE84571);
  static const primarySoft = Color(0xFFFFE7EE);
  static const ink = Color(0xFF232323);
  static const inkSoft = Color(0xFF6F6A6B);
  static const inkMuted = Color(0xFF9C9697);
  static const bg = Color(0xFFFDF9F6);
  static const surface = Colors.white;
  static const border = Color(0xFFF1E7E3);
  static const success = Color(0xFF3FB984);
  static const successSoft = Color(0xFFE4F6EE);
  static const warning = Color(0xFFE9A23B);
  static const warningSoft = Color(0xFFFDF1DC);
  static const danger = Color(0xFFE85D5D);
  static const dangerSoft = Color(0xFFFCE8E8);
  static const info = Color(0xFF5B8DEF);
  static const infoSoft = Color(0xFFE8EFFF);
  static const cream = Color(0xFFFFF3EA);
  static const lilac = Color(0xFFF1ECFF);
  static const mint = Color(0xFFE8F8F1);
}

/// Estilos de texto reutilizables.
class AppText {
  static const hero = TextStyle(
    fontSize: 44,
    fontWeight: FontWeight.w900,
    height: 1.08,
    letterSpacing: -1.4,
    color: AppColors.ink,
  );
  static const h1 = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w900,
    height: 1.15,
    letterSpacing: -0.8,
    color: AppColors.ink,
  );
  static const h2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w800,
    height: 1.2,
    letterSpacing: -0.4,
    color: AppColors.ink,
  );
  static const h3 = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w800,
    height: 1.25,
    color: AppColors.ink,
  );
  static const body = TextStyle(
    fontSize: 14.5,
    height: 1.55,
    color: AppColors.inkSoft,
  );
  static const bodySmall = TextStyle(
    fontSize: 13,
    height: 1.5,
    color: AppColors.inkSoft,
  );
  static const label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.1,
    color: AppColors.inkMuted,
  );
  static const price = TextStyle(
    fontSize: 19,
    fontWeight: FontWeight.w900,
    letterSpacing: -0.4,
    color: AppColors.ink,
  );
}

class AppTheme {
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.primary,
        surface: AppColors.surface,
      ),
      scaffoldBackgroundColor: AppColors.bg,
    );

    return base.copyWith(
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionColor: AppColors.primarySoft,
        selectionHandleColor: AppColors.primary,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(color: AppColors.inkMuted, fontSize: 14),
        labelStyle: const TextStyle(color: AppColors.inkSoft, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: _inputBorder(AppColors.border),
        enabledBorder: _inputBorder(AppColors.border),
        focusedBorder: _inputBorder(AppColors.primary, width: 1.6),
        errorBorder: _inputBorder(AppColors.danger),
        focusedErrorBorder: _inputBorder(AppColors.danger, width: 1.6),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.ink,
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: AppColors.inkSoft),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.ink,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primarySoft,
        height: 70,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: states.contains(WidgetState.selected)
                ? AppColors.primary
                : AppColors.inkMuted,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 22,
            color: states.contains(WidgetState.selected)
                ? AppColors.primary
                : AppColors.inkMuted,
          ),
        ),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStatePropertyAll(
          AppColors.inkMuted.withValues(alpha: 0.35),
        ),
        radius: const Radius.circular(8),
        thickness: const WidgetStatePropertyAll(6),
      ),
    );
  }

  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
