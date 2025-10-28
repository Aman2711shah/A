import 'package:flutter/material.dart';

/// App gradients inspired by Clubhouse and modern social apps
class AppGradients {
  // Clubhouse-style primary gradients
  static const orangeGradient = LinearGradient(
    colors: [Color(0xFFFF9B73), Color(0xFFFF7A45)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const yellowGradient = LinearGradient(
    colors: [Color(0xFFFFF5A1), Color(0xFFFFE273)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const lightBlueGradient = LinearGradient(
    colors: [Color(0xFFBEE7FF), Color(0xFF94D4FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const purpleGradient = LinearGradient(
    colors: [Color(0xFFD4B9FF), Color(0xFFB986FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Primary brand gradients
  static const primaryGradient = LinearGradient(
    colors: [Color(0xFF3478F6), Color(0xFFB86EF3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const accentGradient = LinearGradient(
    colors: [Color(0xFFFF8A3D), Color(0xFFFFB67A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Background gradients
  static const sunsetGradient = LinearGradient(
    colors: [Color(0xFFFFF1E3), Color(0xFFFFDCC4), Color(0xFFFFC0A1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const oceanGradient = LinearGradient(
    colors: [Color(0xFFE7F5FF), Color(0xFFCBE9FF), Color(0xFF9FD4FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const mintGradient = LinearGradient(
    colors: [Color(0xFFEFFFF4), Color(0xFFE1FFE9), Color(0xFFC8F8D5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const lavenderGradient = LinearGradient(
    colors: [Color(0xFFF1E8FF), Color(0xFFE0CCFF), Color(0xFFC9A9FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Card gradients
  static const goldCardGradient = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFFE55C), Color(0xFFFFEC8B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const silverCardGradient = LinearGradient(
    colors: [Color(0xFFE8E8E8), Color(0xFFF5F5F5), Color(0xFFFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const premiumCardGradient = LinearGradient(
    colors: [Color(0xFF1A237E), Color(0xFF283593), Color(0xFF3F51B5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Category gradients
  static const tradeLicenseGradient = LinearGradient(
    colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const visaGradient = LinearGradient(
    colors: [Color(0xFFF093FB), Color(0xFFF5576C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const companySetupGradient = LinearGradient(
    colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const bankAccountGradient = LinearGradient(
    colors: [Color(0xFF43E97B), Color(0xFF38F9D7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const officeSpaceGradient = LinearGradient(
    colors: [Color(0xFFFA709A), Color(0xFFFEE140)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const consultingGradient = LinearGradient(
    colors: [Color(0xFF30CFD0), Color(0xFF330867)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shimmer gradient for loading
  static const shimmerGradient = LinearGradient(
    colors: [
      Color(0xFFEBEBF4),
      Color(0xFFF4F4F4),
      Color(0xFFEBEBF4),
    ],
    stops: [0.1, 0.3, 0.4],
    begin: Alignment(-1.0, -0.3),
    end: Alignment(1.0, 0.3),
  );

  // Success/Error gradients
  static const successGradient = LinearGradient(
    colors: [Color(0xFF56AB2F), Color(0xFFA8E063)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const errorGradient = LinearGradient(
    colors: [Color(0xFFEB3349), Color(0xFFF45C43)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const warningGradient = LinearGradient(
    colors: [Color(0xFFF2994A), Color(0xFFF2C94C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Helper method to create custom gradient
  static LinearGradient custom({
    required List<Color> colors,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
    List<double>? stops,
  }) {
    return LinearGradient(
      colors: colors,
      begin: begin,
      end: end,
      stops: stops,
    );
  }
}
