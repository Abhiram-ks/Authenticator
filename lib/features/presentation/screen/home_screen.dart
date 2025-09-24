import 'dart:developer';

import 'package:authenticator/core/common/custom_appbar.dart';
import 'package:authenticator/core/common/custom_button.dart';
import 'package:authenticator/core/constant/app_images.dart';
import 'package:authenticator/core/constant/constant.dart';
import 'package:authenticator/core/themes/app_colors.dart';
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
      final unixTime = (forTimeSeconds != null)
          ? forTimeSeconds
          : DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
      final counter = unixTime ~/ period;

      final counterBytes = _int64ToBytes(counter);
      final hmac = Hmac(sha1, key);
      final digest = hmac.convert(counterBytes).bytes;

      final offset = digest[digest.length - 1] & 0x0f;
      final binary = ((digest[offset] & 0x7f) << 24) |
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
      _showResult('Please enter the 6-digit code', Colors.orange);
      return;
    }
    if (entered == _code) {
      _showResult('✅ Code verified — correct', Colors.green);
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
        _showResult('✅ Code accepted (clock drift) — correct', Colors.green);
      } else {
        _showResult('❌ Incorrect code', Colors.red);
      }
    }
  }

  void _showResult(String text, Color color) {
    setState(() {
      _verifyMessage = text;
      _verifyColor = color;
    });
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
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

    return Scaffold(
      appBar: AppBar(title: const Text("QR Account Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Account info
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Issuer: ${widget.account.issuer}", style: GoogleFonts.poppins(fontSize: 16)),
                  const SizedBox(height: 6),
                  Text("Label: ${widget.account.label}", style: GoogleFonts.poppins(fontSize: 16)),
                  const SizedBox(height: 6),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Big code display
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
                child: Column(
                  children: [
                    Text(
                      _code,
                      style: GoogleFonts.robotoMono(fontSize: 48, letterSpacing: 8, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Expires in $_remaining s", style: GoogleFonts.poppins(fontSize: 12)),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 80,
                          child: LinearProgressIndicator(
                            value: progress,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Manual verify input
            TextField(
              controller: _ctrl,
              keyboardType: TextInputType.number,
              maxLength: widget.account.digits,
              decoration: InputDecoration(
                labelText: 'Enter code to verify',
                counterText: '',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _verify,
                child: Text('Verify', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              ),
            ),

            if (_verifyMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                _verifyMessage!,
                style: GoogleFonts.poppins(color: _verifyColor),
              ),
            ],

            const SizedBox(height: 14),
            // Raw secret + meta for developer debugging (optional)
            Text("Secret: ${widget.account.secret}", style: GoogleFonts.poppins(fontSize: 12)),
            Text("Digits: ${widget.account.digits}, Period: ${widget.account.period}s", style: GoogleFonts.poppins(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// -----------------------------
// Parse otpauth:// URI
// -----------------------------
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

// -----------------------------
// Home Screen
// -----------------------------
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
                appBar: CustomAppBar(isTitle: true, title: 'True Auth'),
                body: SingleChildScrollView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                          text: "Scan Now",
                          onPressed: () async {
                            final result = await Navigator.of(context).push<String?>(
                              MaterialPageRoute(builder: (_) => const QrScannerScreen()),
                            );

                            if (result != null && result.isNotEmpty) {
                              final parsed = parseOtpAuthUri(result);
                              if (parsed != null) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => QrResultScreen(account: parsed),
                                  ),
                                );
                              } else {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => RawQrResultScreen(rawValue: result),
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
                            
                              child: CustomButton(text: 'Enable Backup', onPressed: (){}, bgColor: AppPalette.whiteColor,borderColor: AppPalette.blueColor,textColor: AppPalette.blueColor,)
                             
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child:  CustomButton(text: 'Import Account', onPressed: (){}, bgColor: AppPalette.whiteColor,borderColor: AppPalette.blueColor,textColor: AppPalette.blueColor,)
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

// -----------------------------
// QR Scanner Screen
// -----------------------------
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
     log('$barcodes');
    if (barcodes.isEmpty) return;
    final raw = barcodes.first.rawValue ?? '';
    if (raw.isEmpty) return;

    _isDetecting = true;
    Navigator.of(context).pop(raw);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR")),
      body: MobileScanner(
        controller: _controller,
        onDetect: _onDetect,
      ),
    );
  }
}

// -----------------------------
// Result Screens
// -----------------------------


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
