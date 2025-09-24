
import 'package:authenticator/core/themes/app_colors.dart';
import 'package:authenticator/features/presentation/bloc/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color bgColor;
  final Color textColor;
  final double borderRadius;
  final Color? borderColor;
  final EdgeInsetsGeometry padding;
  final double fontSize;
  final FontWeight fontWeight;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.bgColor = AppPalette.blueColor,
    this.textColor = AppPalette.whiteColor,
    this.borderRadius = 9,
    this.borderColor,
    this.padding = const EdgeInsets.symmetric(vertical: 14),
    this.fontSize = 16,
    this.fontWeight = FontWeight.w600,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side:
                borderColor != null
                    ? BorderSide(color: borderColor!)
                    : BorderSide.none,
          ),
        ),
        onPressed: onPressed,
        child: Center(
          child: BlocBuilder<ProgresserCubit, ProgresserState>(
            builder: (context, state) {
              if (state is ButtonProgressStart) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: AppPalette.whiteColor,
                        strokeWidth: 2.5,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Please wait...',
                      style: TextStyle(fontSize: 18, color: AppPalette.whiteColor),
                    ),
                  ],
                );
              } 
              return Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  color: textColor,
                  fontWeight: fontWeight,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
