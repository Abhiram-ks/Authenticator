
import 'package:authenticator/core/constant/app_images.dart';
import 'package:authenticator/core/constant/constant.dart';
import 'package:authenticator/core/themes/app_colors.dart';
import 'package:authenticator/features/presentation/bloc/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomGoogleField {
  static Widget googleSignInModule({
    required BuildContext context,
    required double screenWidth,
    required double screenHeight,
    required VoidCallback onTap,
  }) {
    return Container(
      width: screenWidth,
      height: screenHeight * 0.062,
      decoration: BoxDecoration(
        color: AppPalette.whiteColor.withAlpha((0.87 * 255).round()),
        border: Border.all(color: AppPalette.hintColor, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: AppPalette.hintColor.withAlpha(100),
          borderRadius: BorderRadius.circular(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.googleLogo,
                height: screenHeight * 0.06,
                fit: BoxFit.contain,
              ),
              ConstantWidgets.width20(context),
              BlocBuilder<ProgresserCubit, ProgresserState>(
                builder: (context, progresser) {
                  if (progresser is ButtonProgressStart) {
                    return Text(
                      'Please wait...',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppPalette.blackColor,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }
                  return Text(
                    'Sign Up with Google',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppPalette.blackColor,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
