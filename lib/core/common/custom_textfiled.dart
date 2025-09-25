import 'package:authenticator/core/constant/constant.dart';
import 'package:authenticator/core/themes/app_colors.dart';
import 'package:authenticator/features/presentation/bloc/icon_cubit/icon_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TextFormFieldWidget extends StatelessWidget {
  final String? label;
  final String hintText;
  final IconData? prefixIcon;
  final bool isPasswordField;
  final TextEditingController? controller;
  final String? Function(String? value)? validate;
  final bool enabled;
  final Color? borderClr;
  final Color? suffixIconColor;
  final Color? fillClr;
  final ValueChanged<String>? onChanged;
  final IconData? suffixIconData;
  final VoidCallback? suffixIconAction;
  final double? borderRadius;
    final int? minLines;  
  final int? maxLines;  

  const TextFormFieldWidget({
    super.key,
    this.label,
    required this.hintText,
    this.prefixIcon,
    this.isPasswordField = false,
    this.controller,
    this.validate,
    this.enabled = true,
    this.borderClr,
    this.fillClr,
    this.suffixIconColor,
    this.onChanged,
    this.suffixIconData,
    this.suffixIconAction,
    this.borderRadius = 10,
    this.minLines = 1,   
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IconCubit(),
      child: Builder(
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (label != null)
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 5),
                  child: Text(
                    label ?? 'No ',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

              BlocSelector<IconCubit, IconState, bool>(
                selector: (state) {
                  if (state is PasswordVisibilityUpdated) {
                    return state.isVisible;
                  }
                  return false;
                },
                builder: (context, isVisible) {
                  return TextFormField(
                    controller: controller,
                    validator: validate,
                    obscureText: isPasswordField ? !isVisible : false,
                    style: const TextStyle(fontSize: 16),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    enabled: enabled,
                    onChanged: onChanged,
                    minLines: minLines,
                    maxLines: isPasswordField ? 1 : maxLines, 
                    decoration: InputDecoration(
                      filled: fillClr != null,
                      fillColor: fillClr,
                      hintText: hintText,
                      hintStyle: TextStyle(color: AppPalette.hintColor),
                      prefixIcon:
                          prefixIcon != null
                              ? Icon(
                                prefixIcon,
                                color: const Color.fromARGB(255, 52, 52, 52),
                              )
                              : null, //
                      suffixIcon:
                          (suffixIconData != null || isPasswordField)
                              ? GestureDetector(
                                onTap: () {
                                  if (isPasswordField) {
                                    context
                                        .read<IconCubit>()
                                        .togglePasswordVisibility(isVisible);
                                  }
                                  if (suffixIconData != null) {
                                    suffixIconAction?.call();
                                  }
                                },
                                child:
                                    isPasswordField
                                        ? Icon(
                                          isVisible
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.black,
                                        )
                                        : Icon(
                                          suffixIconData,
                                          color: suffixIconColor,
                                        ),
                              )
                              : null,

                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          borderRadius ?? 10.00,
                        ),
                        borderSide: BorderSide(
                          color: borderClr ?? AppPalette.hintColor,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          borderRadius ?? 10.00,
                        ),
                        borderSide: BorderSide(
                          color: AppPalette.blueColor,
                          width: 1,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          borderRadius ?? 10.00,
                        ),
                        borderSide: BorderSide(
                          color: AppPalette.redColor,
                          width: 1,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          borderRadius ?? 10.00,
                        ),
                        borderSide: BorderSide(
                          color: AppPalette.redColor,
                          width: 1,
                        ),
                      ),
                    ),
                  );
                },
              ),
              ConstantWidgets.hight10(context),
            ],
          );
        },
      ),
    );
  }
}
