import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/assets/image_assets.dart';
import '../../../../core/utils/spacing.dart';
import '../../../common/image_preview.dart';
import '../viewmodel/food_detail_cubit.dart';
import 'common/content_text_row.dart';
import 'common/gemini_loading.dart';
import 'common/header_text_row.dart';
import 'common/no_data.dart';

class FoodDetailPage extends StatelessWidget {
  const FoodDetailPage({super.key});

  Color getNovaColor(int nova) {
    switch (nova) {
      case 1:
        return Color(0xFF3A8424);
      case 2:
        return Color(0xFFF4B63F);
      case 3:
        return Color(0xFFEA4D27);
      default:
        return Color(0xFFE83323);
    }
  }

  Color getFoodScoreColor(int foodScore) {
    if (foodScore > 75) {
      return Color(0xFF3D894F);
    } else if (foodScore > 50) {
      return Color(0xFFF3CA45);
    } else if (foodScore > 25) {
      return Color(0xFFE47A32);
    } else {
      return Color(0xFFDC422D);
    }
  }

  String getNutriScoreImage(String nutriScore) {
    switch (nutriScore) {
      case 'A':
        return ImageAssets.nutriScoreA;
      case 'B':
        return ImageAssets.nutriScoreB;
      case 'C':
        return ImageAssets.nutriScoreC;
      default:
        return ImageAssets.nutriScoreD;
    }
  }

  List<Map<String, dynamic>> getNutrition(dynamic nutrition) {
    return List<Map<String, dynamic>>.from(nutrition) ?? [];
  }

  String getIngredients(dynamic ingredients) {
    return List<String>.from(ingredients).join(", ");
  }

  List<String> getTags(dynamic tags) {
    return List<String>.from(tags) ?? [];
  }

