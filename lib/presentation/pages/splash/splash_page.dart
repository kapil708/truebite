import 'package:flutter/material.dart';
import 'package:food_ai/core/assets/image_assets.dart';
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
    Future.delayed(const Duration(seconds: 2)).then(
      (value) => context.goNamed(RouteName.home),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFE3F2EB),
      // backgroundColor: Theme.of(context).primaryColor,
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ImageAssets.trueBiteAi,
              width: MediaQuery.sizeOf(context).width * 0.6,
            ),
          ],
        ),
      ),
    );
  }
}
