import 'package:flutter/material.dart';

class Disclaimer extends StatelessWidget {
  const Disclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        border: Border(
          top: BorderSide(color: Colors.grey.shade400),
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: Text(
        "Disclaimer: This is AI-generated insights. "
        "Users advised to verify information for accuracy. "
        "App cannot guarantee 100% accuracy; cross-check for reliable outcomes.",
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}
