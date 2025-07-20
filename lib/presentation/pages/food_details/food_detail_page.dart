import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:food_ai/injection_container.dart';
import 'package:food_ai/presentation/pages/food_details/widgets/disclaimer.dart';

import '../../bloc/food_detail/food_detail_cubit.dart';
import 'widgets/gemini_loading.dart';
import 'widgets/no_data.dart';

class FoodDetailPage extends StatelessWidget {
  final List<dynamic> filePaths;

  const FoodDetailPage({super.key, required this.filePaths});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator.get<FoodDetailCubit>()..init(filePaths),
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
              ? GeminiLoading()
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
                        Disclaimer(),
                      ],
                    )
                  : NoData(onRetry: () => foodDetailCubit.getFoodInfo());
        },
      ),
    );
  }
}
