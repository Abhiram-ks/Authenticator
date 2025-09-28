import 'package:authenticator/core/common/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


Future<void> openWebPage({
  required BuildContext context,
  required String url,
  required String errorMessage,
}) async {
  final Uri uri = Uri.parse(url);
  final bool launched = await launchUrl(uri, mode: LaunchMode.inAppWebView);

  if (!launched) {
    if (context.mounted) {
      CustomSnackBar.show(context, message: errorMessage, textAlign: TextAlign.center);
    }
  }
}


