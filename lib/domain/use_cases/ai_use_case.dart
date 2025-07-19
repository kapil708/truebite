import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

import '../../core/error/failures.dart';
import '../repositories/ai_repository.dart';

class AiUseCase {
  final AiRepository aiRepository;

  AiUseCase({required this.aiRepository});

  Future<Either<RemoteFailure, String>> getPacketFoodInfoByImage(List<Uint8List> images) async {
    return aiRepository.getPacketFoodInfoByImage(images);
  }

  Future<Either<RemoteFailure, Map<String, dynamic>>> getPacketFoodJsonByImage(List<Uint8List> images) async {
    return aiRepository.getPacketFoodJsonByImage(images);
  }
}
