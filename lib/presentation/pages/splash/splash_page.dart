import 'package:flutter/material.dart';
import 'package:food_ai/core/assets/image_assets.dart';
import 'package:food_ai/core/extensions/spacing.dart';
import 'package:food_ai/core/route/route_names.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    // return;
    Future.delayed(const Duration(seconds: 2)).then(
      (value) => context.goNamed(RouteName.home),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ImageAssets.trueBiteAi,
              width: MediaQuery.sizeOf(context).width * 0.4,
            ),
            VSpace(16),
            RichText(
              text: TextSpan(
                text: "Truebite",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w600),
                children: [
                  TextSpan(
                    text: " AI",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
