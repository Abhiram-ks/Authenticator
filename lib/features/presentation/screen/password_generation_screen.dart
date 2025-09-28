import 'package:authenticator/core/common/custom_appbar.dart';
import 'package:authenticator/core/common/custom_button.dart';
import 'package:authenticator/core/constant/constant.dart';
import 'package:authenticator/core/themes/app_colors.dart';
import 'package:authenticator/features/domain/entity/password_generation_entity.dart';
import 'package:authenticator/features/domain/usecase/password_generation_usecase.dart';
import 'package:authenticator/features/presentation/bloc/password_generation_cubit/password_generation_cubit.dart';
import 'package:authenticator/features/presentation/bloc/password_generation_cubit/password_generation_event.dart';
import 'package:authenticator/features/presentation/bloc/password_generation_cubit/password_generation_state.dart';
import 'package:authenticator/features/presentation/bloc/progresser_cubit/progresser_cubit.dart';
import 'package:authenticator/features/presentation/widget/detail_widget/detail_custom_password_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordGenerationScreen extends StatelessWidget {
  const PasswordGenerationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) =>
                  PasswordGenerationCubit(useCase: PasswordGenerationUseCase()),
        ),
        BlocProvider(create: (context) => ProgresserCubit()),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;

          return ColoredBox(
            color: AppPalette.blueColor,
            child: SafeArea(
              child: Scaffold(
                appBar: CustomAppBar(
                  title: 'Generate Password',
                  isTitle: true,
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.help_outline,
                        color: AppPalette.greyColor,
                      ),
                      onPressed: () {
                        showHelpDialogPassword(context);
                      },
                    ),
                  ],
                ),
                body: BlocConsumer<
                  PasswordGenerationCubit,
                  PasswordGenerationState
                >(
                  listener: (context, state) {
                    if (state is PasswordGenerationError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Error generating password: //${state.error}',
                          ),
                          backgroundColor: AppPalette.redColor,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: width * .05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            color: AppPalette.whiteColor,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Password Options',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppPalette.blackColor,
                                    ),
                                  ),
                                  ConstantWidgets.hight10(context),
                                  buildLengthSlider(
                                    context,
                                    state.options.length,
                                  ),
                                  ConstantWidgets.hight10(context),
                                  buildCharacterTypeOptions(
                                    context,
                                    state.options,
                                  ),
                                  ConstantWidgets.hight10(context),
                                  buildPasswordStrengthIndicator(
                                    context,
                                    state.passwordStrength,
                                    state.strengthDescription,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          ConstantWidgets.hight20(context),
                          CustomButton(
                            text: 'Generate Password',
                            onPressed:
                                state.options.hasValidOptions
                                    ? () {
                                      context
                                          .read<PasswordGenerationCubit>()
                                          .add(const GeneratePassword());
                                    }
                                    : null,
                          ),

                          ConstantWidgets.hight20(context),
                          if (state.generatedPassword != null) ...[
                            Card(
                              color: AppPalette.whiteColor,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: PasswordDetailField(
                                  password: state.generatedPassword,
                                  label: 'Generated Password',
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget buildPasswordStrengthIndicator(
  BuildContext context,
  double strength,
  String strengthDescription,
) {
  Color strengthColor;

  if (strength < 30) {
    strengthColor = AppPalette.redColor;
  } else if (strength < 60) {
    strengthColor = Colors.orange;
  } else if (strength < 80) {
    strengthColor = Colors.yellow[700]!;
  } else {
    strengthColor = Colors.green;
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Password Strength',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            strengthDescription,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: strengthColor,
            ),
          ),
        ],
      ),
      ConstantWidgets.hight10(context),
      LinearProgressIndicator(
        value: strength / 100,
        backgroundColor: AppPalette.greyColor.withValues(alpha: 0.3),
        valueColor: AlwaysStoppedAnimation<Color>(strengthColor),
        minHeight: 8,
      ),
      ConstantWidgets.hight10(context),
      Text(
        '${strength.toStringAsFixed(0)}%',
        style: TextStyle(fontSize: 12, color: AppPalette.greyColor),
      ),
    ],
  );
}

Widget buildLengthSlider(BuildContext context, int length) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Password Length',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            '$length',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppPalette.blueColor,
            ),
          ),
        ],
      ),
      Slider(
        value: length.toDouble(),
        min: 4,
        max: 50,
        divisions: 46,
        activeColor: AppPalette.blueColor,
        inactiveColor: AppPalette.greyColor,
        onChanged: (value) {
          context.read<PasswordGenerationCubit>().add(
            UpdatePasswordLength(value.round()),
          );
        },
      ),
    ],
  );
}

