import 'package:authenticator/core/common/custom_snackbar.dart';
import 'package:authenticator/core/routes/app_routes.dart';
import 'package:authenticator/core/themes/app_colors.dart';
import 'package:authenticator/features/presentation/bloc/googleauth_bloc/googleauth_bloc.dart';
import 'package:authenticator/features/presentation/bloc/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void loginStatehandle(BuildContext context, GooglesignState state) {
  final progresser = context.read<ProgresserCubit>();
  if (state is GooglesingFailure) {
    progresser.stopLoading();
    CustomSnackBar.show(
      context,
      message: state.message,
      backgroundColor: AppPalette.redColor,
      textAlign: TextAlign.center,
      durationSeconds: 4,
    );
  } else if (state is GooglesingSuccess) {
    progresser.stopLoading();
    Navigator.pushReplacementNamed(context, AppRoutes.nav);
  } else if (state is GooglesingLoading) {
    progresser.startLoading();
  }
}

