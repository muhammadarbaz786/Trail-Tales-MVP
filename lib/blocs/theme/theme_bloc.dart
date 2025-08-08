import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_event.dart';
import 'theme_state.dart';
import '../../utils/app_theme.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  bool _isDark = false;

  ThemeBloc() : super(ThemeState(themeData: AppTheme.lightTheme)) {
    on<ToggleTheme>((event, emit) {
      _isDark = !_isDark;
      emit(ThemeState(
        themeData: _isDark ? AppTheme.darkTheme : AppTheme.lightTheme,
      ));
    });
  }
}
