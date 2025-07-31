import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter_gemini/flutter_gemini.dart';

import '../constants/gemini_constants.dart';
import '../utils/exceptions.dart';

class GeminiService {
  Future<Map<String, dynamic>> getPacketFoodJsonByImage(List<Uint8List> images) async {
    try {
      Candidates? candidates = await Gemini.instance.prompt(
        parts: [
          Part.text(geminiPrompt),
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

  String cleanJsonOutput(String? rawOutput) {
    if (rawOutput == null || rawOutput.isEmpty) return '';

    return rawOutput
        .replaceAll('```json', '') // Removes starting ```json with optional whitespace
        .replaceAll('```', '') // Removes ending ```
        .trim();
  }
}
