part of 'icon_cubit.dart';

@immutable
abstract class IconState{}

final class IconInitial extends IconState {}

class PasswordVisibilityUpdated extends IconState {
  final bool isVisible;

  PasswordVisibilityUpdated({required this.isVisible});
}