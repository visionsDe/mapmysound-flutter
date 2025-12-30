import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:maymysound/dashboard/sample/model/sampleApiModelObject.dart';
import 'package:maymysound/dashboard/sample/view/sampleApiView.dart';
import 'package:maymysound/utils/appColors.dart';
import 'package:provider/provider.dart';

import '../viewModel/splashViewModel.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));
    final size = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        final vm = SplashViewModel();
        vm.startSplash();
        return vm;
      },
      child: Consumer<SplashViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            Future.microtask(() {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SampleApiView()),
              );
            });
            // WidgetsBinding.instance.addPostFrameCallback((_) {
            //   Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(
            //         builder: (_) => const SampleApiView()),
            //   );
            // });
          }

          return Center(
            child: Container(
              height: size.height * 1,
              width:  size.width * 1,
              decoration: BoxDecoration(
                  gradient: AppColors.gradientBackground
              ),
              child: Container(
                padding: EdgeInsets.all(120),

                width: 126,
                height: 236,
                child: SvgPicture.asset(
                  "assets/images/logo.svg",
                  fit: BoxFit.contain,
                ),
              )
            ),
          );
        },
        child: Center(child: Text("Splash Screen")),
      ),
    );
  }
}
