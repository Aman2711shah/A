import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Vibrant and modern like Clubhouse
  static const Color primary = Color(0xFF3B82F6); // Bright blue
  static const Color primaryLight = Color(0xFF60A5FA); // Sky blue
  static const Color primaryDark = Color(0xFF1D4ED8); // Deep blue
  static const Color tertiary = Color(0xFF8B5CF6); // Purple
  static const Color tertiaryLight = Color(0xFFA78BFA); // Light purple
  static const Color tertiaryDark = Color(0xFF7C3AED); // Deep purple

  // Secondary Colors - Warm and vibrant
  static const Color secondary = Color(0xFFF97316); // Orange
  static const Color secondaryLight = Color(0xFFFB923C); // Light orange
  static const Color secondaryDark = Color(0xFFEA580C); // Deep orange

  // Neutral Colors - Modern grayscale palette
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF111827); // Neutral-900
  static const Color grey = Color(0xFF6B7280); // Neutral-500
  static const Color lightGrey = Color(0xFFF9FAFB); // Neutral-50
  static const Color darkGrey = Color(0xFF374151); // Neutral-700
  static const Color border = Color(0xFFE5E7EB); // Neutral-200
  static const Color borderSubtle = Color(0xFFF3F4F6); // Neutral-100
  static const Color borderDark = Color(0xFF4B5563); // Neutral-600
  static const Color borderSubtleDark = Color(0xFF1F2937); // Neutral-800
  static const Color shadow = Color(0x1A111827); // Neutral-900 with opacity

  // Text Colors - Better contrast and readability
  static const Color textPrimary = Color(0xFF111827); // Neutral-900
  static const Color textSecondary = Color(0xFF6B7280); // Neutral-500
  static const Color textHint = Color(0xFF9CA3AF); // Neutral-400
  static const Color textMuted = Color(0xFFD1D5DB); // Neutral-300
  static const Color textPrimaryDark = Color(0xFFF9FAFB); // Neutral-50
  static const Color textSecondaryDark = Color(0xFFD1D5DB); // Neutral-300

  // Status Colors - Vibrant and fun
  static const Color success = Color(0xFF22C55E); // Green
  static const Color warning = Color(0xFFF59E0B); // Yellow
  static const Color error = Color(0xFFEF4444); // Red
  static const Color info = Color(0xFF06B6D4); // Cyan

  // Clubhouse-inspired vibrant colors
  static const Color orange = Color(0xFFFF6B35); // Coral orange
  static const Color yellow = Color(0xFFF1C21B); // Bright yellow
  static const Color green = Color(0xFF00D9FF); // Cyan
  static const Color pink = Color(0xFFE91E63); // Pink
  static const Color coral = Color(0xFFFF5722); // Coral
  static const Color lime = Color(0xFF8BC34A); // Lime green

  // Background Colors - Clean and modern
  static const Color background = Color(0xFFFAFAFA); // Very light gray
  static const Color surface = Color(0xFFFFFFFF); // Pure white
  static const Color surfaceMuted = Color(0xFFF5F5F5); // Light gray
  static const Color backgroundDark = Color(0xFF0F172A); // Dark slate
  static const Color surfaceDark = Color(0xFF1E293B); // Slate
  static const Color surfaceVariantDark = Color(0xFF334155); // Light slate
  static const Color backgroundLight = background;

  // Vibrant Gradients - Clubhouse-inspired
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, tertiary],
    stops: [0.0, 1.0],
  );

  static const LinearGradient orangeGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, orange],
    stops: [0.0, 1.0],
  );

  static const LinearGradient yellowGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [yellow, secondary],
    stops: [0.0, 1.0],
  );

  static const LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [tertiary, primary],
    stops: [0.0, 1.0],
  );

  static const LinearGradient cyanGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [green, info],
    stops: [0.0, 1.0],
  );

  static const LinearGradient pinkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [pink, coral],
    stops: [0.0, 1.0],
  );

  // Vibrant Card Backgrounds - Clubhouse style
  static const Color cardOrange = Color(0xFFFF6B35); // Coral orange
  static const Color cardYellow = Color(0xFFF1C21B); // Bright yellow
  static const Color cardPurple = Color(0xFF8B5CF6); // Purple
  static const Color cardBlue = Color(0xFF3B82F6); // Blue
  static const Color cardGreen = Color(0xFF00D9FF); // Cyan
  static const Color cardPink = Color(0xFFE91E63); // Pink
  static const Color cardTeal = Color(0xFF06B6D4); // Teal
  static const Color cardLime = Color(0xFF8BC34A); // Lime

  // Light versions for backgrounds
  static const Color lightOrange = Color(0xFFFFF4F0); // Light orange bg
  static const Color lightYellow = Color(0xFFFFFBE6); // Light yellow bg
  static const Color lightPurple = Color(0xFFF3F0FF); // Light purple bg
  static const Color lightBlue = Color(0xFFEFF6FF); // Light blue bg
  static const Color lightGreen = Color(0xFFE6FFFF); // Light cyan bg
  static const Color lightPink = Color(0xFFFCE4EC); // Light pink bg

  // Dynamic opacity helpers
  static Color get white70 => white.withValues(alpha: 0.7);
  static Color get white24 => white.withValues(alpha: 0.24);
}
