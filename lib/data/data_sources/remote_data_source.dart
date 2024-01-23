import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_gemini/src/models/candidates/candidates.dart';
import 'package:http/http.dart' as http;

import '../../core/error/exceptions.dart';
import '../models/login/login_model.dart';
import 'ai_helper.dart';
import 'api_helper.dart';
import 'api_methods.dart';

abstract class RemoteDataSource {
  Future<LoginModel> login(Map<String, dynamic> body);
  Future<String> getPacketFoodInfoByImage(Uint8List body);
}

Map<String, String>? get _headers => {'Accept': 'application/json', 'Content-Type': 'application/json'};
//final gemini = Gemini.instance;

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;

  RemoteDataSourceImpl({required this.client});

  @override
  Future<LoginModel> login(Map<String, dynamic> body) async {
    return await postRequest(
      client: client,
      api: ApiMethods.login,
      body: body,
      modelFromJson: (data) => LoginModel.fromJson(data['data']),
    );
  }

  @override
  Future<String> getPacketFoodInfoByImage(Uint8List body) async {
    try {
      Candidates? candidates = await Gemini.instance.textAndImage(
        text: packetFoodScript,
        images: [body],
      );
      return candidates?.content?.parts?.last.text ?? '';
    } catch (e) {
      return Future.error(
        RemoteException(
          statusCode: e.runtimeType.hashCode,
          message: e.toString(),
        ),
      );
    }
  }
}
