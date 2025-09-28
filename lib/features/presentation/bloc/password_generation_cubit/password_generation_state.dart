import 'package:authenticator/features/domain/entity/password_generation_entity.dart';
import 'package:equatable/equatable.dart';

abstract class PasswordGenerationState extends Equatable {
  final PasswordGenerationOptions options;
  final String? generatedPassword;
  final double passwordStrength;
  final String strengthDescription;

  const PasswordGenerationState({
    required this.options,
    this.generatedPassword,
    required this.passwordStrength,
    required this.strengthDescription,
  });

  @override
  List<Object?> get props => [
        options,
        generatedPassword,
        passwordStrength,
        strengthDescription,
      ];
}

class PasswordGenerationInitial extends PasswordGenerationState {
  const PasswordGenerationInitial({
    required super.options,
    super.generatedPassword,
    required super.passwordStrength,
    required super.strengthDescription,
  });
}

class PasswordGenerationUpdated extends PasswordGenerationState {
  const PasswordGenerationUpdated({
    required super.options,
    super.generatedPassword,
    required super.passwordStrength,
    required super.strengthDescription,
  });
}

class PasswordGenerated extends PasswordGenerationState {
  const PasswordGenerated({
    required super.options,
    required super.generatedPassword,
    required super.passwordStrength,
    required super.strengthDescription,
  });
}

class PasswordGenerationError extends PasswordGenerationState {
  final String error;

  const PasswordGenerationError({
    required super.options,
    super.generatedPassword,
    required super.passwordStrength,
    required super.strengthDescription,
    required this.error,
  });

  @override
  List<Object?> get props => [...super.props, error];
}
