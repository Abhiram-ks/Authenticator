import 'package:authenticator/features/data/datasource/auth_local_datasource.dart';
import 'package:authenticator/features/domain/usecase/settings_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

part 'deleteaccount_event.dart';
part 'deleteaccount_state.dart';

class DeleteaccountBloc extends Bloc<DeleteaccountEvent, DeleteaccountState> {
  final AuthLocalDatasource local;
  final StreamBackupUseCase useCase;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  DeleteaccountBloc({required this.local, required this.useCase}) : super(DeleteaccountInitial()) {
    on<DeleteRequest>(_onDeleteRequest);
    on<DeleteConfirm>(_onDeleteConfirm);
  }

  Future<void> _onDeleteRequest(
    DeleteRequest event,
    Emitter<DeleteaccountState> emit,
  ) async {
    try {
      final userId = await local.get();

      if (userId == null || userId.isEmpty) {
        emit(DeleteAccountFailure(message: "User not found"));
        return;
      }

      final snapshot = await useCase.repo.streamBackup(userId).first;

      if (snapshot == true) {
        emit(DeleteAccountConfirmationAlert());
      } else {
        emit(DeleteAccountWithoutSincAlert());
      }
    } catch (e) {
      emit(DeleteAccountFailure(message: e.toString()));
    }
  }


    Future<void> _onDeleteConfirm(
    DeleteConfirm event,
    Emitter<DeleteaccountState> emit,
  ) async {
    try {
        final bool cleared = await local.clear();
        if (cleared) {
          await _auth.signOut(); 
          await  _googleSignIn.signOut();
          emit(DeleteAccountSuccess());
        } else {
          emit(DeleteAccountFailure(message: "Unable to delete. Try again later."));
        }
    } catch (e) {
      emit(DeleteAccountFailure(message: e.toString()));
    }
  }
}
