import 'package:authenticator/features/domain/entity/password_generation_entity.dart';
import 'package:authenticator/features/domain/usecase/password_generation_usecase.dart';
import 'package:authenticator/features/presentation/bloc/password_generation_cubit/password_generation_event.dart';
import 'package:authenticator/features/presentation/bloc/password_generation_cubit/password_generation_state.dart';
import 'package:bloc/bloc.dart';

class PasswordGenerationCubit extends Bloc<PasswordGenerationEvent, PasswordGenerationState> {
  final PasswordGenerationUseCase _useCase;

  PasswordGenerationCubit({required PasswordGenerationUseCase useCase})
      : _useCase = useCase,
        super(const PasswordGenerationInitial(
          options: PasswordGenerationOptions(),
          passwordStrength: 0,
          strengthDescription: 'Weak',
        )) {
    
    on<UpdatePasswordLength>(_onUpdatePasswordLength);
    on<ToggleIncludeDigits>(_onToggleIncludeDigits);
    on<ToggleIncludeLowercase>(_onToggleIncludeLowercase);
    on<ToggleIncludeUppercase>(_onToggleIncludeUppercase);
    on<ToggleIncludeSpecialCharacters>(_onToggleIncludeSpecialCharacters);
    on<GeneratePassword>(_onGeneratePassword);
    on<ResetPassword>(_onResetPassword);
    on<UpdatePasswordOptions>(_onUpdatePasswordOptions);
  }

  void _onUpdatePasswordLength(
    UpdatePasswordLength event,
    Emitter<PasswordGenerationState> emit,
  ) {
    final newOptions = state.options.copyWith(length: event.length);
    _emitUpdatedState(newOptions, emit);
  }

  void _onToggleIncludeDigits(
    ToggleIncludeDigits event,
    Emitter<PasswordGenerationState> emit,
  ) {
    final newOptions = state.options.copyWith(
      includeDigits: !state.options.includeDigits,
    );
    _emitUpdatedState(newOptions, emit);
  }

  void _onToggleIncludeLowercase(
    ToggleIncludeLowercase event,
    Emitter<PasswordGenerationState> emit,
  ) {
    final newOptions = state.options.copyWith(
      includeLowercase: !state.options.includeLowercase,
    );
    _emitUpdatedState(newOptions, emit);
  }

  void _onToggleIncludeUppercase(
    ToggleIncludeUppercase event,
    Emitter<PasswordGenerationState> emit,
  ) {
    final newOptions = state.options.copyWith(
      includeUppercase: !state.options.includeUppercase,
    );
    _emitUpdatedState(newOptions, emit);
  }

  void _onToggleIncludeSpecialCharacters(
    ToggleIncludeSpecialCharacters event,
    Emitter<PasswordGenerationState> emit,
  ) {
    final newOptions = state.options.copyWith(
      includeSpecialCharacters: !state.options.includeSpecialCharacters,
    );
    _emitUpdatedState(newOptions, emit);
  }

  void _onGeneratePassword(
    GeneratePassword event,
    Emitter<PasswordGenerationState> emit,
  ) {
    try {
      final generatedPassword = _useCase.generatePassword(state.options);
      final strength = _useCase.calculatePasswordStrength(state.options);
      final strengthDescription = _useCase.getStrengthDescription(strength);
      
      emit(PasswordGenerated(
        options: state.options,
        generatedPassword: generatedPassword,
        passwordStrength: strength,
        strengthDescription: strengthDescription,
      ));
    } catch (e) {
      emit(PasswordGenerationError(
        options: state.options,
        passwordStrength: state.passwordStrength,
        strengthDescription: state.strengthDescription,
        error: e.toString(),
      ));
    }
  }

  void _onResetPassword(
    ResetPassword event,
    Emitter<PasswordGenerationState> emit,
  ) {
    final newOptions = const PasswordGenerationOptions();
    _emitUpdatedState(newOptions, emit);
  }

  void _onUpdatePasswordOptions(
    UpdatePasswordOptions event,
    Emitter<PasswordGenerationState> emit,
  ) {
    _emitUpdatedState(event.options, emit);
  }

  void _emitUpdatedState(
    PasswordGenerationOptions options,
    Emitter<PasswordGenerationState> emit,
  ) {
    final strength = _useCase.calculatePasswordStrength(options);
    final strengthDescription = _useCase.getStrengthDescription(strength);
    
    emit(PasswordGenerationUpdated(
      options: options,
      generatedPassword: state.generatedPassword,
      passwordStrength: strength,
      strengthDescription: strengthDescription,
    ));
  }
}
