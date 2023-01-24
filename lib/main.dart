import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:imagen/auth/auth_controller/user_provider.dart';
import 'package:imagen/core/init/theme/ligth/app_theme_ligth.dart';
import 'package:imagen/features/onboarding/view/onboarding_view.dart';
import 'package:imagen/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        theme: AppThemeLight.instance.theme,
        debugShowCheckedModeBanner: false,
        home: const OnBoardingView(),
      ),
    );
  }
}
