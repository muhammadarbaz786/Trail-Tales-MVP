import 'package:flutter_bloc/flutter_bloc.dart';

// Event
abstract class AppEvent {}

class AppStarted extends AppEvent {}

// State
abstract class AppState {}

class AppInitial extends AppState {}

// Bloc
class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(AppInitial()) {
    on<AppStarted>((event, emit) {
      // Add your app start logic here
    });
  }
}
