import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:food_ai/injection_container.dart';
import 'package:lottie/lottie.dart';

import '../../bloc/food_detail/food_detail_cubit.dart';

class FoodDetailPage extends StatelessWidget {
  final String filePath;

  const FoodDetailPage({super.key, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator.get<FoodDetailCubit>()..init(filePath),
      child: const FoodDetailView(),
    );
  }
}

class FoodDetailView extends StatelessWidget {
  const FoodDetailView({super.key});

  //static ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    FoodDetailCubit foodDetailCubit = context.read<FoodDetailCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text("Food information")),
      body: BlocConsumer<FoodDetailCubit, FoodDetailState>(
        listener: (context, state) {},
        builder: (context, state) {
          return state is FoodDetailLoading
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(64),
                    child: Lottie.asset('assets/lottie/aiLoading.json'),
                  ),
                )
              : foodDetailCubit.aiResult != null
                  ? Column(
                      children: [
                        Expanded(
                          child: Scrollbar(
                            thumbVisibility: true,
                            trackVisibility: true,
                            thickness: 6,
                            radius: const Radius.circular(8),
                            child: Markdown(
                              selectable: true,
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                              data: foodDetailCubit.aiResult!,
                            ),
                          ),
                        ),
                        Container(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            "Disclaimer: This is AI-generated insights. "
                            "Users advised to verify information for accuracy. "
                            "App cannot guarantee 100% accuracy; cross-check for reliable outcomes.",
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      ],
                    )
                  : const Center(child: Text('Search something!'));
        },
      ),
    );
  }
}
