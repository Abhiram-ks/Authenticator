import 'dart:developer';

import 'package:authenticator/core/common/custom_appbar.dart';
import 'package:authenticator/core/common/custom_button.dart';
import 'package:authenticator/core/common/custom_snackbar.dart';
import 'package:authenticator/core/common/custom_textfiled.dart';
import 'package:authenticator/core/constant/app_images.dart';
import 'package:authenticator/core/constant/constant.dart';
import 'package:authenticator/core/themes/app_colors.dart';
import 'package:authenticator/core/validation/validation_helper.dart';
import 'package:authenticator/features/presentation/bloc/progresser_cubit/progresser_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class TotpUtils {
  static const _alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';

  static Uint8List base32Decode(String input) {
    final cleaned = input.replaceAll('=', '').replaceAll(' ', '').toUpperCase();
    final bits = StringBuffer();

    for (final ch in cleaned.split('')) {
      final val = _alphabet.indexOf(ch);
      if (val < 0) continue;
      bits.write(val.toRadixString(2).padLeft(5, '0'));
    }

    final bitStr = bits.toString();
    final bytes = <int>[];
    for (var i = 0; i + 8 <= bitStr.length; i += 8) {
      final byteStr = bitStr.substring(i, i + 8);
      bytes.add(int.parse(byteStr, radix: 2));
    }
    return Uint8List.fromList(bytes);
  }

  static String generateTOTPCode({
    required String secret,
    int digits = 6,
    int period = 30,
    int? forTimeSeconds,
  }) {
    try {
      final key = base32Decode(secret);
      final unixTime =
          (forTimeSeconds != null)
              ? forTimeSeconds
              : DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
      final counter = unixTime ~/ period;

      final counterBytes = _int64ToBytes(counter);
      final hmac = Hmac(sha1, key);
      final digest = hmac.convert(counterBytes).bytes;

      final offset = digest[digest.length - 1] & 0x0f;
      final binary =
          ((digest[offset] & 0x7f) << 24) |
          ((digest[offset + 1] & 0xff) << 16) |
          ((digest[offset + 2] & 0xff) << 8) |
          (digest[offset + 3] & 0xff);

      final divisor = _pow10(digits);
      final otp = binary % divisor;
      return otp.toString().padLeft(digits, '0');
    } catch (e) {
      return '------';
    }
  }

  static Uint8List _int64ToBytes(int value) {
    final bytes = Uint8List(8);
    final bd = ByteData.view(bytes.buffer);
    bd.setUint64(0, value, Endian.big);
    return bytes;
  }

  static int _pow10(int d) {
    var res = 1;
    for (var i = 0; i < d; i++) {
      res *= 10;
    }
    return res;
  }
}

class AuthAccount {
  final String id;
  final String issuer;
  final String label;
  final String secret;
  final int digits;
  final int period;

  AuthAccount({
    required this.id,
    required this.issuer,
    required this.label,
    required this.secret,
    this.digits = 6,
    this.period = 30,
  });
}

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

  @override
  void initState() {
    super.initState();
    _updateCode();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateCode());
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
     CustomSnackBar.show(context, message: text, backgroundColor: AppPalette.blueColor);
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

