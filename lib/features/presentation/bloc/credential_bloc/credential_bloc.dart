import 'package:authenticator/features/data/datasource/auth_local_datasource.dart';
import 'package:authenticator/features/data/models/credential_model.dart';
import 'package:authenticator/features/presentation/screen/search_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
part 'credential_event.dart';
part 'credential_state.dart';

class CredentialBloc extends Bloc<CredentialEvent, CredentialState> {
  final AuthLocalDatasource local;
  CredentialBloc({required this.local}) : super(CredentialInitial()) {
    on<SubmitCredential>(_onSubmit);
  }

  Future<void> _onSubmit(
    SubmitCredential event,
    Emitter<CredentialState> emit,
  ) async {
    emit(CredentialLoading());
    try {
      final userId = await local.get();
      if (userId != null && userId.isNotEmpty) {

        final credential = CredentialModel(
          uid: userId,
          name: event.val['Name'] ?? "",
          notes: event.val['Notes'] ?? "",
          username: event.val['Username'],
          password: event.val['Password'],
          url: event.val['URL'],
          cardHolderName: event.val['Card Holder Name'],
          cardNumber: event.val['Card Number'],
          cardType: event.val['Card Type'],
          expiryDate: event.val['Expiry Date'],
          pin: event.val['Pin'],
          postalCode: event.val['Postal Code or Zip Code'],
          firstName: event.val['First Name'],
          lastName: event.val['Last Name'],
          sex: event.val['Sex'],
          birthday: event.val['Birthday'],
          occupation: event.val['Occupation'],
          company: event.val['Company'],
          department: event.val['Department'],
          jobTitle: event.val['Job Title'],
          identityAddress: event.val['Address'],
          email: event.val['Email'],
          homePhone: event.val['Home Phone'],
          cellPhone: event.val['Cell Phone'],
          addressLine1: event.val['Address Line 1'],
          addressLine2: event.val['Address Line 2'],
          city: event.val['City'],
          country: event.val['Country'],
          state: event.val['State'],
          isAddress: event.type == ItemType.address,
          isLogin: event.type == ItemType.login,
          isCreditCard: event.type == ItemType.creditCard,
          isIdentity: event.type == ItemType.identity,
          isNotes: event.type == ItemType.notes,
        );
      } else {
        emit(CredentialFailure(message: 'User does not exist'));
        return;
      }
    } catch (e) {
      emit(CredentialFailure(message: e.toString()));
    }
  }
}
