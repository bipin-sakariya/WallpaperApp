part of 'internet_checker_bloc.dart';

abstract class InternetCheckerState extends Equatable {
  const InternetCheckerState();
}

class InternetLoadingState extends InternetCheckerState {
  @override
  List<Object> get props => [];
}

class InternetConnectedState extends InternetCheckerState {
  @override
  List<Object> get props => [];
}

class InternetNotConnectedState extends InternetCheckerState {
  @override
  List<Object> get props => [];
}
