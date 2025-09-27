import 'package:authenticator/features/data/datasource/auth_local_datasource.dart';
import 'package:authenticator/features/data/models/credential_model.dart';
import 'package:authenticator/features/domain/usecase/fetch_fav_credential_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FetchFavoritesUseCase useCase;
  final AuthLocalDatasource local;

  FavoriteBloc({required this.useCase, required this.local}) : super(FavoriteInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(FavoriteLoading());

    try {
      final userId = await local.get();

      if (userId == null || userId.isEmpty) {
        emit(FavoriteError('User not found'));
        return;
      }
      await emit.forEach<List<CredentialModel>>(
        useCase(userId),
        onData: (favorites) {
          if (favorites.isEmpty) {
            return FavoriteEmpty();
          } else {
            return FavoriteLoaded(favorites);
          }
        },
        onError: (error, _) => FavoriteError(error.toString()),
      );
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }
}
