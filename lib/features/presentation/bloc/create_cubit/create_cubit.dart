import 'package:authenticator/features/presentation/screen/search_screen.dart';
import 'package:bloc/bloc.dart';

class CreateCubit extends Cubit<ItemType?> {
  CreateCubit() : super(null);

  void setItem(ItemType type) {
    emit(type);
  }
}
