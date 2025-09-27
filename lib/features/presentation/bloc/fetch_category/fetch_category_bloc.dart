import 'package:authenticator/features/data/datasource/auth_local_datasource.dart';
import 'package:authenticator/features/domain/entity/credential_entity.dart';
import 'package:authenticator/features/domain/usecase/fetch_category_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
part 'fetch_category_event.dart';
part 'fetch_category_state.dart';

class FetchCategoryBloc extends Bloc<FetchCategoryEvent, FetchCategoryState> {
    final AuthLocalDatasource local;
    final FetchCategoryUsecase usecase;
  FetchCategoryBloc({required this.local, required this.usecase}) : super(FetchCategoryInitial()) {
    on<FetchCategoryFilter>(_getCategorys);
  }
  
  Future<void> _getCategorys(
    FetchCategoryFilter event,
    Emitter<FetchCategoryState> emit,
  ) async {
    emit(FetchCategoryLoading());

    try {
      final userId = await local.get();

      if (userId == null || userId.isEmpty) {
        emit(FetchCategoryError(errorMessage:'User not found'));
        return;
      }

      await emit.forEach<List<CredentialEntity>>(
        usecase.execute(uid: userId, category:event.category),
        onData: (credentials) {
          if (credentials.isEmpty) {
            return FetchCategoryEmpty();
          } else {
            return FetchCategorySuccess(credentials:credentials);
          }
        },
        onError: (error, _) => FetchCategoryError(errorMessage: error.toString()),
      );
    } catch (e) {
      emit(FetchCategoryError(errorMessage: e.toString()));
    }
  }

}
