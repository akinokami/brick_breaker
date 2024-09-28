import 'dart:async';

import 'package:brick_breaker/utils/colors.dart';
import 'package:brick_breaker/views/screens/game_screen.dart';
import 'package:brick_breaker/views/screens/splash/circle_transition_clipper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

import '../../../utils/dimen_const.dart';
import '../../widgets/custom_loading.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _controller.forward();
    _controller.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          Timer(
            const Duration(seconds: 1),
            _goToGame,
          );
        }
      },
    );
    super.initState();
  }

  void _goToGame() {
    final route = PageRouteBuilder(
      pageBuilder: (_, animation, secondaryAnimation) => const GameScreen(),
      transitionDuration: const Duration(milliseconds: 1500),
      transitionsBuilder: (
        context,
        animation,
        secondaryAnimation,
        child,
      ) {
        final size = MediaQuery.of(context).size;

        final radiusTween = Tween<double>(
          begin: 0.0,
          end: size.height,
        );

        return ClipPath(
          clipper: CircleTransitionClipper(
            center: Offset(
              size.width * 0.5,
              size.height * 0.5,
            ),
            radius: animation.drive(radiusTween).value,
          ),
          child: child,
        );
      },
    );
    Navigator.pushReplacement(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: GameColors.bgColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FlutterLogo(
              size: 80.h,
            ),
            kSizedBoxH30,
            kSizedBoxH30,
            const CustomLoading()
          ],
        ),
      ),
    );
  }
}
