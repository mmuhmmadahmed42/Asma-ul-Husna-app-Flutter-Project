import 'package:asma_ul_husna/ui/screens/asma-ul-husna.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  // Animations for the splash elements
  late Animation<double> islamOpacity;
  late Animation<Offset> islamSlide;
  late Animation<double> plusOpacity;
  late Animation<Offset> plusSlide;
  late Animation<double> lineOpacity;
  late Animation<double> subtitleOpacity;

  @override
  void initState() {
    super.initState();

    // Set up the animation controller with a 2.2 second duration
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    // Staggered animations setup
    islamOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
      ),
    );

    islamSlide = Tween(
      begin: const Offset(0, .25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOutCubic),
      ),
    );

    plusOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.20, 0.55, curve: Curves.easeOut),
      ),
    );

    plusSlide = Tween(
      begin: const Offset(0, .25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.20, 0.60, curve: Curves.elasticOut),
      ),
    );

    lineOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.45, 0.70),
      ),
    );

    subtitleOpacity = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.60, 1.0),
      ),
    );

    // Start the splash screen animations
    _controller.forward();

    // Trigger navigation to the main screen
    _navigateToHome();
  }

  /// Handles the navigation delay.
  /// After 3 seconds, the app will automatically navigate to the AllahNames screen.
  void _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AllahNames()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildGradientText(String text) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return const LinearGradient(
          colors: [
            Color(0xffFFD86A),
            Color(0xffFFB800),
          ],
        ).createShader(bounds);
      },
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 52,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          letterSpacing: 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Splash background image
            Image.asset(
              "assets/images/splash_img.png",
              fit: BoxFit.cover,
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FadeTransition(
                        opacity: islamOpacity,
                        child: SlideTransition(
                          position: islamSlide,
                          child: const Text(
                            "Islam",
                            style: TextStyle(
                              fontSize: 52,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1,
                              shadows: [
                                Shadow(
                                  blurRadius: 25,
                                  color: Colors.black38,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FadeTransition(
                        opacity: plusOpacity,
                        child: SlideTransition(
                          position: plusSlide,
                          child: buildGradientText("Plus"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  FadeTransition(
                    opacity: lineOpacity,
                    child: Container(
                      width: 150,
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xff18D2D1),
                            Color(0xff0F9A94),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  FadeTransition(
                    opacity: subtitleOpacity,
                    child: const Text(
                      "Your Companion in Faith",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                        letterSpacing: .8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
