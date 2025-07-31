part of 'food_detail_cubit.dart';

sealed class FoodDetailState extends Equatable {
  const FoodDetailState();
}

final class FoodDetailInitial extends FoodDetailState {
  @override
  List<Object> get props => [];
}

class FoodDetailLoading extends FoodDetailState {
  @override
  List<Object> get props => [];
}

class FoodDetailDone extends FoodDetailState {
  @override
  List<Object> get props => [];
}

class FoodDetailSuccess extends FoodDetailState {
  @override
  List<Object> get props => [];
}

class FoodDetailFailed extends FoodDetailState {
  final String message;

  const FoodDetailFailed(this.message);

  @override
  List<Object> get props => [message];
}
