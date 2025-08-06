import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:truebite/core/utils/spacing.dart';
import 'package:truebite/presentation/common/image_preview.dart';

import '../../../../core/route/route_names.dart';
import '../../../../core/utils/ui_helper.dart';
import '../viewmodel/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static List howItWorks = [
    {'title': 'Snap It:', 'description': 'Capture a photo of packet food.'},
    {'title': 'Analyze It:', 'description': 'FoodAi identifies ingredients.'},
    {'title': 'Info at a Glance:', 'description': 'Instant nutritional breakdown.'},
    {'title': 'Health Rating:', 'description': 'Know how good or bad.'},
    {'title': 'Personalized Tips:', 'description': 'Tailored recommendations for a healthier you!'},
    {'title': 'Repeat Daily:', 'description': 'Your journey to a balanced and informed diet begins here!'},
  ];

  @override
  Widget build(BuildContext context) {
    // final l10n = AppLocalizations.of(context)!;

    ButtonStyle? buttonStyle = OutlinedButton.styleFrom(
      padding: EdgeInsets.zero,
      minimumSize: Size(200, 50),
    );

    HomeCubit homeCubit = context.read<HomeCubit>();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is HomeFailed) {
            showSnackBar(context, SnackBarType.error, state.message);
          } else if (state is HomeProcessImages) {
            context.pushNamed(
              RouteName.foodDetail,
              queryParameters: {'filePaths': jsonEncode(state.filePaths)},
            );
          } else if (state is HomePermissionDenied) {
            showAlertDialog(
              context: context,
              title: "Permission denied",
              body: "You have denied the permission. Open settings to allow.",
              actions: [
                TextButton(
                  onPressed: () => context.pop(),
                  child: const Text("Cancel"),
                ),
                FilledButton(
                  onPressed: () {
                    context.pop();
                    openAppSettings();
                  },
                  child: const Text("Open Settings"),
                ),
              ],
            );
          }
        },
        builder: (context, state) {
          return SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    // color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start your scan!',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              // color: Theme.of(context).colorScheme.onPrimaryContainer,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                      VSpace(4),
                      Text(
                        'Upload or take photos of the ingredients and nutrition info. We’ll do the rest.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              // color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  if (homeCubit.ingredients != null) ...[
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) {
                                            return ImagePreview(filePath: homeCubit.ingredients!.path);
                                          },
                                        );
                                      },
                                      child: Image.file(homeCubit.ingredients!),
                                    ),
                                    const VSpace(8),
                                  ],
                                  OutlinedButton(
                                    onPressed: () => imageSelection(
                                      context: context,
                                      type: 'ingredients',
                                      onTap: (value) {
                                        context.pop();
                                        homeCubit.pickImage(
                                          imageSource: value == 'camera' ? ImageSource.camera : ImageSource.gallery,
                                          type: 'ingredients',
                                          context: context,
                                          primaryColor: Theme.of(context).colorScheme.primary,
                                          toolbarWidgetColor: Theme.of(context).colorScheme.onPrimary,
                                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                        );
                                      },
                                    ),
                                    style: buttonStyle,
                                    child: Text(
                                      "Upload \nIngredients Image",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            HSpace(8),
                            Expanded(
                              child: Column(
                                children: [
                                  if (homeCubit.nutrition != null) ...[
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) {
                                            return ImagePreview(filePath: homeCubit.nutrition!.path);
                                          },
                                        );
                                      },
                                      child: Image.file(homeCubit.nutrition!),
                                    ),
                                    const VSpace(8),
                                  ],
                                  OutlinedButton(
                                    onPressed: () => imageSelection(
                                      context: context,
                                      type: 'nutrition',
                                      onTap: (value) {
                                        context.pop();
                                        homeCubit.pickImage(
                                          imageSource: value == 'camera' ? ImageSource.camera : ImageSource.gallery,
                                          type: 'nutrition',
                                          context: context,
                                          primaryColor: Theme.of(context).colorScheme.primary,
                                          toolbarWidgetColor: Theme.of(context).colorScheme.onPrimary,
                                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                        );
                                      },
                                    ),
                                    style: buttonStyle,
                                    child: Text(
                                      "Upload \nNutrition Image",
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        VSpace(16),
                        FilledButton(
                          onPressed: homeCubit.continueToFoodAIV2,
                          style: FilledButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.fromHeight(50),
                          ),
                          child: Text(
                            "Analyze Images",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FilledButton(
                  onPressed: homeCubit.getProductData,
                  child: Text("Get Product Data"),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      Text(
                        "TrueBite",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              height: 1,
                            ),
                      ),
                      Text("AI Food Scan", style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                VSpace(16),
              ],
            ),
          );
        },
      ),
    );
  }

  void imageSelection({
    required BuildContext context,
    required ValueChanged<String> onTap,
    required String type,
  }) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              VSpace(16),
              Text(
                "Pick image to continue.",
                style: Theme.of(context).textTheme.titleMedium,
              ),
              ListTile(
                leading: Icon(Icons.camera),
                title: Text("Capture using camera"),
                onTap: () => onTap('camera'),
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text("Pick from gallery"),
                onTap: () => onTap('gallery'),
              ),
            ],
          ),
        );
      },
    );
  }
}
