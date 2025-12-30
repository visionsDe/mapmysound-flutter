import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maymysound/utils/appFonts.dart';
import 'package:maymysound/utils/network/networkServices.dart';

import 'package:provider/provider.dart';

import 'appProviders.dart';
import 'dashboard/sample/view/sampleApiView.dart';

 main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
   NetworkService.instance.init();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(
      MultiProvider(
          // providers: [
          //   ChangeNotifierProvider(create: (_) => SampleApiViewModel()),
          //   ChangeNotifierProvider(create: (_) => SplashViewModel()),
          //   ChangeNotifierProvider(create: (_) => RecorderViewModel())
          // ],
        providers: AppProviders.providers,

      child :  MyApp(),
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        fontFamily: AppFonts.outfit,
      ),
     // home: SampleStaticView(),
      home: SampleApiView(),
    );
  }
}

