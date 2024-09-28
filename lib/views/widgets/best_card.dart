import 'package:brick_breaker/views/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BestCard extends StatelessWidget {
  const BestCard({
    super.key,
    required this.best,
  });

  final ValueNotifier<int> best;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: best,
      builder: (context, best, child) {
        return CustomText(
          text: "${'best'.tr}: $best".toUpperCase(),
          fontSize: 14.sp,
        );
      },
    );
  }
}
