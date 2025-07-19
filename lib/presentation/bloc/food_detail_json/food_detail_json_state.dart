part of 'food_detail_json_cubit.dart';

sealed class FoodDetailJsonState extends Equatable {
  const FoodDetailJsonState();
}

final class FoodDetailJsonInitial extends FoodDetailJsonState {
  @override
  List<Object> get props => [];
}

class FoodDetailLoading extends FoodDetailJsonState {
  @override
  List<Object> get props => [];
}

class FoodDetailDone extends FoodDetailJsonState {
  @override
  List<Object> get props => [];
}

class FoodDetailSuccess extends FoodDetailJsonState {
  @override
  List<Object> get props => [];
}

class FoodDetailFailed extends FoodDetailJsonState {
  final String message;

  const FoodDetailFailed(this.message);

  @override
  List<Object> get props => [message];
}
