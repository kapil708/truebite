part of 'packet_food_cubit.dart';

abstract class PacketFoodState extends Equatable {
  const PacketFoodState();
}

class PacketFoodInitial extends PacketFoodState {
  @override
  List<Object> get props => [];
}

class PacketFoodLoading extends PacketFoodState {
  @override
  List<Object> get props => [];
}

class PacketFoodDone extends PacketFoodState {
  @override
  List<Object> get props => [];
}

class PacketFoodSuccess extends PacketFoodState {
  @override
  List<Object> get props => [];
}

class PacketFoodPermissionDenied extends PacketFoodState {
  @override
  List<Object> get props => [];
}

class PacketFoodFailed extends PacketFoodState {
  final String message;

  const PacketFoodFailed(this.message);

  @override
  List<Object> get props => [message];
}

class PacketFoodFileSelected extends PacketFoodState {
  final String filePath;

  const PacketFoodFileSelected(this.filePath);

  @override
  List<Object> get props => [filePath];
}
