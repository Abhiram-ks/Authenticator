import 'package:authenticator/core/constant/constant.dart';
import 'package:authenticator/features/presentation/bloc/googleauth_bloc/googleauth_bloc.dart';
import 'package:authenticator/features/presentation/widget/login_widget/login_custom_googlefiled.dart';
import 'package:authenticator/features/presentation/widget/login_widget/login_state_handle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCredentialPart extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  const LoginCredentialPart({
    super.key,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("Or"),
            ),
            Expanded(child: Divider()),
          ],
        ),

        ConstantWidgets.hight20(context),

        BlocListener<GooglesignBloc, GooglesignState>(
          listener: (context, googleState) {
            loginStatehandle(context, googleState);
          },
          child: CustomGoogleField.googleSignInModule(
            context: context,
            screenHeight: screenHeight,
            screenWidth: screenWidth,
            onTap: () {
              context.read<GooglesignBloc>().add(GoogleSignUP());
            },
          ),
        ),

        ConstantWidgets.hight20(context),

        Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text:
                  "By creating or logging into an account you are agreeing with our ",
              style: const TextStyle(fontSize: 12, color: Colors.black54),

              children: [
                TextSpan(
                  text: "Terms and Conditions",
                  style: TextStyle(color: Colors.blue[700]),
                ),
                const TextSpan(text: " and "),
                TextSpan(
                  text: "Privacy Policy",
                  style: TextStyle(color: Colors.blue[700]),
                ),
              ],
            ),
          ),
        ),
        ConstantWidgets.hight20(context),
      ],
    );
  }
}
