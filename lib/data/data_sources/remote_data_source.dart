import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:http/http.dart' as http;

import '../../core/error/exceptions.dart';
import '../models/login/login_model.dart';
import 'ai_helper.dart';
import 'api_helper.dart';
import 'api_methods.dart';

abstract class RemoteDataSource {
  Future<LoginModel> login(Map<String, dynamic> body);
  Future<String> getPacketFoodInfoByImage(List<Uint8List> images);
  Future<Map<String, dynamic>> getPacketFoodJsonByImage(List<Uint8List> images);
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
  Future<String> getPacketFoodInfoByImage(List<Uint8List> images) async {
    try {
      Candidates? candidates = await Gemini.instance.prompt(
        parts: [
          Part.text(packetFoodScript5),
          ...images.map((i) => Part.bytes(i)),
        ],
      );

      // log("JSON=> ${candidates?.content?.parts?.last.toString()}");
      String output = cleanJsonOutput(candidates?.output);

      log("JSON2=> $output");
      log("JSON3=> ${jsonDecode(output)}");

      // return Map<String, dynamic>.from(jsonDecode(output));
      return candidates?.output ?? '';

      // log("candidates => ${candidates?.output}");
      // return candidates?.content?.parts?.last.text ?? '';
    } catch (e) {
      return Future.error(
        RemoteException(
          statusCode: e.runtimeType.hashCode,
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Map<String, dynamic>> getPacketFoodJsonByImage(List<Uint8List> images) async {
    try {
      Candidates? candidates = await Gemini.instance.prompt(
        parts: [
          Part.text(packetFoodScript5),
          ...images.map((i) => Part.bytes(i)),
        ],
      );

      String output = cleanJsonOutput(candidates?.output);

      log("output => $output");

      return Map<String, dynamic>.from(jsonDecode(output));
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

String cleanJsonOutput(String? rawOutput) {
  if (rawOutput == null || rawOutput.isEmpty) return '';

  return rawOutput
      .replaceAll('```json', '') // Removes starting ```json with optional whitespace
      .replaceAll('```', '') // Removes ending ```
      .trim();
}
