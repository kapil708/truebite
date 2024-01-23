import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

import '../../core/error/failures.dart';

abstract class AiRepository {
  Future<Either<RemoteFailure, String>> getPacketFoodInfoByImage(Uint8List body);
}
