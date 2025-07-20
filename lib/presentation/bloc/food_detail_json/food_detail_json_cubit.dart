import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:food_ai/domain/use_cases/ai_use_case.dart';

part 'food_detail_json_state.dart';

class FoodDetailJsonCubit extends Cubit<FoodDetailJsonState> {
  final AiUseCase aiUseCase;

  FoodDetailJsonCubit({
    required this.aiUseCase,
  }) : super(FoodDetailJsonInitial());

  Map<String, dynamic>? aiResult;
  List<File> localFiles = [];

  init(List<dynamic> filePaths) {
    for (var filePath in filePaths) {
      localFiles.add(File(filePath));
    }

    if (localFiles.isNotEmpty) getFoodInfo();
  }

  getFoodInfo() async {
    try {
      if (localFiles.isNotEmpty) {
        emit(FoodDetailLoading());

        //final byteData = await file.readAsBytesSync();
        List<Uint8List> images = [];

        for (var localFile in localFiles) {
          images.add(localFile.readAsBytesSync());
        }

        final response = await aiUseCase.getPacketFoodJsonByImage(images);

        response.fold(
          (failure) {
            emit(FoodDetailFailed(failure.message));
          },
          (data) {
            aiResult = data;
            emit(FoodDetailSuccess());
          },
        );
      } else {
        emit(const FoodDetailFailed("Image not found please go back and pick new image."));
      }
    } on Exception catch (e) {
      emit(FoodDetailFailed(e.toString()));
    }
  }
}
