import 'package:brick_breaker/language/languages.dart';
import 'package:brick_breaker/services/local_storage.dart';
import 'package:brick_breaker/utils/color_const.dart';
import 'package:brick_breaker/utils/enum.dart';
import 'package:brick_breaker/utils/global.dart';
import 'package:brick_breaker/views/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() async {
  await LocalStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  // runApp(const GameApp());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Global.language = LocalStorage.instance.read(StorageKey.language.name) ??
        Language.en.name;
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          title: 'Football Live Score',
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: secondaryColor,
          ),
          translations: Languages(),
          locale: Global.language == Language.zh.name
              ? const Locale('zh', 'CN')
              : Global.language == Language.vi.name
                  ? const Locale('vi', 'VN')
                  : Global.language == Language.hi.name
                      ? const Locale('hi', 'IN')
                      : const Locale('en', 'US'),
          fallbackLocale: const Locale('vi', 'VN'),
          home: const SplashScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
