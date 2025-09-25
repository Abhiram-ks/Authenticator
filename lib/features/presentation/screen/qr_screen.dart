
import 'package:authenticator/core/themes/app_colors.dart';
import 'package:authenticator/features/presentation/widget/home_scaner_widget/scaner_overshape_widget.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';


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
      backgroundColor: AppPalette.blackColor,
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
