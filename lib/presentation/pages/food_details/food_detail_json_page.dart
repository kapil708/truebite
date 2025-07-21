import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_ai/core/assets/image_assets.dart';
import 'package:food_ai/core/extensions/spacing.dart';
import 'package:food_ai/core/theme/color_schemes.g.dart';
import 'package:food_ai/injection_container.dart';
import 'package:food_ai/presentation/bloc/food_detail_json/food_detail_json_cubit.dart';
import 'package:food_ai/presentation/pages/food_details/widgets/disclaimer.dart';
import 'package:food_ai/presentation/widgets/shimmer/image_preview.dart';

import 'widgets/content_text_row.dart';
import 'widgets/gemini_loading.dart';
import 'widgets/header_text_row.dart';
import 'widgets/no_data.dart';

class FoodDetailJsonPage extends StatelessWidget {
  final List<dynamic> filePaths;
  const FoodDetailJsonPage({super.key, required this.filePaths});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator.get<FoodDetailJsonCubit>()..init(filePaths),
      child: FoodDetailJsonView(),
    );
  }
}

class FoodDetailJsonView extends StatelessWidget {
  const FoodDetailJsonView({super.key});

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
    if (foodScore > 80) {
      return Color(0xFF3D894F);
    } else if (foodScore > 60) {
      return Color(0xFF88C748);
    } else if (foodScore > 40) {
      return Color(0xFFF3CA45);
    } else if (foodScore > 20) {
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
    FoodDetailJsonCubit foodDetailCubit = context.read<FoodDetailJsonCubit>();

    return BlocConsumer<FoodDetailJsonCubit, FoodDetailJsonState>(
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
                                      color: Colors.white,
                                      border: Border.all(color: CustomColors.dividerColor),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        HeaderTextRow(
                                          title: "NUTRI-SCORE",
                                          description: foodDetailCubit.aiResult!['nutri_score']['description'],
                                          tooltip: 'Nutri-Score is a nutrition rating system that helps you make healthier food choices. It assigns a score to food products based on their nutritional value from A to E.',
                                          trailing: Image.asset(
                                            getNutriScoreImage(foodDetailCubit.aiResult!['nutri_score']['score']),
                                            height: 32,
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
                                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
                                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
                                                    color: CustomColors.textBgColor,
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: Text(
                                                    tag,
                                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                          color: CustomColors.textPrimaryColor,
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
                                  VSpace(16),

                                  //Nutrition
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: CustomColors.dividerColor),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
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
                                                  color: CustomColors.textSecondaryColor,
                                                ),
                                          ),
                                        ),
                                        Divider(color: CustomColors.dividerColor),
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
                                  VSpace(16),

                                  //Ingredients
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: CustomColors.dividerColor),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16),
                                        topRight: Radius.circular(16),
                                      ),
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
                                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
                                            ),
                                          ],
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

        return Scaffold(
          appBar: AppBar(title: const Text("Food information")),
          body: state is FoodDetailLoading
              ? GeminiLoading()
              : foodDetailCubit.aiResult != null
                  ? Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            // thumbVisibility: true,
                            // trackVisibility: true,
                            // thickness: 6,
                            // radius: const Radius.circular(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                HeaderTextRow(
                                  title: "NUTRI-SCORE",
                                  description: foodDetailCubit.aiResult!['nutri_score']['description'],
                                  tooltip: 'Nutri-Score is a nutrition rating system that helps you make healthier food choices. It assigns a score to food products based on their nutritional value from A to E.',
                                  trailing: Image.asset(
                                    getNutriScoreImage(foodDetailCubit.aiResult!['nutri_score']['score']),
                                    height: 32,
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
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                ),
                                HeaderTextRow(
                                  title: "FOOD-SCORE",
                                  description: foodDetailCubit.aiResult!['food_score']['category'],
                                  tooltip: 'The food score values are designed to aid in making healthier food choices. It rates foods based on their additives and nutrition value, including calories, total fats, saturated fats, etc. The system assigns a score to each food item from 0 to 100.',
                                  trailing: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: getFoodScoreColor(foodDetailCubit.aiResult!['food_score']['score']),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "${foodDetailCubit.aiResult!['food_score']['score']} / 100",
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                ),
                                VSpace(4),
                                HeaderTextRow(
                                  title: "Food-Tag",
                                  tooltip:
                                      'This section provides helpful information about various tags associated with your scanned food products, such as vegan, vegetarian, palm oil free etc. Please be aware that there may be a possibility of missing, incomplete, or incorrect data about the food tags or changes in product composition. If you follow any dietary restrictions, it is important to be aware of ingredients and tagging in the foods you eat and to check the labels carefully to get the most current and accurate information.',
                                  color: CustomColors.dividerColor,
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  height: 60,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.grey.shade400)),
                                  ),
                                  child: Wrap(
                                    children: [
                                      ...getTags(foodDetailCubit.aiResult!['food_tags']).map((tag) {
                                        return Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          margin: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            color: CustomColors.dividerColor,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            tag,
                                            style: Theme.of(context).textTheme.bodyMedium,
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                                HeaderTextRow(
                                  title: "Nutrition",
                                  description: "Serving Size: ${foodDetailCubit.aiResult!['serving_size']}",
                                  tooltip: 'The nutrition list helps you to see what nutrients are in the food you are considering. It will help you make healthier, more informed choices about what you eat.',
                                  color: CustomColors.dividerColor,
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  height: 60,
                                  trailing: Text(
                                    "(per 100 g)",
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                          color: Colors.grey.shade600,
                                        ),
                                  ),
                                ),
                                ...getNutrition(foodDetailCubit.aiResult!['nutrition']).map((nutrition) {
                                  return ContentTextRow(
                                    icon: nutrition['icon'] ?? '🥗',
                                    title: nutrition['title'],
                                    subTitle: nutrition['label'],
                                    value: nutrition['value'],
                                  );
                                }),
                                HeaderTextRow(
                                  title: "Ingredients",
                                  tooltip: 'Ingredients are the substances that are used to make a particular food product. They can include a variety of different things, such as raw materials, additives, and other substances.',
                                  color: CustomColors.dividerColor,
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  height: 60,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                  width: double.infinity,
                                  child: Wrap(
                                    children: [
                                      Text(
                                        getIngredients(foodDetailCubit.aiResult!['ingredients']),
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
                                      ),
                                    ],
                                  ),
                                ),
                                VSpace(16),
                              ],
                            ),
                          ),
                        ),
                        Disclaimer(),
                      ],
                    )
                  : NoData(onRetry: () => foodDetailCubit.getFoodInfo()),
        );
      },
    );
  }
}
