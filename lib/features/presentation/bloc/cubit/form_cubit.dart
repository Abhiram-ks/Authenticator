import 'package:flutter_bloc/flutter_bloc.dart';
import '../../screen/search_screen.dart'; 
class CustomFormState {
  final Map<String, String> values;
  final bool canSave;

  const CustomFormState({
    required this.values,
    required this.canSave,
  });

  CustomFormState copyWith({
    Map<String, String>? values,
    bool? canSave,
  }) {
    return CustomFormState(
      values: values ?? this.values,
      canSave: canSave ?? this.canSave,
    );
  }
}

class FormCubit extends Cubit<CustomFormState> {
  FormCubit(ItemType type)
      : super(CustomFormState(
          values: {for (var f in type.requiredFields) f: ""},
          canSave: false,
        ));

  void updateField(String field, String value) {
    final updated = Map<String, String>.from(state.values);
    updated[field] = value;

    final allFilled = updated.values.every((v) => v.trim().isNotEmpty);

    emit(state.copyWith(values: updated, canSave: allFilled));
  }
}
