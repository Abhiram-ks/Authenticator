import 'package:authenticator/core/common/custom_snackbar.dart';
import 'package:authenticator/core/themes/app_colors.dart';
import 'package:authenticator/features/presentation/bloc/credential_bloc/credential_bloc.dart';
import 'package:authenticator/features/presentation/bloc/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void credentialStateHandle(BuildContext context, CredentialState state) {
  final progresser = context.read<ProgresserCubit>();
  if (state is CredentialFailure) {
    progresser.stopLoading();
    CustomSnackBar.show(
      context,
      message: state.message,
      backgroundColor: AppPalette.redColor,
      textAlign: TextAlign.center,
      durationSeconds: 4,
    );
  } else if (state is CredentialSuccess) {
    progresser.stopLoading();
    Navigator.pop(context);
    CustomSnackBar.show(
      context,
      message: "Record added successfully",
      backgroundColor: AppPalette.greenColor,
      textAlign: TextAlign.center,
    );
  } else if (state is CredentialLoading) {
    progresser.startLoading();
  }
}