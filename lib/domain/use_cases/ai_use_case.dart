import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

import '../../core/error/failures.dart';
import '../repositories/ai_repository.dart';

class AiUseCase {
  final AiRepository aiRepository;

  AiUseCase({required this.aiRepository});

  Future<Either<RemoteFailure, String>> getPacketFoodInfoByImage(Uint8List body) async {
    return aiRepository.getPacketFoodInfoByImage(body);
  }
}
