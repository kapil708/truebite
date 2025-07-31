import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:truebite/core/assets/image_assets.dart';
import 'package:truebite/core/utils/spacing.dart';

import '../../../../core/route/route_names.dart';
import '../viewmodel/splash_cubit.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if (state is SplashAuthorised) {
          context.goNamed(RouteName.home);
        }
      },
      child: Scaffold(
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
              VSpace(32),
              Text(
                "TrueBite",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                      height: 1,
                    ),
              ),
              Text(
                "AI Food Scan",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
