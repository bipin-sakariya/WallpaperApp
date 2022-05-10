import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

part 'internet_checker_event.dart';
part 'internet_checker_state.dart';

class InternetCheckerBloc
    extends Bloc<InternetCheckerEvent, InternetCheckerState> {
  StreamSubscription<InternetConnectionStatus>? connectivitySubscription;
  InternetCheckerBloc() : super(InternetLoadingState()) {
    on<InternetCheckerEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<InternetConnected>((event, emit) => emit(InternetConnectedState()));
    on<InternetNotConnected>(
        (event, emit) => emit(InternetNotConnectedState()));
    connectivitySubscription = InternetConnectionChecker()
        .onStatusChange
        .listen((InternetConnectionStatus result) {
      switch (result) {
        case InternetConnectionStatus.connected:
          add(InternetConnected());
          break;
        case InternetConnectionStatus.disconnected:
          add(InternetNotConnected());
          break;
      }
    });
  }
  @override
  Future<void> close() {
    connectivitySubscription?.cancel();
    // TODO: implement close
    return super.close();
  }
}
