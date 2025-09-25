
import 'package:authenticator/core/themes/app_colors.dart';
import 'package:flutter/material.dart';



class QrScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  const QrScannerOverlayShape({
    this.borderColor = AppPalette.whiteColor,
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
