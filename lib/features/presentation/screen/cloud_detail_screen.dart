
import 'package:authenticator/core/common/custom_appbar.dart';
import 'package:authenticator/core/common/custom_button.dart';
import 'package:authenticator/core/common/custom_snackbar.dart';
import 'package:authenticator/core/constant/constant.dart';
import 'package:authenticator/core/themes/app_colors.dart';
import 'package:authenticator/features/data/datasource/account_remote_datasource.dart';
import 'package:authenticator/features/presentation/bloc/progresser_cubit/progresser_cubit.dart';
import 'package:authenticator/features/presentation/bloc/totp_cubit/totp_cubit.dart';
import 'package:authenticator/features/presentation/widget/home_scaner_widget/scaner_auth_account_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class CloudDetailScreen extends StatelessWidget {
  final AuthAccount account;

  const CloudDetailScreen({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => TotpCubit(account: account)),
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
                  isTitle: true,
                  title:
                      '//${account.issuer.isNotEmpty ? account.issuer : 'Account'}: ${account.label}',
                ),
                body: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * .06),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstantWidgets.hight30(context),
                        Card(
                          color: AppPalette.whiteColor,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Account Information',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppPalette.blackColor,
                                  ),
                                ),
                                ConstantWidgets.hight20(context),

                                _buildInfoRow(
                                  'Issuer',
                                  account.issuer.isNotEmpty
                                      ? account.issuer
                                      : 'N/A',
                                ),
                                _buildInfoRow('Label', account.label),
                                _buildInfoRow(
                                  'Digits',
                                  account.digits.toString(),
                                ),
                                _buildInfoRow(
                                  'Period',
                                  '${account.period} seconds',
                                ),
                              ],
                            ),
                          ),
                        ),

                        ConstantWidgets.hight30(context),
                        Card(
                          color: AppPalette.whiteColor,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Two-Factor Authentication',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                ConstantWidgets.hight20(context),
                                Center(
                                  child: BlocSelector<
                                    TotpCubit,
                                    TotpState,
                                    ({int remaining, int period})
                                  >(
                                    selector:
                                        (state) => (
                                          remaining: state.remainingSeconds,
                                          period: state.period,
                                        ),
                                    builder: (context, data) {
                                      final progress = (data.remaining /
                                              data.period)
                                          .clamp(0.0, 1.0);
                                      return Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: CircularProgressIndicator(
                                              value: progress,
                                              strokeWidth: 8,
                                              backgroundColor: AppPalette
                                                  .hintColor
                                                  .withValues(alpha: 0.3),
                                              color: AppPalette.blueColor,
                                            ),
                                          ),
                                          Text(
                                            '${data.remaining}s',
                                            style: GoogleFonts.poppins(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: AppPalette.blueColor,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),

                                ConstantWidgets.hight30(context),
                                Center(
                                  child: BlocSelector<
                                    TotpCubit,
                                    TotpState,
                                    String
                                  >(
                                    selector: (state) => state.code,
                                    builder: (context, code) {
                                      return Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            code,
                                            style: GoogleFonts.poppins(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              fontFeatures: const [
                                                FontFeature.tabularFigures(),
                                              ],
                                              color: AppPalette.blackColor,
                                            ),
                                          ),
                                          ConstantWidgets.width20(context),
                                          GestureDetector(
                                            onTap: () {
                                              Clipboard.setData(
                                                ClipboardData(text: code),
                                              );
                                              CustomSnackBar.show(
                                                context,
                                                message:
                                                    'OTP code copied to clipboard',
                                                textAlign: TextAlign.center,
                                              );
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: AppPalette.blueColor
                                                    .withValues(alpha: 0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Icon(
                                                Icons.copy,
                                                size: 20,
                                                color: AppPalette.blueColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),

                                ConstantWidgets.hight20(context),
                                Center(
                                  child: Text(
                                    'Tap the copy icon to copy the code',
                                    style: GoogleFonts.poppins(fontSize: 10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        ConstantWidgets.hight30(context),
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            text: 'Disable 2FA',
                            onPressed: () => _showDisableConfirmation(context),
                            textColor: AppPalette.redColor,
                            borderColor: AppPalette.redColor,
                            bgColor: AppPalette.whiteColor,
                          ),
                        ),

                        ConstantWidgets.hight30(context),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppPalette.greyColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppPalette.blackColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDisableConfirmation(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder:
          (dialogContext) => CupertinoAlertDialog(
            title: Text('Disable 2FA'),
            content: Text(
              'Are you sure you want to disable 2FA for this account? This action cannot be undone and will permanently delete the account from your cloud sync.',
            ),
            actions: [
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text(
                  'Disable',
                  style: TextStyle(color: AppPalette.redColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _disableAccount(context);
                },
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AppPalette.blackColor),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );
  }

  Future<void> _disableAccount(BuildContext context) async {
    try {
      final dataSource = AccountRemoteDataSource();
      await dataSource.deleteAccount(account.id);

      if (context.mounted) {
        CustomSnackBar.show(
          context,
          message: '2FA account disabled successfully',
          backgroundColor: AppPalette.greenColor,
          textAlign: TextAlign.center,
        );

        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackBar.show(
          context,
          message: 'Failed to disable 2FA: ${e.toString()}',
          backgroundColor: AppPalette.redColor,
          textAlign: TextAlign.center,
        );
      }
    }
  }
}
