import 'dart:ui';
import 'package:flutter/material.dart';

// Enhanced futuristic color palette
class AppColors {
  // Primary colors
  static const Color primaryDark = Color(0xFF050B18);  // Darker background
  static const Color primary = Color(0xFF0A1428);      // Darker primary
  static const Color primaryLight = Color(0xFF1E3A5F); // Slightly brighter
  
  // Accent colors with more vibrant hues
  static const Color accent = Color(0xFF00F0FF);       // More vibrant cyan
  static const Color accentDark = Color(0xFF00B8D4);   // Dark cyan
  static const Color accentLight = Color(0xFF80FFFF);  // Light cyan
  
  // Secondary accents for visual interest
  static const Color secondary = Color(0xFFAE52FF);    // Vibrant purple
  static const Color tertiary = Color(0xFFFF2A6D);     // Vibrant pink
  static const Color quaternary = Color(0xFF14F195);   // Neo mint
  
  // Neutrals
  static const Color background = Color(0xFF050A15);   // Nearly black background
  static const Color surface = Color(0xFF0E1C32);      // Dark surface
  static const Color cardLight = Color(0xFF1A2A4A);    // Light card
  static const Color cardDark = Color(0xFF102038);     // Dark card
  
  // Text colors
  static const Color textPrimary = Color(0xFFE6F0FF);  // Slightly blue-tinted white
  static const Color textSecondary = Color(0xFFB8C9E6); // Light blue-gray
  static const Color textHint = Color(0xFF8090B0);     // Muted blue-gray
  
  // Status colors
  static const Color success = Color(0xFF00F0B5);      // Teal
  static const Color warning = Color(0xFFFFE83D);      // Bright yellow
  static const Color error = Color(0xFFFF427F);        // Pink-red
  static const Color info = Color(0xFF3D95FF);         // Electric blue
  
  // New tech accent colors
  static const Color energy = Color(0xFFFFB342);       // Energy orange
  static const Color tech = Color(0xFF0095FF);         // Tech blue
  static const Color holographic = Color(0xFFE2F3FF);  // Nearly white with blue tint
  
  // New color
  static const Color green = Color(0xFF43A047); // Vert WildLens
}

// Enhanced typography styles
class AppTextStyles {
  static TextStyle displayLarge = TextStyle(
    fontSize: 38,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.1,
  );
  
  static TextStyle displayMedium = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );
  
  static TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );
  
  static TextStyle subheading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  static TextStyle body = TextStyle(
    fontSize: 16,
    color: AppColors.textSecondary,
    height: 1.5,
  );
  
  static TextStyle bodySmall = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
  );
  
  static TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textHint,
    letterSpacing: 0.2,
  );
  
  static TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
  );
  
  // New tech-specific text styles
  static TextStyle mono = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.accent,
    letterSpacing: 0.5,
    fontFamily: 'monospace',
  );
  
  static TextStyle dataLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: AppColors.quaternary,
    letterSpacing: 1.0,
    fontFamily: 'monospace',
  );
}

// Enhanced border radius values
class AppRadius {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double circular = 1000.0; // For completely round corners
  
  // New shape-specific radius sets
  static BorderRadius buttonRadius = const BorderRadius.only(
    topLeft: Radius.circular(md),
    topRight: Radius.circular(xl),
    bottomLeft: Radius.circular(xl),
    bottomRight: Radius.circular(md),
  );
  
  static BorderRadius cardRadius = const BorderRadius.only(
    topLeft: Radius.circular(lg),
    topRight: Radius.circular(sm),
    bottomLeft: Radius.circular(sm),
    bottomRight: Radius.circular(lg),
  );
}

// Spacing values
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
}

// Enhanced shadows
class AppShadows {
  static BoxShadow small = BoxShadow(
    color: Colors.black.withOpacity(0.15),
    blurRadius: 5,
    offset: const Offset(0, 2),
  );
  
  static BoxShadow medium = BoxShadow(
    color: Colors.black.withOpacity(0.2),
    blurRadius: 10,
    offset: const Offset(0, 4),
  );
  
  static BoxShadow large = BoxShadow(
    color: Colors.black.withOpacity(0.25),
    blurRadius: 20,
    offset: const Offset(0, 8),
  );
  
  static BoxShadow glow = BoxShadow(
    color: AppColors.accent.withOpacity(0.6),
    blurRadius: 20,
    spreadRadius: -2,
  );
  
  static BoxShadow accentGlow = BoxShadow(
    color: AppColors.accent.withOpacity(0.5),
    blurRadius: 16,
    spreadRadius: 0,
  );
  
  static BoxShadow secondaryGlow = BoxShadow(
    color: AppColors.secondary.withOpacity(0.5),
    blurRadius: 16,
    spreadRadius: 0,
  );
  
  static BoxShadow tertiaryGlow = BoxShadow(
    color: AppColors.tertiary.withOpacity(0.5),
    blurRadius: 16,
    spreadRadius: 0,
  );
  
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: AppColors.accent.withOpacity(0.15),
      blurRadius: 15,
      offset: const Offset(0, 4),
    ),
  ];
  
  static List<BoxShadow> neonShadow = [
    BoxShadow(
      color: AppColors.accent.withOpacity(0.5),
      blurRadius: 12,
      spreadRadius: 2,
    ),
    BoxShadow(
      color: AppColors.accent.withOpacity(0.3),
      blurRadius: 30,
      spreadRadius: 0,
    ),
  ];
}

