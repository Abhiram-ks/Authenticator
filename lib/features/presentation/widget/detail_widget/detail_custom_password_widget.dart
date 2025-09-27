import 'package:authenticator/core/themes/app_colors.dart';
import 'package:authenticator/features/presentation/bloc/icon_cubit/icon_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class PasswordDetailField extends StatelessWidget {
  final String? password; // already plain or decrypted password
  final String label;

  const PasswordDetailField({
    super.key,
    required this.password,
    this.label = "Password",
  });

  @override
  Widget build(BuildContext context) {
    if (password == null || password!.isEmpty) {
      return Text(
        "$label: N/A",
        style: const TextStyle(color: AppPalette.greyColor),
      );
    }

    return BlocProvider(
      create: (_) => IconCubit(),
      child: BlocBuilder<IconCubit, IconState>(
        builder: (context, state) {
          final isVisible =
              state is PasswordVisibilityUpdated ? state.isVisible : false;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isVisible ? Icons.visibility : Icons.visibility_off,
                      color: AppPalette.greyColor,
                      size: 18,
                    ),
                    onPressed: () {
                      context.read<IconCubit>().togglePasswordVisibility(isVisible);
                    },
                  ),
                  if (isVisible)
                    IconButton(
                      icon: const Icon(Icons.copy,
                          size: 16, color: AppPalette.greyColor),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: password!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("$label copied to clipboard", textAlign: TextAlign.center,),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                ],
              ),
              Text(
                isVisible ? password ?? 'Decryption Failed' : "••••••••",
                style: const TextStyle(color: AppPalette.greyColor),
              ),
            ],
          );
        },
      ),
    );
  }
}