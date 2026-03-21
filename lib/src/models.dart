import 'package:flutter/material.dart';

/// Represents a single onboarding page
class FlareOnboardingPage {
  /// Title displayed on the page
  final String title;

  /// Subtitle/description text
  final String subtitle;

  /// Icon displayed in the center circle
  final IconData icon;

  /// Gradient colors for background (min 2 colors)
  final List<Color> backgroundColors;

  /// Icon color (defaults to white)
  final Color iconColor;

  const FlareOnboardingPage({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.backgroundColors,
    this.iconColor = Colors.white,
  });
}

/// Configuration for FlareOnboardingScreen
class FlareOnboardingConfig {
  final String continueButtonText;
  final String skipButtonText;
  final String getStartedButtonText;
  final bool showSkipButton;
  final bool showParticles;
  final int particleCount;
  final Duration gradientAnimationDuration;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final double buttonBorderRadius;
  final double buttonHeight;

  const FlareOnboardingConfig({
    this.continueButtonText = 'Continue',
    this.skipButtonText = 'Skip',
    this.getStartedButtonText = 'Get Started',
    this.showSkipButton = true,
    this.showParticles = true,
    this.particleCount = 18,
    this.gradientAnimationDuration = const Duration(seconds: 4),
    this.titleStyle,
    this.subtitleStyle,
    this.buttonBorderRadius = 16,
    this.buttonHeight = 56,
  });
}
