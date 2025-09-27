import 'package:authenticator/features/data/models/credential_model.dart';
import 'package:authenticator/features/domain/usecase/fetch_singel_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
part 'single_credential_event.dart';
part 'single_credential_state.dart';

class SingleCredentialBloc extends Bloc<SingleCredentialEvent, SingleCredentialState> {
  final FetchSingleCredentialUseCase useCase;

  SingleCredentialBloc({required this.useCase})
    : super(SingleCredentialInitial()) {
    on<SingleCredentialRequest>(_onSingleCredentialRequest);
  }

  Future<void> _onSingleCredentialRequest(
    SingleCredentialRequest event,
    Emitter<SingleCredentialState> emit,
  ) async {
    emit(SingleCredentialLoading());
    try {
      await emit.forEach<CredentialModel>(
        useCase.execute(event.docId),
        onData: (credential) => SingleCredentialLoaded(model: credential),
        onError: (error, _) => SingleCredentialError(error.toString()),
      );
    } catch (e) {
      emit(SingleCredentialError(e.toString()));
    }
  }
}
