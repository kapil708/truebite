import 'dart:typed_data';

import 'package:dartz/dartz.dart';

import '../../core/services/gemini_service.dart';
import '../../core/utils/exceptions.dart';
import '../../core/utils/failures.dart';
import '../../core/utils/network_info.dart';

class GeminiRepository {
  final GeminiService geminiService;
  final NetworkInfo networkInfo;

  GeminiRepository({required this.geminiService, required this.networkInfo});

  Future<Either<RemoteFailure, Map<String, dynamic>>> getPacketFoodJsonByImage(List<Uint8List> images) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await geminiService.getPacketFoodJsonByImage(images);
        return Right(response);
      } on RemoteException catch (e) {
        return Left(RemoteFailure(statusCode: e.statusCode, message: e.message));
      }
    } else {
      return const Left(RemoteFailure(statusCode: 12163, message: 'No internet connection.'));
    }
  }
}
