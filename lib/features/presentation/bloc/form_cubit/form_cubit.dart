import 'package:flutter_bloc/flutter_bloc.dart';
import '../../screen/search_screen.dart'; 
import '../../../data/models/credential_model.dart';


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

  void initializeWithCredential(CredentialModel credential) {
    final Map<String, String> initialValues = {};
    
    // Map credential fields to form fields
    initialValues['Name'] = credential.name;
    initialValues['Username'] = credential.username ?? '';
    initialValues['Password'] = credential.password ?? '';
    initialValues['URL'] = credential.url ?? '';
    initialValues['Notes'] = credential.notes;
    initialValues['Card Holder Name'] = credential.cardHolderName ?? '';
    initialValues['Card Number'] = credential.cardNumber ?? '';
    initialValues['Card Type'] = credential.cardType ?? '';
    initialValues['Expiry Date'] = credential.expiryDate ?? '';
    initialValues['Pin'] = credential.pin ?? '';
    initialValues['Postal Code or Zip Code'] = credential.postalCode ?? '';
    initialValues['First Name'] = credential.firstName ?? '';
    initialValues['Last Name'] = credential.lastName ?? '';
    initialValues['Sex'] = credential.sex ?? '';
    initialValues['Birthday'] = credential.birthday ?? '';
    initialValues['Occupation'] = credential.occupation ?? '';
    initialValues['Company'] = credential.company ?? '';
    initialValues['Department'] = credential.department ?? '';
    initialValues['Job Titile'] = credential.jobTitle ?? '';
    initialValues['Address'] = credential.identityAddress ?? '';
    initialValues['Email'] = credential.email ?? '';
    initialValues['Home Phone'] = credential.homePhone ?? '';
    initialValues['Cell Phone'] = credential.cellPhone ?? '';
    initialValues['Address Line 1'] = credential.addressLine1 ?? '';
    initialValues['Address Line 2'] = credential.addressLine2 ?? '';
    initialValues['City'] = credential.city ?? '';
    initialValues['Country'] = credential.country ?? '';
    initialValues['State'] = credential.state ?? '';

    // Filter to only include fields that are required for this item type
    final requiredFields = state.values.keys.toSet();
    final filteredValues = Map<String, String>.fromEntries(
      initialValues.entries.where((entry) => requiredFields.contains(entry.key))
    );

    final allFilled = filteredValues.values.every((v) => v.trim().isNotEmpty);

    emit(state.copyWith(values: filteredValues, canSave: allFilled));
  }
}
