import 'package:brick_breaker/utils/dimen_const.dart';
import 'package:brick_breaker/utils/global.dart';
import 'package:brick_breaker/views/screens/game_screen.dart';
import 'package:brick_breaker/views/screens/settings/game_setting_screen.dart';
import 'package:brick_breaker/views/widgets/custom_button.dart';
import 'package:brick_breaker/views/widgets/custom_game_button.dart';
import 'package:brick_breaker/views/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../models/brick_breaker.dart';
import '../../services/local_storage.dart';
import '../../utils/color_const.dart';
import '../../utils/enum.dart';
import '../widgets/best_card.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
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
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/bg.png",
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BestCard(best: game.best),
                SizedBox(
                  height: 20.h,
                ),
                CustomGameButton(
                  onTap: () {
                    Get.to(() => const GameScreen());
                  },
                  width: 0.2.sh,
                  text: 'play'.tr,
                  textColor: Colors.black,
                ),
                SizedBox(
                  height: 10.h,
                ),
                CustomGameButton(
                  onTap: () {
                    Get.to(() => GameSettingScreen(
                          score: game.best.value,
                        ));
                  },
                  width: 0.2.sh,
                  text: 'settings'.tr,
                  textColor: Colors.black,
                ),
                SizedBox(
                  height: 10.h,
                ),
                CustomGameButton(
                  onTap: () {
                    //Get.to(() => const LevelScreen());
                  },
                  width: 0.2.sh,
                  color1: Colors.red,
                  color2: const Color.fromARGB(255, 226, 203, 196),
                  color3: Colors.red,
                  text: 'exit'.tr,
                  textColor: Colors.black,
                ),
              ]),
        ),
      ),
    );
  }
}
