import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authenticator/features/domain/usecase/update_credential_usecase.dart';
import 'package:authenticator/features/presentation/bloc/edit_credential_bloc/edit_credential_event.dart';
import 'package:authenticator/features/presentation/bloc/edit_credential_bloc/edit_credential_state.dart';

class EditCredentialBloc extends Bloc<EditCredentialEvent, EditCredentialState> {
  final UpdateCredentialUseCase useCase;

  EditCredentialBloc({required this.useCase}) : super(EditCredentialInitial()) {
    on<EditCredentialRequest>(_onEditCredentialRequest);
  }

  Future<void> _onEditCredentialRequest(
    EditCredentialRequest event,
    Emitter<EditCredentialState> emit,
  ) async {
    emit(EditCredentialLoading());
    
    try {
      final result = await useCase.execute(
        docId: event.docId,
        credential: event.credential,
      );
      
      if (result) {
        emit(EditCredentialSuccess(message: "Credential updated successfully"));
      } else {
        emit(EditCredentialError(message: "Failed to update credential"));
      }
    } catch (e) {
      emit(EditCredentialError(message: e.toString()));
    }
  }
}
