import 'package:dartz/dartz.dart';

import '../../core/utils/failures.dart';
import '../sources/remote/dio_client.dart';
import '../sources/remote/rest_client.dart';

class APIRepository {
  final RestClient restClient;

  APIRepository({required this.restClient});

  Future<Either<RemoteFailure, Map<String, dynamic>>> getTaskById() {
    return safeApiCall(
      apiCall: restClient.getTaskList,
      modelFromJson: (json) => Map<String, dynamic>.from(json['data']),
    );
  }
}
