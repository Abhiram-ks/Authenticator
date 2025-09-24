import 'package:bloc/bloc.dart';


enum NavItem {home, search, cloud, settings}

class ButtomNavCubit extends Cubit<NavItem> {
  ButtomNavCubit() : super(NavItem.home);
  
  void selectItem (NavItem item) {
    emit(item);
  }
}
