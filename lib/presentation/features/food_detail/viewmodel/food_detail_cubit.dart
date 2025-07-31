import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../data/repositories/gemini_repository.dart';

part 'food_detail_state.dart';

class FoodDetailCubit extends Cubit<FoodDetailState> {
  final GeminiRepository geminiRepository;

  FoodDetailCubit({
    required this.geminiRepository,
  }) : super(FoodDetailInitial());

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

        final response = await geminiRepository.getPacketFoodJsonByImage(images);

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
