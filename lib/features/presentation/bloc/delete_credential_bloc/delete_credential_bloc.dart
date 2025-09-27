import 'package:authenticator/features/domain/usecase/likefev_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:authenticator/features/domain/usecase/delete_credential_usecase.dart';
import 'package:authenticator/features/presentation/bloc/delete_credential_bloc/delete_credential_event.dart';
import 'package:authenticator/features/presentation/bloc/delete_credential_bloc/delete_credential_state.dart';

class DeleteCredentialBloc extends Bloc<DeleteCredentialEvent, DeleteCredentialState> {
  final DeleteCredentialUseCase useCase;
  final GetFavoritesUseCase getFavoritesUseCase;

  DeleteCredentialBloc({required this.useCase, required this.getFavoritesUseCase}) : super(DeleteCredentialInitial()) {
    on<DeleteCredentialRequest>(_onDeleteCredentialRequest);
    on<DeleteCredentialRequestConfirm>(_onDeleteConfirmationRequest);
  }

Future<void> _onDeleteCredentialRequest(
    DeleteCredentialRequest event,
    Emitter<DeleteCredentialState> emit,
  ) async {
    emit(DeleteCredentialLoading());

    try {
      final isLiked = await getFavoritesUseCase.isFavorite(event.uid, event.docId);

      if (isLiked) {
        emit(DeleteCredentialWithFavConfirmationAlert());
        return;
      }else {
         emit(DeleteCredentialConfirmationAlert());
      }
    } catch (e) {
      emit(DeleteCredentialConfirmationAlert());
    }
  }


  Future<void> _onDeleteConfirmationRequest(
    DeleteCredentialRequestConfirm event,
    Emitter<DeleteCredentialState> emit,
  ) async {
    emit(DeleteCredentialLoading());

    try {
      final isDelete = await useCase.execute(docId: event.docId);

      if (isDelete) {
        emit(DeleteCredentialSuccess());
        return;
      }else {
         emit(DeleteCredentialError(message: 'The requested document was not found.'));
      }
    } catch (e) {
      emit(DeleteCredentialError(message: e.toString()));
    }
  }
}
