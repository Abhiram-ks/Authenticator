import 'package:authenticator/core/common/custom_appbar.dart';
import 'package:authenticator/core/themes/app_colors.dart';
import 'package:authenticator/features/presentation/bloc/progresser_cubit/progresser_cubit.dart';
import 'package:authenticator/features/presentation/screen/password_generation_screen.dart';
import 'package:authenticator/features/presentation/widget/home_scaner_widget/home_body_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';




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
                     IconButton(
                        onPressed: () {
                          showHelpDialogAuthenticator(context);
                        },
                        icon: Icon(Icons.help_outline,color: AppPalette.greyColor,),
                      ),
                  ],
                ),
                body: HomeBody(width: width, height: height),
              );
            },
          ),
        ),
      ),
    );
  }
}
