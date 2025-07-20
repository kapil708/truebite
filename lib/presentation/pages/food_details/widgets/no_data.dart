import 'package:flutter/material.dart';
import 'package:food_ai/core/extensions/spacing.dart';
import 'package:go_router/go_router.dart';

class NoData extends StatelessWidget {
  final Function()? onRetry;

  const NoData({
    super.key,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'No Data Found',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const VSpace(4),
            Text(
              'Ai is not able to fetch data for this product.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const VSpace(16),
            FilledButton(
              onPressed: onRetry,
              child: const Text("Ask Ai to try again"),
            ),
            const VSpace(8),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text("Go back"),
            ),
          ],
        ),
      ),
    );
  }
}
