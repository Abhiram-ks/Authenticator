part of 'splash_bloc.dart';

@immutable
abstract class SplashState {}

final class SplashInitial extends SplashState {}
final class GotologinScreen extends SplashState {}
final class GotologinHomeScreen extends SplashState {}