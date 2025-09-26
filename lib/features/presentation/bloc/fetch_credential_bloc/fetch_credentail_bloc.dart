import 'package:authenticator/features/data/datasource/auth_local_datasource.dart';
import 'package:authenticator/features/domain/entity/credential_entity.dart';
import 'package:authenticator/features/domain/usecase/fetch_credential_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'fetch_credentail_event.dart';
part 'fetch_credentail_state.dart';

class FetchCredentailBloc
    extends Bloc<FetchCredentailEvent, FetchCredentailState> {
  final FetchCredentialsUseCase usecase;
  final AuthLocalDatasource local;
  FetchCredentailBloc({required this.usecase, required this.local})
    : super(FetchCredentailInitial()) {
    on<FetchCredentialsEvent>((event, emit) async {
      emit(FetchCredentailLoading());
      try {
        final userId = await local.get();

        if (userId == null || userId.isEmpty) {
          emit(FetchCredentailError('User not found'));
          return;
        }

        await emit.forEach(
          usecase.execute(uid: userId),
          onData: (credentials) {
            if (credentials.isEmpty) {
              return FetchCredentailEmpty();
            } else {
              return FetchCredentailLoad(credentials);
            }
          },
          onError: (e, _) => FetchCredentailError(e.toString()),
        );
      } catch (e) {
        emit(FetchCredentailError(e.toString()));
      }
    });
  }
}
