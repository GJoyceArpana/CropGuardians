import 'package:flutter/material.dart';
import '../constants/text_styles.dart';
import '../widgets/gradient_background.dart';
import '../widgets/custom_logo.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _textController;
  late final Animation<double> _logoScaleAnimation;
  late final Animation<double> _logoRotationAnimation;
  late final Animation<double> _textOpacityAnimation;
  late final Animation<Offset> _textSlideAnimation;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    // Initialize controllers
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Logo animations - scale and rotation
    _logoScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _logoRotationAnimation = Tween<double>(
      begin: -0.1,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOutBack),
      ),
    );

    // Text animations - opacity and slide
    _textOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeInOut,
      ),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Start animation sequence
    _startAnimations();
  }

  Future<void> _startAnimations() async {
    // Initial delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Start logo animation
    _logoController.forward();

    // Start text animation after logo is partially complete
    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();

    // Navigate after 2.5 seconds (reduced from 3 for better UX)
    await Future.delayed(const Duration(milliseconds: 1500));
    
    if (mounted && !_navigated) {
      _navigated = true;
      Navigator.pushReplacementNamed(context, '/welcome');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Logo with combined scale and rotation animation
              AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..scale(_logoScaleAnimation.value)
                      ..rotateZ(_logoRotationAnimation.value),
                    child: const CustomLogo(size: 140),
                  );
                },
              ),
              const Spacer(),
              // Text content with combined animations
              AnimatedBuilder(
                animation: _textController,
                builder: (context, child) {
                  return SlideTransition(
                    position: _textSlideAnimation,
                    child: FadeTransition(
                      opacity: _textOpacityAnimation,
                      child: Column(
                        children: [
                          const Text(
                            'CropGuardians',
                            style: AppTextStyles.companyName,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Your Partner in Healthy Farming',
                            style: AppTextStyles.tagline,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          // Adding a subtle loading indicator
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              value: _textController.isCompleted 
                                  ? null 
                                  : _textController.value,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}