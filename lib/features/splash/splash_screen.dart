import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _ringController;
  late final AnimationController _dotsController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;

   Timer? _splashTimer;

  @override
  void initState() {
    super.initState();

    // Logo pop animation.
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );

    _logoScale = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
    );

    _logoOpacity = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeIn,
    );

    // Circular loading ring.
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    // Loading dots.
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    _logoController.forward();

_splashTimer = Timer(
  const Duration(seconds: 3),
  () {
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (
          context,
          animation,
          secondaryAnimation,
        ) =>
            const LoginScreen(),
        transitionsBuilder: (
          context,
          animation,
          secondaryAnimation,
          child,
        ) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(
          milliseconds: 500,
        ),
      ),
    );
  },
);

  }

  @override
  void dispose() {
_splashTimer?.cancel();

    _logoController.dispose();
    _ringController.dispose();
    _dotsController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // Background decoration.
                const _BackgroundDecoration(),

                // Bottom waves.
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _BottomWaves(),
                ),

                // Main content.
                Center(
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLogo(),

                          const SizedBox(height: 58),

                          _buildBrandName(),

                          const SizedBox(height: 30),

                          _buildTagline(),

                          const SizedBox(height: 85),

                          _buildLoadingDots(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Opacity(
          opacity: _logoOpacity.value.clamp(0.0, 1.0),
          child: Transform.scale(
            scale: _logoScale.value.clamp(0.0, 1.2),
            child: AnimatedBuilder(
              animation: _ringController,
              builder: (context, child) {
                return SizedBox(
                  width: 220,
                  height: 220,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Soft glow behind the logo.
                      Container(
                        width: 178,
                        height: 178,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.10),
                              blurRadius: 40,
                              spreadRadius: 12,
                            ),
                          ],
                        ),
                      ),

                      // Animated circular outline.
                      Transform.rotate(
                        angle: _ringController.value * math.pi * 2,
                        child: CustomPaint(
                          size: const Size(215, 215),
                          painter: _LoadingRingPainter(),
                        ),
                      ),

                      // Logo.
                      Container(
                        width: 150,
                        height: 150,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/pharmacy_logo.jpg',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildBrandName() {
    return Column(
      children: [
        Text(
          'Barakaa',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 48,
            height: 0.95,
            fontWeight: FontWeight.w800,
            letterSpacing: -1.5,
            color: AppColors.brandBlue,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          'Pharmacy',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            height: 1,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildTagline() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _TaglineLine(),

        const SizedBox(width: 18),

        const Flexible(
          child: Text(
            'Your Health,\nOur Priority',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 21,
              height: 1.35,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.2,
            ),
          ),
        ),

        const SizedBox(width: 18),

        _TaglineLine(),
      ],
    );
  }

  Widget _buildLoadingDots() {
    return AnimatedBuilder(
      animation: _dotsController,
      builder: (context, child) {
        final value = _dotsController.value;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LoadingDot(
              scale: _dotScale(value, 0),
              color: AppColors.primary.withOpacity(0.25),
            ),
            const SizedBox(width: 18),
            _LoadingDot(
              scale: _dotScale(value, 1),
              color: AppColors.primary,
            ),
            const SizedBox(width: 18),
            _LoadingDot(
              scale: _dotScale(value, 2),
              color: AppColors.primary.withOpacity(0.25),
            ),
          ],
        );
      },
    );
  }

  double _dotScale(double value, int index) {
    final phase = (value + index * 0.18) % 1.0;

    if (phase < 0.25) {
      return 1.0 + (phase / 0.25) * 0.35;
    }

    if (phase < 0.5) {
      return 1.35 - ((phase - 0.25) / 0.25) * 0.35;
    }

    return 1.0;
  }
}

class _TaglineLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 3,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _LoadingDot extends StatelessWidget {
  final double scale;
  final Color color;

  const _LoadingDot({
    required this.scale,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _LoadingRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final center = rect.center;
    final radius = size.width / 2 - 10;

    final gradient = SweepGradient(
      startAngle: 0,
      endAngle: math.pi * 2,
      colors: const [
        Color(0xFF0B5CAD),
        Color(0xFF0AA651),
        Color(0xFF7ED321),
        Color(0xFF0AA651),
        Color(0xFF0B5CAD),
      ],
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round
      ..shader = gradient.createShader(rect);

    // Main broken circular ring.
    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius,
      ),
      -math.pi * 0.82,
      math.pi * 1.65,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _BackgroundDecoration extends StatelessWidget {
  const _BackgroundDecoration();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -100,
            left: -80,
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                color: const Color(0xFFE9F8ED),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Positioned(
            top: 130,
            right: -90,
            child: Container(
              width: 210,
              height: 210,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF5FA),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomWaves extends StatelessWidget {
  const _BottomWaves();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: CustomPaint(
        painter: _WavesPainter(),
        size: Size.infinite,
      ),
    );
  }
}

class _WavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path1 = Path()
      ..moveTo(0, size.height * 0.45)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.05,
        size.width * 0.52,
        size.height * 0.58,
      )
      ..quadraticBezierTo(
        size.width * 0.78,
        size.height * 1.05,
        size.width,
        size.height * 0.20,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final paint1 = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFFB8EFA2),
          Color(0xFF70CF52),
        ],
      ).createShader(
        Rect.fromLTWH(
          0,
          0,
          size.width,
          size.height,
        ),
      );

    canvas.drawPath(path1, paint1);

    final path2 = Path()
      ..moveTo(0, size.height * 0.75)
      ..quadraticBezierTo(
        size.width * 0.30,
        size.height * 0.35,
        size.width * 0.60,
        size.height * 0.80,
      )
      ..quadraticBezierTo(
        size.width * 0.82,
        size.height * 1.05,
        size.width,
        size.height * 0.50,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final paint2 = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF6BD34B),
          Color(0xFF0D7196),
        ],
      ).createShader(
        Rect.fromLTWH(
          0,
          0,
          size.width,
          size.height,
        ),
      );

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}