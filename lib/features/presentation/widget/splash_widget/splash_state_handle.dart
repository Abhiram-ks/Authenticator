import 'package:authenticator/core/routes/app_routes.dart';
import 'package:authenticator/features/presentation/bloc/splash_bloc/splash_bloc.dart';
import 'package:flutter/material.dart';

void splashStateHandle(BuildContext context, SplashState state) {
  if (state is GotologinScreen) {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }else if (state is GotologinHomeScreen){
   Navigator.pushReplacementNamed(context, AppRoutes.nav);
  }
}
