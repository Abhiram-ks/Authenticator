import 'package:authenticator/core/common/custom_appbar.dart';
import 'package:authenticator/core/common/custom_luncher_function.dart';
import 'package:authenticator/core/constant/constant.dart';
import 'package:authenticator/core/routes/app_routes.dart';
import 'package:authenticator/core/themes/app_colors.dart';
import 'package:authenticator/features/data/datasource/auth_local_datasource.dart';
import 'package:authenticator/features/data/datasource/settings_remote_datasource.dart';
import 'package:authenticator/features/data/repo/settings_repo_impl.dart';
import 'package:authenticator/features/domain/usecase/settings_usecase.dart';
import 'package:authenticator/features/presentation/bloc/backup_cubit/backup_cubit.dart';
import 'package:authenticator/features/presentation/bloc/delete_account_bloc/deleteaccount_bloc.dart';
import 'package:authenticator/features/presentation/bloc/logout_bloc/logout_bloc.dart';
import 'package:authenticator/features/presentation/screen/password_generation_screen.dart';
import 'package:authenticator/features/presentation/widget/settings_widget/settings_delete_state_handle.dart';
import 'package:authenticator/features/presentation/widget/settings_widget/settings_logout_state_handle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (context) => BackupCubit(
                local: AuthLocalDatasource(),
                streamBackupUseCase: StreamBackupUseCase(
                  SettingsRepositoryImpl(remote: SettingsRemoteDatasource()),
                ),
              ),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(local: AuthLocalDatasource()),
        ),
        BlocProvider(
          create:
              (context) => DeleteaccountBloc(
                local: AuthLocalDatasource(),
                useCase: StreamBackupUseCase(
                  SettingsRepositoryImpl(remote: SettingsRemoteDatasource()),
                ),
              ),
        ),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          return ColoredBox(
            color: AppPalette.blueColor,
            child: SafeArea(
              child: Scaffold(
                appBar: CustomAppBar(
                  title: 'Settings',
                  isTitle: true,
                  actions: [
                    IconButton(
                      icon: const Icon(
                        Icons.help_outline,
                        color: AppPalette.greyColor,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                body: SettingsBody(width: width),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SettingsBody extends StatefulWidget {
  final double width;

  const SettingsBody({super.key, required this.width});

  @override
  State<SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<SettingsBody> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.width * 0.05),

      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: AppPalette.whiteColor,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(
                      CupertinoIcons.lock,
                      color: AppPalette.orengeColor,
                    ),
                    title: const Text("Generate Password"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.passwordGeneration,
                      );
                    },
                  ),
                  const Divider(height: 1, color: AppPalette.hintColor),
                  BlocBuilder<BackupCubit, bool>(
                    builder: (context, isEnabled) {
                      return ListTile(
                        leading: const Icon(
                          CupertinoIcons.cloud_upload,
                          color: AppPalette.blueColor,
                        ),
                        title: const Text("Sync & Backup"),
                        trailing: Transform.scale(
                          scale: 0.8,
                          child: CupertinoSwitch(
                            value: isEnabled,
                            activeTrackColor: AppPalette.blueColor,
                            thumbColor: AppPalette.whiteColor,
                            onChanged: (value) {
                              context.read<BackupCubit>().toggleBackup(value);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            ConstantWidgets.hight10(context),
            Card(
              color: AppPalette.whiteColor,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                      CupertinoIcons.qrcode,
                      color: AppPalette.greyColor,
                    ),
                    title: const Text("How to Import True Auth Authenticator"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      showHelpDialogAuthenticator(context);
                    },
                  ),
                  const Divider(height: 1, color: AppPalette.hintColor),
                  ListTile(
                    leading: const Icon(
                      CupertinoIcons.shield,
                      color: AppPalette.redColor,
                    ),
                    title: const Text("Privacy Policy"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      openWebPage(
                        context: context,
                        url:
                            'https://www.termsfeed.com/live/31ef7f49-ecef-4a44-9945-33f0edf2874a',
                        errorMessage:
                            'Privacy Policy cannot be opened at the moment due to an error.',
                      );
                    },
                  ),
                  const Divider(height: 1, color: AppPalette.hintColor),
                  ListTile(
                      leading: const Icon(
                      CupertinoIcons.doc_text,
                      color: Color.fromARGB(255, 3, 200, 244),
                    ),
                    title: const Text("Terms and Conditions"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      openWebPage(
                        context: context,
                        url:
                            'https://www.freeprivacypolicy.com/live/7907c4ca-15fd-41f5-a01d-f77d7b9d88fb',
                        errorMessage:
                            'Terms and Conditions cannot be opened at the moment due to an error.',
                      );
                    },
                  ),
                ],
              ),
            ),
            ConstantWidgets.hight10(context),
            Card(
              color: AppPalette.whiteColor,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  BlocListener<DeleteaccountBloc, DeleteaccountState>(
                    listener: (context, deleteAccountState) {
                      deleteStateHandle(context, deleteAccountState);
                    },
                    child: ListTile(
                      leading: Icon(
                        CupertinoIcons.delete_solid,
                        color: AppPalette.redColor,
                      ),
                      title: const Text(
                        "Delete Account",
                        style: TextStyle(color: AppPalette.redColor),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        context.read<DeleteaccountBloc>().add(DeleteRequest());
                      },
                    ),
                  ),
                  const Divider(height: 1, color: AppPalette.hintColor),
                  BlocListener<LogoutBloc, LogoutState>(
                    listener: (context, logoutState) {
                      logoutStateHandle(context, logoutState);
                    },
                    child: ListTile(
                      leading: const Icon(
                        CupertinoIcons.square_arrow_right,
                        color: AppPalette.redColor,
                      ),
                      title: const Text("Log out"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {
                        context.read<LogoutBloc>().add(Logoutrequest());
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
