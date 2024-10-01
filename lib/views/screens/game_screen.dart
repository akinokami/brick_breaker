import 'dart:io';

import 'package:brick_breaker/services/local_storage.dart';
import 'package:brick_breaker/utils/color_const.dart';
import 'package:brick_breaker/utils/colors.dart';
import 'package:brick_breaker/utils/enum.dart';
import 'package:brick_breaker/views/screens/settings/game_setting_screen.dart';
import 'package:brick_breaker/views/widgets/best_card.dart';
import 'package:brick_breaker/views/widgets/custom_button.dart';
import 'package:brick_breaker/views/widgets/custom_text.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../controller/sound_controller.dart';
import '../../utils/dimen_const.dart';
import '../../utils/global.dart';
import '../widgets/custom_game_button.dart';
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
  bool isAccepted = false;
  bool isChecked = false;
  String first = '';

  @override
  void initState() {
    super.initState();
    game = BrickBreaker();
    game.best.value = LocalStorage.instance.read(StorageKey.best.name) ?? 0;
    first = LocalStorage.instance.read(StorageKey.first.name) ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        if (first == '') {
          if (context.mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (ctx) => Builder(builder: (context) {
                return StatefulBuilder(
                  builder: (context, StateSetter setState) {
                    return AlertDialog(
                      surfaceTintColor: whiteColor,
                      backgroundColor: whiteColor,
                      content: SizedBox(
                        height: 1.sh,
                        width: 1.sw,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: WebViewWidget(
                                  controller: WebViewController()
                                    ..loadHtmlString(Global.language ==
                                            Language.zh.name
                                        ? Global.policyZh
                                        : Global.language == Language.vi.name
                                            ? Global.policyVi
                                            : Global.language ==
                                                    Language.hi.name
                                                ? Global.policyHi
                                                : Global.policyEn)),
                            ),
                            kSizedBoxH5,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                  activeColor: secondaryColor,
                                  side: BorderSide(
                                    width: 1.5,
                                    color: isChecked
                                        ? secondaryColor
                                        : Colors.black,
                                  ),
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked = value!;
                                      if (isChecked) {
                                        isAccepted = true;
                                      } else {
                                        isAccepted = false;
                                      }
                                    });
                                  },
                                ),
                                Expanded(
                                  child: CustomText(
                                    text: 'agree'.tr,
                                    color: secondaryColor,
                                    fontSize: 11.sp,
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                            kSizedBoxH5,
                            CustomButton(
                              text: 'accept'.tr,
                              size: 11.sp,
                              width: 100.w,
                              height: 25.h,
                              isRounded: true,
                              outlineColor:
                                  isAccepted ? secondaryColor : greyColor,
                              bgColor: isAccepted ? secondaryColor : greyColor,
                              onTap: isAccepted
                                  ? () async {
                                      LocalStorage.instance.write(
                                          StorageKey.first.name, 'notfirst');
                                      Navigator.pop(context);
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            );
          }
        }
      } catch (e) {
        // print("Error fetching SharedPreferences: $e");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final soundController = Get.put(SoundController());
    soundController.playSound();
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: GameColors.bgColor,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomGameButton(
                      onTap: () {
                        exit(0);
                      },
                      height: 35.w,
                      width: 35.w,
                      icon: Icons.close,
                      iconColor: Colors.white,
                      color1: Colors.red,
                      color2: Colors.red.shade300,
                      color3: Colors.red,
                    ),
                    BestCard(best: game.best),
                    ScoreCard(score: game.score),
                    CustomGameButton(
                      onTap: () {
                        Get.to(() => GameSettingScreen(
                              game: game,
                            ));
                        game.pauseEngine();
                      },
                      height: 35.w,
                      width: 35.w,
                      icon: Icons.settings,
                      iconColor: Colors.white,
                    ),
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
