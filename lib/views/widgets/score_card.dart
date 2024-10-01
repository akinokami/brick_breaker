import 'package:brick_breaker/views/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ScoreCard extends StatelessWidget {
  const ScoreCard({
    super.key,
    required this.score,
  });

  final ValueNotifier<int> score;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: score,
      builder: (context, score, child) {
        return CustomText(
          text: "${'score'.tr}: $score".toUpperCase(),
          fontSize: 14.sp,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        );
      },
    );
  }
}
