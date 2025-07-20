import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class GeminiLoading extends StatelessWidget {
  const GeminiLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('assets/lottie/aiLoading.json'),
            Text(
              "AI is in the process of fetching data."
              "\nThis operation may take a moment."
              "\nSo your patience is appreciated.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
