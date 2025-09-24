import 'package:authenticator/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String? title;
  final Color? backgroundColor;
  final bool? isTitle;
  final Color? titleColor;
  final Color? iconColor;
  final List<Widget>? actions; 
  const CustomAppBar({
    super.key,
    this.title,
    this.backgroundColor,
    this.titleColor,
    this.iconColor,
    this.isTitle = false,
    this.actions, 
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: isTitle == true
          ? Text(
              title!,
              style: GoogleFonts.poppins(
                color: titleColor ?? Colors.black,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
      backgroundColor: backgroundColor ?? AppPalette.whiteColor,
      iconTheme: IconThemeData(color: iconColor ?? AppPalette.blackColor),
      elevation: 0,
      scrolledUnderElevation: 0,
      actions: actions,
    );
  }
}