AuthAccount? parseOtpAuthUri(String uriStr) {
  try {
    final uri = Uri.parse(uriStr);
    if (uri.scheme != 'otpauth') return null;
    if (uri.host.toLowerCase() != 'totp') return null;

    String path = uri.path;
    if (path.startsWith('/')) path = path.substring(1);
    String issuerFromPath = '';
    String label = path;
    if (path.contains(':')) {
      final parts = path.split(':');
      issuerFromPath = parts.first;
      label = parts.sublist(1).join(':');
    }

    final params = uri.queryParameters;
    final secret = params['secret'];
    if (secret == null || secret.trim().isEmpty) return null;

    String issuer = params['issuer'] ?? issuerFromPath;
    final digits = int.tryParse(params['digits'] ?? '') ?? 6;
    final period = int.tryParse(params['period'] ?? '') ?? 30;

    return AuthAccount(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      issuer: issuer,
      label: label,
      secret: secret,
      digits: digits,
      period: period,
    );
  } catch (e) {
    return null;
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProgresserCubit(),
      child: ColoredBox(
        color: AppPalette.blueColor,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final height = constraints.maxHeight;
              return Scaffold(
                appBar: CustomAppBar(
                  isTitle: true,
                  title: 'Authenticator',
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.info_outline_rounded),
                      ),
                    ),
                  ],
                ),
                body: SingleChildScrollView(
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
                                onPressed: () {},
                                bgColor: AppPalette.whiteColor,
                                borderColor: AppPalette.blueColor,
                                textColor: AppPalette.blueColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: CustomButton(
                                text: 'Import Account',
                                onPressed: () {},
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  bool _isDetecting = false;
  final MobileScannerController _controller = MobileScannerController();

  void _onDetect(BarcodeCapture capture) {
    if (_isDetecting) return;
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;
    final raw = barcodes.first.rawValue ?? '';
    if (raw.isEmpty) return;

    _isDetecting = true;
    Navigator.of(context).pop(raw);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(controller: _controller, onDetect: _onDetect),
          Container(
            decoration: ShapeDecoration(
              shape: QrScannerOverlayShape(
                borderColor: AppPalette.blueColor,
                borderRadius: 16,
                borderLength: 32,
                borderWidth: 6,
                cutOutSize: MediaQuery.of(context).size.width * 0.7,
              ),
            ),
          ),

          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Text(
                  "Align QR code inside the frame",
                  style: TextStyle(
                    color: AppPalette.greyColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPalette.blueColor,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 22,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppPalette.whiteColor),
                  label: const Text(
                    "Cancel",
                    style: TextStyle(color: AppPalette.whiteColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QrScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  const QrScannerOverlayShape({
    this.borderColor = Colors.white,
    this.borderWidth = 4.0,
    this.borderRadius = 12.0,
    this.borderLength = 24.0,
    required this.cutOutSize,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      Path()..addRect(rect);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      Path()..addRect(rect);

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape? shape,
    BorderRadius? borderRadius,
  }) {
    final paint =
        Paint()
          ..color = Colors.black54
          ..style = PaintingStyle.fill;

    final cutOutRect = Rect.fromCenter(
      center: rect.center,
      width: cutOutSize,
      height: cutOutSize,
    );

    final backgroundPath = Path.combine(
      PathOperation.difference,
      Path()..addRect(rect),
      Path()..addRRect(
        RRect.fromRectXY(
          cutOutRect,
          borderRadius! as double,
          borderRadius as double,
        ),
      ),
    );

    canvas.drawPath(backgroundPath, paint);

    final borderPaint =
        Paint()
          ..color = borderColor
          ..strokeWidth = borderWidth
          ..style = PaintingStyle.stroke;

    final double halfBorder = borderWidth / 2;
    final double cornerLength = borderLength;

    canvas.drawLine(
      cutOutRect.topLeft + Offset(0, halfBorder),
      cutOutRect.topLeft + Offset(cornerLength, halfBorder),
      borderPaint,
    );
    canvas.drawLine(
      cutOutRect.topLeft + Offset(halfBorder, 0),
      cutOutRect.topLeft + Offset(halfBorder, cornerLength),
      borderPaint,
    );

    canvas.drawLine(
      cutOutRect.topRight + Offset(-cornerLength, halfBorder),
      cutOutRect.topRight + Offset(0, halfBorder),
      borderPaint,
    );
    canvas.drawLine(
      cutOutRect.topRight + Offset(-halfBorder, 0),
      cutOutRect.topRight + Offset(-halfBorder, cornerLength),
      borderPaint,
    );

    canvas.drawLine(
      cutOutRect.bottomLeft + Offset(0, -halfBorder),
      cutOutRect.bottomLeft + Offset(cornerLength, -halfBorder),
      borderPaint,
    );
    canvas.drawLine(
      cutOutRect.bottomLeft + Offset(halfBorder, -cornerLength),
      cutOutRect.bottomLeft + Offset(halfBorder, 0),
      borderPaint,
    );

    canvas.drawLine(
      cutOutRect.bottomRight + Offset(-cornerLength, -halfBorder),
      cutOutRect.bottomRight + Offset(0, -halfBorder),
      borderPaint,
    );
    canvas.drawLine(
      cutOutRect.bottomRight + Offset(-halfBorder, -cornerLength),
      cutOutRect.bottomRight + Offset(-halfBorder, 0),
      borderPaint,
    );
  }

  @override
  ShapeBorder scale(double t) => this;
}

class RawQrResultScreen extends StatelessWidget {
  final String rawValue;
  const RawQrResultScreen({super.key, required this.rawValue});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Raw QR Data")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(rawValue, style: GoogleFonts.poppins(fontSize: 14)),
      ),
    );
  }
}
