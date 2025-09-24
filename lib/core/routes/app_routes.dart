
import 'package:authenticator/core/constant/constant.dart';
import 'package:authenticator/features/presentation/screen/login_screen.dart';
import 'package:authenticator/features/presentation/screen/navigation.dart';
import 'package:authenticator/features/presentation/screen/splash_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login  = '/login_screen';
  static const String nav   = '/navigation';
  static const String pdiform = '/PdiformScreen';
  static const String createuser = '/createuser_screen';


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
      return MaterialPageRoute(builder: (_) => SplashScreen());
      case login:
      return MaterialPageRoute(builder: (_) => LoginScreen());
      case nav:
      return MaterialPageRoute(builder: (_) => BottomNavigationControllers());
      default:
        return MaterialPageRoute(
          builder:
              (_) => LayoutBuilder(
                builder: (context, constraints) {
                  double screenWidth = constraints.maxWidth;

                  return Scaffold(
                    body: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * .04,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Page Not Found',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                           ConstantWidgets.hight20(context),
                            Text(
                              'The page you were looking for could not be found. '
                              'It might have been removed, renamed, or does not exist.',
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: TextStyle(fontSize: 16, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
        );
    }
  }
}