Widget buildCharacterTypeToggle(
  BuildContext context,
  String title,
  bool value,
  PasswordGenerationEvent event,
) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 4),
    decoration: BoxDecoration(
      color:
          value
              ? AppPalette.blueColor.withValues(alpha: 0.1)
              : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color:
            value
                ? AppPalette.blueColor
                : AppPalette.greyColor.withValues(alpha: 0.3),
        width: 1,
      ),
    ),
    child: ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: value ? FontWeight.w600 : FontWeight.normal,
          color: value ? AppPalette.blueColor : AppPalette.blackColor,
        ),
      ),
      trailing: Switch(
        value: value,
        activeColor: AppPalette.blueColor,
        activeTrackColor: AppPalette.blueColor.withValues(alpha: 0.3),
        inactiveThumbColor: AppPalette.greyColor,
        inactiveTrackColor: AppPalette.greyColor.withValues(alpha: 0.3),
        onChanged: (newValue) {
          context.read<PasswordGenerationCubit>().add(event);
        },
      ),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      onTap: () {
        context.read<PasswordGenerationCubit>().add(event);
      },
    ),
  );
}

void showHelpDialogPassword(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder:
        (context) => CupertinoAlertDialog(
          title: const Text('Password Generation Help'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(height: 8),
                Text(
                  'Tips for creating strong passwords:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('• Use at least 12 characters'),
                Text('• Include a mix of character types'),
                Text('• Avoid common patterns and words'),
                Text('• Don\'t reuse passwords across accounts'),
                SizedBox(height: 16),
                Text(
                  'Character Types:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('• Digits: 0-9'),
                Text('• Lowercase: a-z'),
                Text('• Uppercase: A-Z'),
                Text('• Special: !@#\$%^&*()_+-=[]{}|;:,.<>?'),
              ],
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Got it',
                style: TextStyle(color: AppPalette.blueColor),
              ),
            ),
          ],
        ),
  );
}

Widget buildCharacterTypeOptions(
  BuildContext context,
  PasswordGenerationOptions options,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Character Types',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      ConstantWidgets.hight10(context),
      buildCharacterTypeToggle(
        context,
        'Include Digits (0-9)',
        options.includeDigits,
        const ToggleIncludeDigits(),
      ),
      buildCharacterTypeToggle(
        context,
        'Include Lowercase (a-z)',
        options.includeLowercase,
        const ToggleIncludeLowercase(),
      ),
      buildCharacterTypeToggle(
        context,
        'Include Uppercase (A-Z)',
        options.includeUppercase,
        const ToggleIncludeUppercase(),
      ),
      buildCharacterTypeToggle(
        context,
        'Include Special Characters (!@#...)',
        options.includeSpecialCharacters,
        const ToggleIncludeSpecialCharacters(),
      ),
    ],
  );
}

void showHelpDialogAuthenticator(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder:
        (context) => CupertinoAlertDialog(
          title: const Text('Authenticator Help'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                SizedBox(height: 8),
                Text(
                  'How to use the Authenticator:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '• Scan the QR code from your account setup page. The app will automatically generate a TOTP (time-based one-time password).Use the generated code to sign in securely (2FA).',
                ),
                SizedBox(height: 16),

                Text(
                  'Cloud Sync & Backup:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '• You can enable Cloud Sync to keep your accounts backed up. Disable Cloud Sync anytime if you prefer offline-only use. Backup and restore are free with your account.',
                ),
                SizedBox(height: 16),

                Text(
                  'Quick Tips:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '• Add multiple accounts easily by scanning QR codes. You can delete or edit any entry anytime. Always keep a backup option enabled to avoid losing access.',
                ),
              ],
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Got it',
                style: TextStyle(color: AppPalette.blueColor),
              ),
            ),
          ],
        ),
  );
}


void showHelperDialogForPassword (BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: const Text('Secure Data Helper'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(height: 8),
            Text(
              'How your data is handled:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('• All credentials are stored securely with end-to-end encryption. Your information is used only for identity verification and never shared.'),
            SizedBox(height: 16),
            Text(
              'Features you can use:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('• Securely save and manage your credentials, search with smart filters, organize by category, mark favorites, and view details safely.'),
            SizedBox(height: 16),
            Text(
              'Our commitment:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('• Your privacy and security are our top priority. Data remains encrypted, even during sync and backup. Keeping our community safe with verified, secure information.'),
          ],
        ),
      ),
      actions: [
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Got it',
            style: TextStyle(color: AppPalette.blueColor),
          ),
        ),
      ],
    ),
  );
}
