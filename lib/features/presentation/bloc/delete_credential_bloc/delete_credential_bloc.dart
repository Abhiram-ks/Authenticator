import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authenticator/features/domain/usecase/delete_credential_usecase.dart';
import 'package:authenticator/features/presentation/bloc/delete_credential_bloc/delete_credential_event.dart';
import 'package:authenticator/features/presentation/bloc/delete_credential_bloc/delete_credential_state.dart';

class DeleteCredentialBloc extends Bloc<DeleteCredentialEvent, DeleteCredentialState> {
  final DeleteCredentialUseCase useCase;

  DeleteCredentialBloc({required this.useCase}) : super(DeleteCredentialInitial()) {
    on<DeleteCredentialRequest>(_onDeleteCredentialRequest);
  }

  Future<void> _onDeleteCredentialRequest(
    DeleteCredentialRequest event,
    Emitter<DeleteCredentialState> emit,
  ) async {
    emit(DeleteCredentialLoading());
    
    try {
      final result = await useCase.execute(docId: event.docId);
      
      if (result) {
        emit(DeleteCredentialSuccess(message: "Credential deleted successfully"));
      } else {
        emit(DeleteCredentialError(message: "Failed to delete credential"));
      }
    } catch (e) {
      emit(DeleteCredentialError(message: e.toString()));
    }
  }
}