// Enhanced gradients
class AppGradients {
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [AppColors.primary, AppColors.primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [AppColors.accent, AppColors.accentDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [AppColors.cardLight, AppColors.cardDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient futuristicGradient = LinearGradient(
    colors: [AppColors.accent, AppColors.secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient glassGradient = LinearGradient(
    colors: [
      Color(0x40FFFFFF),
      Color(0x10FFFFFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient neonGradient = LinearGradient(
    colors: [AppColors.quaternary, AppColors.accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient energyGradient = LinearGradient(
    colors: [AppColors.tertiary, AppColors.energy],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cyberpunkGradient = LinearGradient(
    colors: [AppColors.accent, AppColors.secondary, AppColors.tertiary],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [
      AppColors.primaryDark,
      AppColors.primary,
      Color(0xFF122348),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// App Theme
ThemeData appTheme = ThemeData(
  scaffoldBackgroundColor: AppColors.background,
  primaryColor: AppColors.primary,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.accent,
    secondary: AppColors.secondary,
    tertiary: AppColors.tertiary,
    background: AppColors.background,
    surface: AppColors.surface,
    error: AppColors.error,
  ),
  textTheme: TextTheme(
    displayLarge: AppTextStyles.displayLarge,
    displayMedium: AppTextStyles.displayMedium,
    titleLarge: AppTextStyles.heading,
    titleMedium: AppTextStyles.subheading,
    bodyLarge: AppTextStyles.body,
    bodyMedium: AppTextStyles.bodySmall,
    labelLarge: AppTextStyles.button,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.accent,
      foregroundColor: AppColors.primaryDark,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      elevation: 0,
    ),
  ),
  cardTheme: CardTheme(
    color: AppColors.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg),
    ),
    elevation: 0,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
  ),
  iconTheme: const IconThemeData(
    color: AppColors.textPrimary,
    size: 24,
  ),
);

// Enhanced helper methods for futuristic UI
class FuturisticUI {
  // Create a futuristic card with glowing border
  static Widget glowCard({
    required Widget child,
    Color glowColor = AppColors.accent,
    double borderRadius = AppRadius.lg,
    EdgeInsets padding = const EdgeInsets.all(AppSpacing.md),
    LinearGradient? gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient ?? AppGradients.cardGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
        border: Border.all(
          color: glowColor.withOpacity(0.4),
          width: 1.5,
        ),
      ),
      padding: padding,
      child: child,
    );
  }
  
  // Create a glass morphism effect container
  static Widget glassContainer({
    required Widget child,
    double borderRadius = AppRadius.lg,
    EdgeInsets padding = const EdgeInsets.all(AppSpacing.md),
    double blurAmount = 8.0,
    double opacity = 0.1,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurAmount, sigmaY: blurAmount),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(opacity + 0.05),
                Colors.white.withOpacity(opacity),
              ],
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1.5,
            ),
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }

  // Create a vibrant neon-bordered container
  static Widget neonContainer({
    required Widget child,
    Color neonColor = AppColors.accent,
    double borderRadius = AppRadius.lg,
    EdgeInsets padding = const EdgeInsets.all(AppSpacing.md),
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: neonColor.withOpacity(0.5),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
        border: Border.all(
          color: neonColor,
          width: 2.0,
        ),
      ),
      padding: padding,
      child: child,
    );
  }
  
  // Create a holographic card effect
  static Widget holographicCard({
    required Widget child,
    double borderRadius = AppRadius.lg,
    EdgeInsets padding = const EdgeInsets.all(AppSpacing.md),
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF283249),
            Color(0xFF1D2B45),
          ],
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
        border: Border.all(
          color: AppColors.holographic.withOpacity(0.3),
          width: 1.0,
        ),
      ),
      padding: padding,
      child: ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) => const LinearGradient(
          colors: [
            AppColors.accent,
            AppColors.secondary,
            AppColors.tertiary,
            AppColors.quaternary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          transform: GradientRotation(0.5),
        ).createShader(
          Rect.fromLTWH(0, 0, bounds.width, bounds.height),
        ),
        child: child,
      ),
    );
  }
  
  // Create a tech-themed button
  static Widget techButton({
    required String label,
    required VoidCallback onPressed,
    Color color = AppColors.accent,
    IconData? icon,
    double height = 56.0,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: AppRadius.buttonRadius,
          border: Border.all(
            color: color.withOpacity(0.5),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: color, size: 20),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(
              label,
              style: AppTextStyles.button.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
  
  // Create a data display panel
  static Widget dataPanel({
    required String title,
    required List<Map<String, dynamic>> data,
    double borderRadius = AppRadius.lg,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        gradient: AppGradients.cardGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.subheading),
          const SizedBox(height: AppSpacing.md),
          ...data.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item['label'],
                  style: AppTextStyles.mono.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  item['value'],
                  style: AppTextStyles.mono.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }
}

// Animation presets for the app
class AppAnimations {
  // Fade in animation
  static Animation<double> fadeIn(AnimationController controller) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
  }
  
  // Slide up animation
  static Animation<Offset> slideUp(AnimationController controller) {
    return Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.1, 0.6, curve: Curves.easeOut),
      ),
    );
  }
  
  // Scale animation
  static Animation<double> scale(AnimationController controller) {
    return Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
      ),
    );
  }
  
  // Pulse animation
  static Animation<double> pulse(AnimationController controller) {
    return TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.08)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.08, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(controller);
  }
  
  // Shimmer effect animation
  static Animation<double> shimmer(AnimationController controller) {
    return Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
      ),
    );
  }
}