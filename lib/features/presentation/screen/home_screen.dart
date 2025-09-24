import 'package:authenticator/core/common/custom_appbar.dart';
import 'package:authenticator/core/themes/app_colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppPalette.blueColor,
      child: SafeArea(
        
        child: LayoutBuilder(
          builder:(context, constraints){
            final width = constraints.maxWidth;
            final height = constraints.maxHeight;
            return Scaffold(
              appBar: CustomAppBar(isTitle: true,title: 'True Auth',),
              body:  Center(
                child: Text(
                   'Home screen'
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}