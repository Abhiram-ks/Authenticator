
import 'package:authenticator/core/common/custom_snackbar.dart';
import 'package:authenticator/core/routes/app_routes.dart';
import 'package:authenticator/core/themes/app_colors.dart';
import 'package:authenticator/features/presentation/bloc/delete_account_bloc/deleteaccount_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void deleteStateHandle(BuildContext context, DeleteaccountState state) {

  if (state is DeleteAccountSuccess) {
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
  } else if (state is DeleteAccountWithoutSincAlert) {
    showCupertinoDialog(
      context: context,
      builder:
          (dialogContext) => CupertinoAlertDialog(
            title: Text('Session Warning'),
            content: Text(
              "Are you sure you want to delete your account? Your request will be processed after sync & backup is enabled, then the deletion will proceed."
            ),
            actions: [
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text('Cancel',style: TextStyle(color: AppPalette.blackColor),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
    );
  } else if (state is DeleteAccountConfirmationAlert) {
     showCupertinoDialog(
      context: context,
      builder:
          (dialogContext) => CupertinoAlertDialog(
            title: Text('Session Warning',style: TextStyle(color: AppPalette.redColor),),
            content: Text(
               'Are you sure you want to delete your account?',
               style: TextStyle(color: AppPalette.redColor),
            ),
            actions: [
              CupertinoDialogAction(
                child: Text(
                  "Yes, proceed",
                  style: TextStyle(color: AppPalette.redColor),
                ),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                 context.read<DeleteaccountBloc>().add(DeleteConfirm());
                },
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text('Cancel',style: TextStyle(color: AppPalette.blackColor),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
    );
  } else if (state is DeleteAccountFailure) {
    CustomSnackBar.show(
      context,
      message: state.message,
      backgroundColor: AppPalette.redColor,
      textAlign: TextAlign.center
    );
  }
}
