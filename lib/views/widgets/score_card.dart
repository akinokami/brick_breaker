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
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 18),
          child: CustomText(
            text: "${'score'.tr}: $score".toUpperCase(),
            fontSize: 16.sp,
          ),
          // child: Text(
          //   'Score: $score'.toUpperCase(),
          //   style: Theme.of(context).textTheme.titleLarge!,
          // ),
        );
      },
    );
  }
}
