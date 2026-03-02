import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

part 'home_state.dart';

@lazySingleton
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState(currentIndex: 0));

  void setTabIndex(int index) {
    if (index == state.currentIndex) return;
    if (index < 0 || index > 3) return;
    emit(HomeState(currentIndex: index));
  }

}
