import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/repositories/ai_repository.dart';
import '../data_sources/remote_data_source.dart';

class AiRepositoryImpl implements AiRepository {
  final RemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AiRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<RemoteFailure, String>> getPacketFoodInfoByImage(List<Uint8List> images) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getPacketFoodInfoByImage(images);
        return Right(response);
      } on RemoteException catch (e) {
        return Left(RemoteFailure(statusCode: e.statusCode, message: e.message));
      }
    } else {
      return const Left(RemoteFailure(statusCode: 12163, message: 'No internet connection.'));
    }
  }

  @override
  Future<Either<RemoteFailure, Map<String, dynamic>>> getPacketFoodJsonByImage(List<Uint8List> images) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.getPacketFoodJsonByImage(images);
        return Right(response);
      } on RemoteException catch (e) {
        return Left(RemoteFailure(statusCode: e.statusCode, message: e.message));
      }
    } else {
      return const Left(RemoteFailure(statusCode: 12163, message: 'No internet connection.'));
    }
  }
}
