import 'package:flutter/material.dart';

class WazeetLogo extends StatelessWidget {
  final double size;
  final Color? color;

  const WazeetLogo({
    super.key,
    this.size = 40,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final logoColor = color ?? const Color(0xFFB8860B);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            logoColor,
            logoColor.withValues(alpha: 0.8),
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: logoColor.withValues(alpha: 0.3),
            blurRadius: size * 0.2,
            offset: Offset(0, size * 0.1),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Shield background
          Icon(
            Icons.shield,
            size: size * 0.8,
            color: Colors.white,
          ),
          // Building/skyline icon
          Positioned(
            bottom: size * 0.25,
            child: Icon(
              Icons.location_city,
              size: size * 0.3,
              color: logoColor,
            ),
          ),
        ],
      ),
    );
  }
}

class WazeetLogoText extends StatelessWidget {
  final double fontSize;
  final Color? color;
  final bool showTagline;

  const WazeetLogoText({
    super.key,
    this.fontSize = 24,
    this.color,
    this.showTagline = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? const Color(0xFFB8860B);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Wazeet',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: textColor,
            letterSpacing: 1.2,
          ),
        ),
        if (showTagline) ...[
          SizedBox(height: fontSize * 0.2),
          Text(
            'Business Setup Partner',
            style: TextStyle(
              fontSize: fontSize * 0.4,
              color: textColor.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

class WazeetLogoWithText extends StatelessWidget {
  final double logoSize;
  final double fontSize;
  final Color? color;
  final bool showTagline;
  final MainAxisAlignment alignment;

  const WazeetLogoWithText({
    super.key,
    this.logoSize = 40,
    this.fontSize = 24,
    this.color,
    this.showTagline = false,
    this.alignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        WazeetLogo(size: logoSize, color: color),
        SizedBox(width: logoSize * 0.3),
        WazeetLogoText(
          fontSize: fontSize,
          color: color,
          showTagline: showTagline,
        ),
      ],
    );
  }
}
