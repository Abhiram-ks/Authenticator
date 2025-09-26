import 'package:authenticator/core/themes/app_colors.dart';
import 'package:authenticator/features/data/datasource/auth_local_datasource.dart';
import 'package:authenticator/features/data/datasource/credential_remote_datasource.dart';
import 'package:authenticator/features/data/repo/credential_repo_impl.dart';
import 'package:authenticator/features/domain/usecase/fetch_credential_usecase.dart';
import 'package:authenticator/features/presentation/bloc/fetch_credential_bloc/fetch_credentail_bloc.dart';
import 'package:authenticator/features/presentation/bloc/navigation_cubit/navigation_cubit.dart';
import 'package:authenticator/features/presentation/screen/cloud_screen.dart';
import 'package:authenticator/features/presentation/screen/home_screen.dart';
import 'package:authenticator/features/presentation/screen/search_screen.dart';
import 'package:authenticator/features/presentation/screen/settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const double bottomNavBarHeight = 70.0;

class BottomNavigationControllers extends StatelessWidget {
  final List<Widget> _screens = [
    HomeScreen(),
    SearchScreen(),
    CloudScreen(),
    SettingsScreen(),
  ];

  BottomNavigationControllers({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ButtomNavCubit()),
        BlocProvider(create: (context) => FetchCredentailBloc(local:AuthLocalDatasource() , usecase: FetchCredentialsUseCase(CredentialRemoteDataSourceImpl(remote: CredentialRemoteDataSource())))),
      ],
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: AppPalette.whiteColor.withAlpha((0.3 * 225).round()),
          highlightColor: AppPalette.blueColor.withAlpha((0.2 * 255).round()),
        ),
        child: Scaffold(
          body: BlocBuilder<ButtomNavCubit, NavItem>(
            builder: (context, state) {
              switch (state) {
                case NavItem.home:
                  return _screens[0];
                case NavItem.search:
                  return _screens[1];
                case NavItem.cloud:
                  return _screens[2];
                case NavItem.settings:
                  return _screens[3];
              }
            },
          ),
          bottomNavigationBar: BlocBuilder<ButtomNavCubit, NavItem>(
            builder: (context, state) {
              return SizedBox(
                height: bottomNavBarHeight,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppPalette.whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: AppPalette.blackColor.withValues(alpha: 0.1),
                        blurRadius: 6,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: BottomNavigationBar(
                    enableFeedback: true,
                    useLegacyColorScheme: true,
                    elevation: 0,
                    iconSize: 26,
                    selectedItemColor: AppPalette.blueColor,
                    backgroundColor: Colors.transparent,
                    landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
                    unselectedLabelStyle: TextStyle(
                      color: AppPalette.hintColor,
                    ),
                    showSelectedLabels: true,
                    showUnselectedLabels: true,
                    type: BottomNavigationBarType.fixed,
                    currentIndex: NavItem.values.indexOf(state),
                    onTap: (index) {
                      context.read<ButtomNavCubit>().selectItem(
                        NavItem.values[index],
                      );
                    },
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home_outlined, size: 16),
                        label: 'Home',
                        activeIcon: Icon(
                          Icons.home,
                          color: AppPalette.blueColor,
                        ),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(CupertinoIcons.lock, size: 16),
                        label: 'Password',
                        activeIcon: Icon(
                          CupertinoIcons.lock_fill,
                          color: AppPalette.blueColor,
                        ),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.cloud_queue, size: 16),
                        label: 'Cloud',
                        activeIcon: Icon(
                          Icons.cloud,
                          color: AppPalette.blueColor,
                        ),
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.settings, size: 16),
                        label: 'Setting',
                        activeIcon: Icon(
                          Icons.settings,
                          color: AppPalette.blueColor,
                        ),
                      ),
                    ],
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
