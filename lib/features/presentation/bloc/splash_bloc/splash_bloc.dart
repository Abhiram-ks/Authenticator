import 'package:authenticator/features/data/datasource/auth_local_datasource.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthLocalDatasource local;

  SplashBloc({required this.local}) : super(SplashInitial()) {
    on<SplashEvent>((event, emit) async {
      await Future.delayed(const Duration(seconds: 3));

      final userId = await local.get();
      if (userId != null && userId.isNotEmpty) {
        emit(GotologinHomeScreen());
      } else {
        emit(GotologinScreen());
      }
    });
  }
}
