import 'package:authenticator/features/data/datasource/auth_local_datasource.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final AuthLocalDatasource local;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  LogoutBloc({required this.local}) : super(LogoutInitial()) {
    on<Logoutrequest>((event, emit) {
      emit(LogoutAlertBox());
    });

   on<LogoutConfirmation>((event, emit) async {
      try {
        final bool cleared = await local.clear();
        if (cleared) {
          await _auth.signOut(); 
          await  _googleSignIn.signOut();
          emit(LogoutSuccess());
        } else {
          emit(LogoutFailure(message: "Unable to log out. Try again later."));
        }
      } catch (e) {
        emit(LogoutFailure(message: "Logout failed: ${e.toString()}"));
      }
    });
  }
}
