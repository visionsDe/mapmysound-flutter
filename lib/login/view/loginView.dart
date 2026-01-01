import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewModel/loginViewModel.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ChangeNotifierProvider(
          create: (BuildContext context) {
            final vm = LoginViewModel(); 
            return vm;
          },
          child: Consumer<LoginViewModel>(
            builder: (context, viewmodel, child) {
              if (!viewmodel.hasInternet) {
                return Center(child: Text("No Internet Connection"));
              }
              return Center(child: TextButton(onPressed: (){
                print("FACEBOOK BTN");
              }, child: Text("Facebook login")),);
            },
          ),
        ),
      ),
    );
  }
}
