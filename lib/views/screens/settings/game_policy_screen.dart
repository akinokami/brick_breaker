import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../utils/dimen_const.dart';
import '../../../utils/enum.dart';
import '../../../utils/global.dart';

class GamePolicyScreen extends StatefulWidget {
  const GamePolicyScreen({super.key});

  @override
  State<GamePolicyScreen> createState() => _GamePolicyScreenState();
}

class _GamePolicyScreenState extends State<GamePolicyScreen> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(Global.language == Language.zh.name
          ? Global.policyZh
          : Global.language == Language.vi.name
              ? Global.policyVi
              : Global.language == Language.hi.name
                  ? Global.policyHi
                  : Global.policyEn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Row(
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
                  // CustomGameButton(
                  //   onTap: () {
                  //     Navigator.of(context).pop();
                  //   },
                  //   height: 35.w,
                  //   width: 35.w,
                  //   icon: Icons.arrow_back,
                  //   iconColor: Colors.white,
                  // ),
                ],
              ),
            ),
            kSizedBoxH10,
            Expanded(
              child: WebViewWidget(
                controller: controller,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
