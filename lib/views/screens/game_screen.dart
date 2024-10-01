import 'dart:io';

import 'package:brick_breaker/services/local_storage.dart';

import 'package:brick_breaker/utils/enum.dart';
import 'package:brick_breaker/views/screens/settings/game_setting_screen.dart';
import 'package:brick_breaker/views/widgets/best_card.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/sound_controller.dart';

import '../widgets/overlay_screen.dart';

import '../../models/brick_breaker.dart';
import '../../utils/config.dart';
import '../widgets/score_card.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final BrickBreaker game;

  @override
  void initState() {
    super.initState();
    game = BrickBreaker();
    game.best.value = LocalStorage.instance.read(StorageKey.best.name) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final soundController = Get.put(SoundController());
    soundController.playSound();
    return Scaffold(
      body: SafeArea(
        child: Container(
          // color: GameColors.bgColor,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/bg.png",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/btn_bg.png",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        height: 35.w,
                        width: 35.w,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24.w,
                        ),
                      ),
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     exit(0);
                    //   },
                    //   child: Image.asset(
                    //     'assets/close.png',
                    //     height: 38.w,
                    //     width: 38.w,
                    //   ),
                    // ),
                    // CustomGameButton(
                    //   onTap: () {
                    //     exit(0);
                    //   },
                    //   height: 35.w,
                    //   width: 35.w,
                    //   icon: Icons.close,
                    //   iconColor: Colors.white,
                    //   color1: Colors.red,
                    //   color2: Colors.red.shade300,
                    //   color3: Colors.red,
                    // ),
                    BestCard(best: game.best),
                    ScoreCard(score: game.score),
                    // InkWell(
                    //   onTap: () {
                    //     Get.to(() => const GameSettingScreen());
                    //     game.pauseEngine();
                    //   },
                    //   child: Container(
                    //     decoration: const BoxDecoration(
                    //       image: DecorationImage(
                    //         image: AssetImage(
                    //           "assets/btn_bg.png",
                    //         ),
                    //         fit: BoxFit.cover,
                    //       ),
                    //     ),
                    //     height: 35.w,
                    //     width: 35.w,
                    //     child: Icon(
                    //       Icons.settings,
                    //       color: Colors.white,
                    //       size: 24.w,
                    //     ),
                    //   ),
                    // ),
                    // CustomGameButton(
                    //   onTap: () {
                    //     Get.to(() => GameSettingScreen(
                    //           game: game,
                    //         ));
                    //     game.pauseEngine();
                    //   },
                    //   height: 35.w,
                    //   width: 35.w,
                    //   icon: Icons.settings,
                    //   iconColor: Colors.white,
                    // ),
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: gameWidth,
                  height: gameHeight,
                  child: GameWidget(
                    game: game,
                    overlayBuilderMap: {
                      PlayState.welcome.name: (context, game) => OverlayScreen(
                            title: 'tap_to_play'.tr,
                            subtitle: 'arrow_swipe'.tr,
                          ),
                      PlayState.gameOver.name: (context, game) => OverlayScreen(
                            title: 'game_over'.tr,
                            subtitle: 'tap_to_play_again'.tr,
                          ),
                      PlayState.won.name: (context, game) => OverlayScreen(
                            title: 'you_win'.tr,
                            subtitle: 'tap_to_play_again'.tr,
                          ),
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
