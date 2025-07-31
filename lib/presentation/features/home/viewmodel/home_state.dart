part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeDone extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeSuccess extends HomeState {
  @override
  List<Object> get props => [];
}

class HomePermissionDenied extends HomeState {
  @override
  List<Object> get props => [];
}

class HomeUpdate extends HomeState {
  final DateTime dateTime;

  const HomeUpdate(this.dateTime);

  @override
  List<Object> get props => [dateTime];
}

class HomeFailed extends HomeState {
  final String message;

  const HomeFailed(this.message);

  @override
  List<Object> get props => [message];
}

class HomeProcessImages extends HomeState {
  final List<String> filePaths;

  const HomeProcessImages(this.filePaths);

  @override
  List<Object> get props => [filePaths];
}
