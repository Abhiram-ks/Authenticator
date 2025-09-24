import 'package:authenticator/core/themes/app_colors.dart';
import 'package:authenticator/features/data/datasource/auth_local_datasource.dart';
import 'package:authenticator/features/data/datasource/auth_remote_datasource.dart';
import 'package:authenticator/features/data/repo/auth_repo_impl.dart';
import 'package:authenticator/features/domain/usecase/auth_usecase.dart';
import 'package:authenticator/features/presentation/bloc/googleauth_bloc/googleauth_bloc.dart';
import 'package:authenticator/features/presentation/bloc/progresser_cubit/progresser_cubit.dart';
import 'package:authenticator/features/presentation/widget/login_widget/loginbody_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProgresserCubit()),
        BlocProvider(create: (context) => GooglesignBloc(AuthUseCase(AuthRepositoryImpl(remoteDS: AuthRemoteDataSource(), localDS: AuthLocalDatasource())))),
      ],
      child: ColoredBox(
        color: AppPalette.blueColor,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              double screenWidth = constraints.maxWidth;
              double screenHeight = constraints.maxHeight;
              return Scaffold(
                backgroundColor: const Color.fromARGB(255, 245, 245, 245),
                resizeToAvoidBottomInset: false,
                body: LoginBodyWidget(
                  screenWidth: screenWidth,
                  screenHeight: screenHeight,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
