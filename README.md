# 🌟 flare_onboarding

Beautiful animated onboarding screens for Flutter with particle backgrounds and gradient transitions.

## Preview

![flare_onboarding demo](https://github.com/ErsanQ/flare_onboarding/raw/main/preview.gif)

## Features

- ✨ **Animated particle background** — floating circles that move organically
- 🎨 **Gradient transitions** — smooth color interpolation between pages
- 🔄 **Spring icon animation** — elastic bounce on every page change
- 📝 **Slide + fade text** — staggered animations for title and subtitle
- 🔵 **Animated page indicator** — active dot expands smoothly
- 🔽 **Button scale** — tactile press effect
- ⏭ **Skip button** — optional, auto-hides on last page
- ⚙️ **Fully customizable** — colors, text, animations, button style

## Installation

```yaml
dependencies:
  flare_onboarding: ^1.0.0
```

## Usage

```dart
import 'package:flare_onboarding/flare_onboarding.dart';

FlareOnboardingScreen(
  pages: const [
    FlareOnboardingPage(
      title: 'Welcome',
      subtitle: 'Your journey starts here.',
      icon: Icons.waving_hand_rounded,
      backgroundColors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFEC4899)],
    ),
    FlareOnboardingPage(
      title: 'Fast & Powerful',
      subtitle: 'Built for performance.',
      icon: Icons.bolt_rounded,
      backgroundColors: [Color(0xFF0891B2), Color(0xFF0D9488)],
    ),
    FlareOnboardingPage(
      title: 'You\'re All Set!',
      subtitle: 'Enjoy the experience!',
      icon: Icons.check_circle_rounded,
      backgroundColors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
    ),
  ],
  onFinish: () {
    // Navigate to main app
  },
)
```

## Custom Config

```dart
FlareOnboardingScreen(
  pages: pages,
  config: const FlareOnboardingConfig(
    continueButtonText: 'Next',
    skipButtonText: 'Skip',
    getStartedButtonText: 'Let\'s Go!',
    showSkipButton: true,
    showParticles: true,
    particleCount: 20,
    buttonHeight: 60,
    buttonBorderRadius: 30,
  ),
  onFinish: () {},
  onSkip: () {},
  onPageChanged: (index) => print('Page: $index'),
)
```

## FlareOnboardingPage

| Property | Type | Description |
|----------|------|-------------|
| `title` | `String` | Page title |
| `subtitle` | `String` | Description text |
| `icon` | `IconData` | Center icon |
| `backgroundColors` | `List<Color>` | Gradient colors (min 2) |
| `iconColor` | `Color` | Icon color (default: white) |

## FlareOnboardingConfig

| Property | Default | Description |
|----------|---------|-------------|
| `continueButtonText` | "Continue" | Button label |
| `getStartedButtonText` | "Get Started" | Last page button |
| `skipButtonText` | "Skip" | Skip button label |
| `showSkipButton` | true | Show/hide skip |
| `showParticles` | true | Enable particles |
| `particleCount` | 18 | Number of particles |
| `buttonHeight` | 56 | Button height |
| `buttonBorderRadius` | 16 | Button radius |

## License

MIT