  @override
  Widget build(BuildContext context) {
    FoodDetailCubit foodDetailCubit = context.read<FoodDetailCubit>();
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    return BlocConsumer<FoodDetailCubit, FoodDetailState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text("Food information")),
          body: state is FoodDetailLoading
              ? GeminiLoading()
              : foodDetailCubit.aiResult != null
                  ? SafeArea(
                      child: Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  //Files
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "View input images 👉",
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context).textTheme.titleMedium,
                                        ),
                                      ),
                                      ...foodDetailCubit.localFiles.map((file) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          child: GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (_) {
                                                  return ImagePreview(filePath: file.path);
                                                },
                                              );
                                            },
                                            child: Image.file(
                                              file,
                                              width: MediaQuery.sizeOf(context).width * 0.2,
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                  VSpace(16),

                                  //Base info
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surfaceContainerLowest,
                                      // border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                                      // borderRadius: BorderRadius.circular(16),
                                      // borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                                    ),
                                    child: Column(
                                      children: [
                                        HeaderTextRow(
                                          title: "NUTRI-SCORE",
                                          description: foodDetailCubit.aiResult!['nutri_score']['description'],
                                          tooltip: 'Nutri-Score is a nutrition rating system that helps you make healthier food choices. It assigns a score to food products based on their nutritional value from A to E.',
                                          trailing: Image.asset(
                                            getNutriScoreImage(foodDetailCubit.aiResult!['nutri_score']['score']),
                                            height: 42,
                                          ),
                                        ),
                                        HeaderTextRow(
                                          title: "NOVA",
                                          description: foodDetailCubit.aiResult!['nova_score']['description'],
                                          tooltip: 'NOVA separates foods into four categories based on the extent to which they have been processed.',
                                          trailing: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: getNovaColor(foodDetailCubit.aiResult!['nova_score']['score']),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              "${foodDetailCubit.aiResult!['nova_score']['score']}",
                                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        HeaderTextRow(
                                          title: "FOOD-SCORE",
                                          description: foodDetailCubit.aiResult!['food_score']['category'],
                                          tooltip:
                                              'The food score values are designed to aid in making healthier food choices. It rates foods based on their additives and nutrition value, including calories, total fats, saturated fats, etc. The system assigns a score to each food item from 0 to 100.',
                                          trailing: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: getFoodScoreColor(foodDetailCubit.aiResult!['food_score']['score']),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              "${foodDetailCubit.aiResult!['food_score']['score']} / 100",
                                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        VSpace(4),
                                        SizedBox(
                                          width: double.infinity,
                                          child: Wrap(
                                            children: [
                                              ...getTags(foodDetailCubit.aiResult!['food_tags']).map((tag) {
                                                return Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  margin: EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context).colorScheme.primary,
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: Text(
                                                    tag,
                                                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                          color: Theme.of(context).colorScheme.onPrimary,
                                                        ),
                                                  ),
                                                );
                                              }),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  VSpace(8),

                                  //Nutrition
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surfaceContainerLowest,
                                      // color: Theme.of(context).colorScheme.primaryContainer,
                                      // borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                                    ),
                                    child: Column(
                                      children: [
                                        HeaderTextRow(
                                          title: "Nutrition",
                                          description: "Serving Size: ${foodDetailCubit.aiResult!['serving_size']}",
                                          tooltip: 'The nutrition list helps you to see what nutrients are in the food you are considering. It will help you make healthier, more informed choices about what you eat.',
                                          trailing: Text(
                                            "(per 100 g)",
                                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                                ),
                                          ),
                                        ),
                                        Divider(color: Theme.of(context).colorScheme.outline),
                                        ...getNutrition(foodDetailCubit.aiResult!['nutrition']).map((nutrition) {
                                          List<Map<String, dynamic>> nutritionList = getNutrition(foodDetailCubit.aiResult!['nutrition']);
                                          int index = nutritionList.indexOf(nutrition);

                                          return ContentTextRow(
                                            icon: nutrition['icon'] ?? '🥗',
                                            title: nutrition['title'],
                                            subTitle: nutrition['label'],
                                            value: nutrition['value'],
                                            showBorder: (index + 1) == nutritionList.length ? false : true,
                                          );
                                        }),
                                      ],
                                    ),
                                  ),
                                  VSpace(8),

                                  //Ingredients
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surfaceContainerLowest,
                                      // color: Theme.of(context).colorScheme.primaryContainer,
                                      // borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                                    ),
                                    child: Column(
                                      children: [
                                        HeaderTextRow(
                                          title: "Ingredients",
                                          tooltip: 'Ingredients are the substances that are used to make a particular food product. They can include a variety of different things, such as raw materials, additives, and other substances.',
                                        ),
                                        VSpace(4),
                                        Wrap(
                                          children: [
                                            Text(
                                              getIngredients(foodDetailCubit.aiResult!['ingredients']),
                                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                                                    height: 1.5,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  VSpace(8),

                                  //Summary
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.surfaceContainerLowest,
                                      // color: Theme.of(context).colorScheme.primaryContainer,
                                      // borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        HeaderTextRow(
                                          title: "Summary",
                                          tooltip: 'NA',
                                        ),
                                        VSpace(4),
                                        Text(
                                          foodDetailCubit.aiResult!['summary']['recommendation'],
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        Text(
                                          foodDetailCubit.aiResult!['summary']['note'],
                                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                                              ),
                                        ),
                                        VSpace(12),
                                        Text(
                                          "Daily Limits",
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        ContentTextRow(
                                          icon: '👶',
                                          title: "Child",
                                          subTitle: foodDetailCubit.aiResult!['summary']['age_group']['child'],
                                          value: foodDetailCubit.aiResult!['summary']['daily_limit']['child'],
                                          showBorder: true,
                                        ),
                                        ContentTextRow(
                                          icon: '👱',
                                          title: "Adult",
                                          subTitle: foodDetailCubit.aiResult!['summary']['age_group']['adult'],
                                          value: foodDetailCubit.aiResult!['summary']['daily_limit']['adult'],
                                          showBorder: true,
                                        ),
                                        ContentTextRow(
                                          icon: '👴',
                                          title: "Elderly",
                                          subTitle: foodDetailCubit.aiResult!['summary']['age_group']['elderly'],
                                          value: foodDetailCubit.aiResult!['summary']['daily_limit']['elderly'],
                                          showBorder: false,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Disclaimer(),
                        ],
                      ),
                    )
                  : NoData(onRetry: () => foodDetailCubit.getFoodInfo()),
        );
      },
    );
  }
}
