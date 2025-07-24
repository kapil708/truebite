import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class GeminiLoading extends StatelessWidget {
  const GeminiLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('assets/lottie/aiAssistant.json'),
            Text(
              "TrueBite AI is processing your data. \nHang tight, this won't take long. \n\n Your patience is appreciated 🙏",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
