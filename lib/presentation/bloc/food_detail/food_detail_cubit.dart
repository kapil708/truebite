import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/use_cases/ai_use_case.dart';

part 'food_detail_state.dart';

class FoodDetailCubit extends Cubit<FoodDetailState> {
  final AiUseCase aiUseCase;

  FoodDetailCubit({
    required this.aiUseCase,
  }) : super(FoodDetailInitial());

  String? aiResult;

  init(String filePath) {
    getFoodInfo(File(filePath));
  }

  getFoodInfo(File file) async {
    try {
      emit(FoodDetailLoading());

      //final byteData = await file.readAsBytesSync();
      final Uint8List image = file.readAsBytesSync();

      final response = await aiUseCase.getPacketFoodInfoByImage(image);

      response.fold(
        (failure) {
          emit(FoodDetailFailed(failure.message));
        },
        (data) {
          aiResult = data;
          emit(FoodDetailSuccess());
        },
      );
    } on Exception catch (e) {
      emit(FoodDetailFailed(e.toString()));
    }
  }
}
