
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
