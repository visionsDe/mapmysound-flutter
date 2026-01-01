import 'package:maymysound/login/viewModel/loginViewModel.dart';
import 'package:maymysound/splashScreen/viewModel/splashViewModel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'dashboard/recorder/viewmodel/RecorderViewModel.dart';
import 'dashboard/sample/viewModel/sampleApiViewModel.dart';

class AppProviders {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => SampleApiViewModel()),
    ChangeNotifierProvider(create: (_) => RecorderViewModel()),
    ChangeNotifierProvider(create: (_) => SplashViewModel()),
    ChangeNotifierProvider(create: (_) => LoginViewModel()),
  ];
}