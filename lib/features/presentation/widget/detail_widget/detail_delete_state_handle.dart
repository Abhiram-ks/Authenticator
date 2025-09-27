import 'package:authenticator/core/common/custom_snackbar.dart';
import 'package:authenticator/core/themes/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/delete_credential_bloc/delete_credential_bloc.dart';
import '../../bloc/delete_credential_bloc/delete_credential_event.dart';
import '../../bloc/delete_credential_bloc/delete_credential_state.dart';

void deleteCredentialStateHandle(
  BuildContext context,
  DeleteCredentialState state,
  final String docID
) {
  if (state is DeleteCredentialSuccess) {
    
      Navigator.pop(context);
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  } else if (state is DeleteCredentialWithFavConfirmationAlert) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) => CupertinoAlertDialog(
            title: Text('Session Warning'),
            content: Text(
             'Are you sure you want to delete this data? Your request will be processed after the favorite category is disabled, and then the deletion will proceed.'
            ),
            actions: [
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppPalette.blackColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
    );
  } else if (state is DeleteCredentialConfirmationAlert) {
    showCupertinoDialog(
      context: context,
      builder:
          (dialogContext) => CupertinoAlertDialog(
            title: Text(
              'Session Warning',
              style: TextStyle(color: AppPalette.redColor),
            ),
            content: Text(
              'Are you sure you want to delete this data?',
            ),
            actions: [
              CupertinoDialogAction(
                child: Text(
                  "Yes, proceed",
                  style: TextStyle(color: AppPalette.redColor),
                ),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  context.read<DeleteCredentialBloc>().add(DeleteCredentialRequestConfirm(docId: docID));
                },
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppPalette.blackColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
    );
  } else if (state is DeleteCredentialError) {
    CustomSnackBar.show(
      context,
      message: state.message,
      backgroundColor: AppPalette.redColor,
      textAlign: TextAlign.center,
    );
  }
}
