import 'package:brick_breaker/services/local_storage.dart';

import 'package:brick_breaker/utils/enum.dart';
import 'package:brick_breaker/views/widgets/best_card.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/sound_controller.dart';

import '../../utils/dimen_const.dart';
import '../widgets/custom_text.dart';
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
  final BrickBreaker game = BrickBreaker();

  @override
  void initState() {
    super.initState();
    game.best.value = LocalStorage.instance.read(StorageKey.best.name) ?? 0;

    startGame();
  }

  void startGame() {
    Future.delayed(const Duration(microseconds: 3000), () {
      game.onTap();
    });
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
                      PlayState.gameOver.name: (context, game) {
                        WidgetsBinding.instance.addPostFrameCallback((_) async {
                          return showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return WillPopScope(
                                onWillPop: () async {
                                  Navigator.of(context).pop();
                                  Future.delayed(
                                      const Duration(microseconds: 3000), () {
                                    startGame();
                                  });
                                  bool shouldClose = false;
                                  return shouldClose;
                                },
                                child: Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  elevation: 16,
                                  child: Container(
                                    padding: EdgeInsets.all(15.w),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        CustomText(
                                          text: 'game_over'.tr,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        kSizedBoxH10,
                                        CustomText(
                                            text: 'are_you_want_to_replay'.tr),
                                        kSizedBoxH10,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                foregroundColor: Colors.white,
                                                shadowColor: Colors.redAccent,
                                              ),
                                              child: CustomText(
                                                text: 'no'.tr,
                                                color: Colors.white,
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                Future.delayed(
                                                    const Duration(
                                                        microseconds: 3000),
                                                    () {
                                                  startGame();
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                foregroundColor: Colors.white,
                                                shadowColor: Colors.greenAccent,
                                              ),
                                              child: CustomText(
                                                text: 'yes'.tr,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        });
                        return Container();
                        // return OverlayScreen(
                        //   title: 'game_over'.tr,
                        //   subtitle: 'tap_to_play_again'.tr,
                        // );
                      },
                      PlayState.won.name: (context, game) {
                        WidgetsBinding.instance.addPostFrameCallback((_) async {
                          return showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return WillPopScope(
                                onWillPop: () async {
                                  Navigator.of(context).pop();
                                  Future.delayed(
                                      const Duration(microseconds: 3000), () {
                                    startGame();
                                  });
                                  bool shouldClose = false;
                                  return shouldClose;
                                },
                                child: Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  elevation: 16,
                                  child: Container(
                                    padding: EdgeInsets.all(15.w),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        CustomText(
                                          text: 'you_win'.tr,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        kSizedBoxH10,
                                        CustomText(
                                            text: 'are_you_want_to_replay'.tr),
                                        kSizedBoxH10,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).pop();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                foregroundColor: Colors.white,
                                                shadowColor: Colors.redAccent,
                                              ),
                                              child: CustomText(
                                                text: 'no'.tr,
                                                color: Colors.white,
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                Future.delayed(
                                                    const Duration(
                                                        microseconds: 3000),
                                                    () {
                                                  startGame();
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                foregroundColor: Colors.white,
                                                shadowColor: Colors.greenAccent,
                                              ),
                                              child: CustomText(
                                                text: 'yes'.tr,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        });
                        return Container();
                      }
                      // OverlayScreen(
                      //       title: 'you_win'.tr,
                      //       subtitle: 'tap_to_play_again'.tr,
                      //     ),
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
