import 'package:flutter/material.dart';
import 'models.dart';
import 'particles.dart';

/// Beautiful animated onboarding screen with particle background
class FlareOnboardingScreen extends StatefulWidget {
  final List<FlareOnboardingPage> pages;
  final FlareOnboardingConfig config;
  final VoidCallback onFinish;
  final VoidCallback? onSkip;
  final void Function(int index)? onPageChanged;

  const FlareOnboardingScreen({
    super.key,
    required this.pages,
    required this.onFinish,
    this.config = const FlareOnboardingConfig(),
    this.onSkip,
    this.onPageChanged,
  });

  @override
  State<FlareOnboardingScreen> createState() => _FlareOnboardingScreenState();
}

class _FlareOnboardingScreenState extends State<FlareOnboardingScreen>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _particleController;
  late final AnimationController _pageAnimController;
  late final AnimationController _buttonController;

  late final Animation<double> _iconScale;
  late final Animation<double> _titleSlide;
  late final Animation<double> _titleFade;
  late final Animation<double> _buttonScale;

  late final List<FlareParticle> _particles;

  int _currentPage = 0;
  double _pageProgress = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
    _pageController.addListener(() {
      setState(() => _pageProgress = _pageController.page ?? 0);
    });

    // Particle animation
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    )..repeat();

    // Page content animation
    _pageAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _iconScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pageAnimController, curve: Curves.elasticOut),
    );
    _titleSlide = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
          parent: _pageAnimController,
          curve: const Interval(0.2, 0.8, curve: Curves.easeOut)),
    );
    _titleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _pageAnimController,
          curve: const Interval(0.2, 0.8, curve: Curves.easeOut)),
    );

    // Button scale
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _buttonScale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );

    _particles = generateParticles(widget.config.particleCount);
    _pageAnimController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _particleController.dispose();
    _pageAnimController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < widget.pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onFinish();
    }
  }

  void _skip() {
    widget.onSkip?.call();
    widget.onFinish();
  }

  Color _interpolateColor(Color a, Color b, double t) {
    return Color.lerp(a, b, t.clamp(0.0, 1.0))!;
  }

  List<Color> _getCurrentGradient() {
    final page = _pageProgress;
    final current = page.floor().clamp(0, widget.pages.length - 1);
    final next = (current + 1).clamp(0, widget.pages.length - 1);
    final frac = page - current;

    final currentColors = widget.pages[current].backgroundColors;
    final nextColors = widget.pages[next].backgroundColors;

    final len = currentColors.length.clamp(1, nextColors.length);
    return List.generate(len, (i) {
      final ci = i.clamp(0, currentColors.length - 1);
      final ni = i.clamp(0, nextColors.length - 1);
      return _interpolateColor(currentColors[ci], nextColors[ni], frac);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([_particleController, _pageAnimController]),
        builder: (context, _) {
          final gradient = _getCurrentGradient();

          return Stack(
            children: [
              // Gradient background
              AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradient,
                  ),
                ),
              ),

              // Particles
              if (widget.config.showParticles)
                CustomPaint(
                  painter: ParticlePainter(
                    particles: _particles,
                    time: _particleController.value * 60,
                  ),
                  size: Size.infinite,
                ),

              // Pages
              PageView.builder(
                controller: _pageController,
                itemCount: widget.pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                  _pageAnimController.forward(from: 0);
                  widget.onPageChanged?.call(index);
                },
                itemBuilder: (context, index) {
                  return _buildPage(widget.pages[index]);
                },
              ),

              // Skip button
              if (widget.config.showSkipButton &&
                  _currentPage < widget.pages.length - 1)
                SafeArea(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: TextButton(
                        onPressed: _skip,
                        child: Text(
                          widget.config.skipButtonText,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // Bottom controls
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Page indicator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(widget.pages.length, (i) {
                            final isActive = i == _currentPage;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: isActive ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.white
                                    .withValues(alpha: isActive ? 1.0 : 0.35),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 24),

                        // Continue / Get Started button
                        GestureDetector(
                          onTapDown: (_) => _buttonController.forward(),
                          onTapUp: (_) {
                            _buttonController.reverse();
                            _nextPage();
                          },
                          onTapCancel: () => _buttonController.reverse(),
                          child: ScaleTransition(
                            scale: _buttonScale,
                            child: Container(
                              height: widget.config.buttonHeight,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(
                                    widget.config.buttonBorderRadius),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  _currentPage == widget.pages.length - 1
                                      ? widget.config.getStartedButtonText
                                      : widget.config.continueButtonText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPage(FlareOnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon container
          ScaleTransition(
            scale: _iconScale,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Icon(
                page.icon,
                size: 60,
                color: page.iconColor,
              ),
            ),
          ),

          const SizedBox(height: 40),

          // Title
          FadeTransition(
            opacity: _titleFade,
            child: AnimatedBuilder(
              animation: _titleSlide,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, _titleSlide.value),
                child: child,
              ),
              child: Text(
                page.title,
                textAlign: TextAlign.center,
                style: widget.config.titleStyle ??
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Subtitle
          FadeTransition(
            opacity: _titleFade,
            child: AnimatedBuilder(
              animation: _titleSlide,
              builder: (context, child) => Transform.translate(
                offset: Offset(0, _titleSlide.value * 1.5),
                child: child,
              ),
              child: Text(
                page.subtitle,
                textAlign: TextAlign.center,
                style: widget.config.subtitleStyle ??
                    TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 16,
                      height: 1.6,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
