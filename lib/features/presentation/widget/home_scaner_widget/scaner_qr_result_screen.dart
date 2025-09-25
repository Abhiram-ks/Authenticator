
import 'package:authenticator/core/common/custom_appbar.dart';
import 'package:authenticator/core/common/custom_button.dart';
import 'package:authenticator/core/common/custom_snackbar.dart';
import 'package:authenticator/core/common/custom_textfiled.dart';
import 'package:authenticator/core/constant/constant.dart';
import 'package:authenticator/core/themes/app_colors.dart';
import 'package:authenticator/core/validation/validation_helper.dart';
import 'package:authenticator/features/presentation/bloc/progresser_cubit/progresser_cubit.dart';
import 'package:authenticator/features/data/datasource/account_remote_datasource.dart';
import 'package:authenticator/features/presentation/widget/home_scaner_widget/scaner_auth_account_data.dart';
import 'package:authenticator/features/presentation/widget/home_scaner_widget/scaner_totp_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class QrResultScreen extends StatefulWidget {
  final AuthAccount account;
  const QrResultScreen({super.key, required this.account});

  @override
  State<QrResultScreen> createState() => _QrResultScreenState();
}

class _QrResultScreenState extends State<QrResultScreen> {
  late Timer _timer;
  late String _code;
  late int _remaining;
  final TextEditingController _ctrl = TextEditingController();
  String? _verifyMessage;
  Color? _verifyColor;
  final AccountRemoteDataSource _accountDS = AccountRemoteDataSource();
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _updateCode();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateCode());
    _saveIfNeeded();
  }

  void _updateCode() {
    final period = widget.account.period > 0 ? widget.account.period : 30;
    final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
    final elapsed = now % period;
    final remaining = period - elapsed;

    final secret = widget.account.secret;
    final digits = widget.account.digits;

    final code = TotpUtils.generateTOTPCode(
      secret: secret,
      digits: digits,
      period: period,
      forTimeSeconds: now,
    );

    setState(() {
      _code = code;
      _remaining = remaining;
    });
  }

  Future<void> _saveIfNeeded() async {
    try {
      if (_saved) return;
      await _accountDS.saveAccount(widget.account);
      if (mounted) {
        setState(() {
          _saved = true;
        });
      }
    } catch (e) {
      // Ignore if not signed in or any error; UI remains functional
    }
  }

  void _verify() {
    final entered = _ctrl.text.trim();
    if (entered.isEmpty) {
      _showResult('Please enter the 6-digit code', AppPalette.blueColor);
      return;
    }
    if (entered == _code) {
      _showResult('Code verified — correct', AppPalette.greenColor);
    } else {
      final period = widget.account.period;
      final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
      final prevCode = TotpUtils.generateTOTPCode(
        secret: widget.account.secret,
        digits: widget.account.digits,
        period: period,
        forTimeSeconds: now - period,
      );
      final nextCode = TotpUtils.generateTOTPCode(
        secret: widget.account.secret,
        digits: widget.account.digits,
        period: period,
        forTimeSeconds: now + period,
      );

      if (entered == prevCode || entered == nextCode) {
        _showResult(
          'Code accepted (clock drift) — correct',
          AppPalette.blueColor,
        );
      } else {
        _showResult('Incorrect code', AppPalette.redColor);
      }
    }
  }

  void _showResult(String text, Color color) {
    setState(() {
      _verifyMessage = text;
      _verifyColor = color;
    });
     CustomSnackBar.show(context, message: text, backgroundColor: AppPalette.blueColor,textAlign: TextAlign.center);
  }

  @override
  void dispose() {
    _timer.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final period = widget.account.period;
    final progress = (_remaining / (period > 0 ? period : 30)).clamp(0.0, 1.0);

    return BlocProvider(
      create: (context) => ProgresserCubit(),
      child: LayoutBuilder(
        builder: (context, constraints)  {
          final width = constraints.maxWidth;
          final heigh = constraints.maxHeight;

          return ColoredBox(
            color: AppPalette.blueColor,
            child: SafeArea(
              child: Scaffold(
                appBar: CustomAppBar(
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Icon(Icons.info_outlined),
                    ),
                  ],
                  isTitle: true,
                  title: 'Scan QR Code',
                  backgroundColor: AppPalette.whiteColor,
                ),
                body: SingleChildScrollView(
                  
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width * .06, vertical: heigh *.01),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                              'Authenticator',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ConstantWidgets.hight10(context),
                            Text(
                             'End-to-end encrypted communication ensuring complete data security.',
                            ), ConstantWidgets.hight20(context),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Issuer: ${widget.account.issuer}",
                                style: GoogleFonts.poppins(fontSize: 16),
                              ),
                              Text(
                                "Label: ${widget.account.label}",
                                style: GoogleFonts.poppins(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                  
                       ConstantWidgets.hight20(context),
                        Card(
                          color: AppPalette.whiteColor,
                          elevation: 7,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 18.0,
                              horizontal: 12.0,
                            ),
                            child: Column(
                              children: [
                                Text(
                                  _code,
                                  style: GoogleFonts.robotoMono(
                                    fontSize: 48,
                                    letterSpacing: 8,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                ConstantWidgets.hight10(context),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Expires in $_remaining s",
                                      style: GoogleFonts.poppins(fontSize: 12),
                                    ),
                                     ConstantWidgets.width20(context),
                                    SizedBox(
                                      width: 80,
                                      child: LinearProgressIndicator(value: progress,backgroundColor: AppPalette.hintColor,color: AppPalette.blueColor,),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        ConstantWidgets.hight20(context),
                        TextFormFieldWidget(label: 'Varify Code', hintText: 'Enter code to varify', prefixIcon: Icons.lock_clock_outlined, controller: _ctrl, validate: ValidatorHelper.textFieldValidation),
                        ConstantWidgets.hight20(context),
                        CustomButton(text: "Verify", onPressed: _verify),
                        if (_verifyMessage != null) ...[
                          ConstantWidgets.hight10(context),
                          Center(
                            child: Text(
                              _verifyMessage ?? 'Unexpected error',
                              style: GoogleFonts.poppins(color: _verifyColor),
                            ),
                          ),
                        ],
                        ConstantWidgets.hight20(context),
                        
                        Center(
                          child: Text(
                            "Secret: ${widget.account.secret}",
                            style: GoogleFonts.poppins(fontSize: 12),
                          ),
                        ),
                        Center(
                          child: Text(
                            "Digits: ${widget.account.digits}, Period: ${widget.account.period}s",
                            style: GoogleFonts.poppins(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}