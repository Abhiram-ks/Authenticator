import 'package:authenticator/features/domain/entity/password_generation_entity.dart';
import 'package:equatable/equatable.dart';

abstract class PasswordGenerationEvent extends Equatable {
  const PasswordGenerationEvent();

  @override
  List<Object?> get props => [];
}

class UpdatePasswordLength extends PasswordGenerationEvent {
  final int length;

  const UpdatePasswordLength(this.length);

  @override
  List<Object?> get props => [length];
}

class ToggleIncludeDigits extends PasswordGenerationEvent {
  const ToggleIncludeDigits();
}

class ToggleIncludeLowercase extends PasswordGenerationEvent {
  const ToggleIncludeLowercase();
}

class ToggleIncludeUppercase extends PasswordGenerationEvent {
  const ToggleIncludeUppercase();
}

class ToggleIncludeSpecialCharacters extends PasswordGenerationEvent {
  const ToggleIncludeSpecialCharacters();
}

class GeneratePassword extends PasswordGenerationEvent {
  const GeneratePassword();
}

class ResetPassword extends PasswordGenerationEvent {
  const ResetPassword();
}

class UpdatePasswordOptions extends PasswordGenerationEvent {
  final PasswordGenerationOptions options;

  const UpdatePasswordOptions(this.options);

  @override
  List<Object?> get props => [options];
}
