part of 'internet_checker_bloc.dart';

abstract class InternetCheckerEvent extends Equatable {
  const InternetCheckerEvent();
}

class InternetConnected extends InternetCheckerEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class InternetNotConnected extends InternetCheckerEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
