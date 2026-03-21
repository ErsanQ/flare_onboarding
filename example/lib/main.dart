import 'package:flutter/material.dart';
import 'package:flare_onboarding/flare_onboarding.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlareOnboarding Example',
      debugShowCheckedModeBanner: false,
      home: const OnboardingWrapper(),
    );
  }
}

class OnboardingWrapper extends StatefulWidget {
  const OnboardingWrapper({super.key});

  @override
  State<OnboardingWrapper> createState() => _OnboardingWrapperState();
}

class _OnboardingWrapperState extends State<OnboardingWrapper> {
  bool _showOnboarding = true;

  @override
  Widget build(BuildContext context) {
    if (_showOnboarding) {
      return FlareOnboardingScreen(
        pages: const [
          FlareOnboardingPage(
            title: 'Welcome to FlareApp',
            subtitle: 'Your journey starts here.\nWe\'re excited to have you!',
            icon: Icons.waving_hand_rounded,
            backgroundColors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFEC4899)],
          ),
          FlareOnboardingPage(
            title: 'Fast & Powerful',
            subtitle: 'Built for performance.\nExperience lightning speed.',
            icon: Icons.bolt_rounded,
            backgroundColors: [Color(0xFF0891B2), Color(0xFF0D9488), Color(0xFF059669)],
          ),
          FlareOnboardingPage(
            title: 'Stay Connected',
            subtitle: 'Real-time updates.\nNever miss a moment.',
            icon: Icons.hub_rounded,
            backgroundColors: [Color(0xFFDB2777), Color(0xFFE11D48), Color(0xFFDC2626)],
          ),
          FlareOnboardingPage(
            title: 'You\'re All Set!',
            subtitle: 'Everything is ready.\nEnjoy the experience!',
            icon: Icons.check_circle_rounded,
            backgroundColors: [Color(0xFF7C3AED), Color(0xFF6D28D9), Color(0xFF5B21B6)],
          ),
        ],
        config: const FlareOnboardingConfig(
          showParticles: true,
          showSkipButton: true,
          continueButtonText: 'Continue',
          getStartedButtonText: 'Get Started 🚀',
        ),
        onFinish: () => setState(() => _showOnboarding = false),
        onSkip: () => setState(() => _showOnboarding = false),
        onPageChanged: (index) => debugPrint('Page: $index'),
      );
    }

    return const HomeScreen();
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 60)),
            const SizedBox(height: 16),
            const Text(
              'Welcome!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Onboarding complete.',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
