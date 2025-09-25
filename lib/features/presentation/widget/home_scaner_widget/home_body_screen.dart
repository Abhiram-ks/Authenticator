
import 'package:authenticator/core/common/custom_button.dart';
import 'package:authenticator/core/constant/app_images.dart';
import 'package:authenticator/core/constant/constant.dart';
import 'package:authenticator/core/themes/app_colors.dart';
import 'package:authenticator/features/presentation/bloc/navigation_cubit/navigation_cubit.dart';
import 'package:authenticator/features/presentation/screen/qr_screen.dart';
import 'package:authenticator/features/presentation/widget/home_scaner_widget/scaner_parse_auth_uri.dart';
import 'package:authenticator/features/presentation/widget/home_scaner_widget/scaner_qr_result_screen.dart';
import 'package:authenticator/features/presentation/widget/home_scaner_widget/scaner_result_subscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({
    super.key,
    required this.width,
    required this.height,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      keyboardDismissBehavior:
          ScrollViewKeyboardDismissBehavior.onDrag,
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Import accounts',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            ConstantWidgets.hight10(context),
            Text(
              'Easily add your 2FA accounts by scanning a QR code or entering a setup key. Safely protect your valuable assets.',
            ),
            ConstantWidgets.hight50(context),
            Center(
              child: Image.asset(
                AppImages.qrcode,
                height: height * 0.2,
              ),
            ),
            Text(
              "Secure your accounts with end-to-end encrypted authentication.",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
            ConstantWidgets.hight30(context),
            CustomButton(
              text: "Scan QR Code",
              onPressed: () async {
                final result = await Navigator.of(
                  context,
                ).push<String?>(
                  MaterialPageRoute(
                    builder: (_) => const QrScannerScreen(),
                  ),
                );
                if (result != null && result.isNotEmpty) {
                  final parsed = parseOtpAuthUri(result);
                  if (parsed != null) {
                    if (!context.mounted) return;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (_) => QrResultScreen(account: parsed),
                      ),
                    );  
                  } else {
                    if (!context.mounted) return;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (_) =>
                                RawQrResultScreen(rawValue: result),
                      ),
                    );
                  }
                }
              },
            ),
            ConstantWidgets.hight10(context),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Enable Backup',
                    onPressed: () {
                         context.read<ButtomNavCubit>().selectItem(
                        NavItem.cloud,
                      );
                    },
                    bgColor: AppPalette.whiteColor,
                    borderColor: AppPalette.blueColor,
                    textColor: AppPalette.blueColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: 'Import Account',
                    onPressed: () {
                       context.read<ButtomNavCubit>().selectItem(
                        NavItem.search,
                      );
                    },
                    bgColor: AppPalette.whiteColor,
                    borderColor: AppPalette.blueColor,
                    textColor: AppPalette.blueColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
