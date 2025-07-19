import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

import '../../core/error/failures.dart';

abstract class AiRepository {
  Future<Either<RemoteFailure, String>> getPacketFoodInfoByImage(List<Uint8List> images);
  Future<Either<RemoteFailure, Map<String, dynamic>>> getPacketFoodJsonByImage(List<Uint8List> images);
}
