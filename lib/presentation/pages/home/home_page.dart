import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_ai/core/extensions/spacing.dart';
import 'package:food_ai/l10n/app_localizations.dart';
import 'package:food_ai/presentation/widgets/shimmer/image_preview.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/route/route_names.dart';
import '../../../injection_container.dart';
import '../../bloc/packet_food/packet_food_cubit.dart';
import '../../core/helper.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => locator.get<PacketFoodCubit>(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

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
    final l10n = AppLocalizations.of(context)!;

    ButtonStyle? buttonStyle = OutlinedButton.styleFrom(
      padding: EdgeInsets.zero,
      minimumSize: Size(200, 50),
      side: BorderSide(color: Colors.grey, width: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );

    PacketFoodCubit packetFoodCubit = context.read<PacketFoodCubit>();

    return Scaffold(
      body: BlocConsumer<PacketFoodCubit, PacketFoodState>(
        listener: (context, state) {
          if (state is PacketFoodFailed) {
            showSnackBar(context, SnackBarType.error, state.message);
          } else if (state is PacketFoodFileSelected) {
            context.pushNamed(
              RouteName.foodDetail,
              queryParameters: {'filePaths': jsonEncode(state.filePaths)},
            );
          } else if (state is PacketFoodFileSelectedV2) {
            context.pushNamed(
              RouteName.foodDetailV2,
              queryParameters: {'filePaths': jsonEncode(state.filePaths)},
            );
          } else if (state is PacketFoodPermissionDenied) {
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
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Analyze Food",
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      VSpace(32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(color: Colors.white),
                              child: Column(
                                children: [
                                  if (packetFoodCubit.ingredients != null) ...[
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) {
                                            return ImagePreview(filePath: packetFoodCubit.ingredients!.path);
                                          },
                                        );
                                      },
                                      child: Image.file(packetFoodCubit.ingredients!),
                                    ),
                                    const VSpace(8),
                                  ],
                                  OutlinedButton(
                                    onPressed: () => imageSelection(
                                      context: context,
                                      type: 'ingredients',
                                      onTap: (value) {
                                        context.pop();
                                        packetFoodCubit.pickImage(
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
                          ),
                          HSpace(8),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(color: Colors.white),
                              child: Column(
                                children: [
                                  if (packetFoodCubit.nutrition != null) ...[
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (_) {
                                            return ImagePreview(filePath: packetFoodCubit.nutrition!.path);
                                          },
                                        );
                                      },
                                      child: Image.file(packetFoodCubit.nutrition!),
                                    ),
                                    const VSpace(8),
                                  ],
                                  OutlinedButton(
                                    onPressed: () => imageSelection(
                                      context: context,
                                      type: 'nutrition',
                                      onTap: (value) {
                                        context.pop();
                                        packetFoodCubit.pickImage(
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
                          ),
                        ],
                      ),
                      VSpace(16),
                      FilledButton(
                        onPressed: packetFoodCubit.continueToFoodAIV2,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.fromHeight(50),
                          side: BorderSide(color: Colors.grey, width: 1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.ac_unit),
                    HSpace(8),
                    Text(
                      "AI INSIGHTS",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          );

          // return SingleChildScrollView(
          //   child: SizedBox(
          //     width: MediaQuery.sizeOf(context).width,
          //     child: Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Expanded(
          //                 child: Column(
          //                   children: [
          //                     FilledButton(
          //                       onPressed: () => imageSelection(
          //                         context: context,
          //                         type: 'ingredients',
          //                         onTap: (value) {
          //                           context.pop();
          //                           packetFoodCubit.pickImage(
          //                             imageSource: value == 'camera' ? ImageSource.camera : ImageSource.gallery,
          //                             type: 'ingredients',
          //                             context: context,
          //                             primaryColor: Theme.of(context).colorScheme.primary,
          //                             toolbarWidgetColor: Theme.of(context).colorScheme.onPrimary,
          //                             backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          //                           );
          //                         },
          //                       ),
          //                       child: Row(
          //                         mainAxisAlignment: MainAxisAlignment.center,
          //                         children: [
          //                           Icon(Icons.ac_unit),
          //                           HSpace(4),
          //                           Text("Pick Ingredients"),
          //                         ],
          //                       ),
          //                     ),
          //                     if (packetFoodCubit.ingredients != null) ...[
          //                       Image.file(packetFoodCubit.ingredients!),
          //                       const VSpace(8),
          //                     ],
          //                   ],
          //                 ),
          //               ),
          //               HSpace(8),
          //               Expanded(
          //                 child: Column(
          //                   children: [
          //                     FilledButton(
          //                       onPressed: () => imageSelection(
          //                         context: context,
          //                         type: 'nutrition',
          //                         onTap: (value) {
          //                           context.pop();
          //                           packetFoodCubit.pickImage(
          //                             imageSource: value == 'camera' ? ImageSource.camera : ImageSource.gallery,
          //                             type: 'nutrition',
          //                             context: context,
          //                             primaryColor: Theme.of(context).colorScheme.primary,
          //                             toolbarWidgetColor: Theme.of(context).colorScheme.onPrimary,
          //                             backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          //                           );
          //                         },
          //                       ),
          //                       child: Row(
          //                         mainAxisAlignment: MainAxisAlignment.center,
          //                         children: [
          //                           Icon(Icons.nature_outlined),
          //                           HSpace(4),
          //                           Text("Pick Nutrition"),
          //                         ],
          //                       ),
          //                     ),
          //                     if (packetFoodCubit.nutrition != null) ...[
          //                       Image.file(packetFoodCubit.nutrition!),
          //                       const VSpace(8),
          //                     ],
          //                   ],
          //                 ),
          //               ),
          //             ],
          //           ),
          //           const VSpace(8),
          //           // FilledButton(
          //           //   onPressed: () => packetFoodCubit.pickImage(
          //           //     ImageSource.camera,
          //           //     'ingredients',
          //           //     context: context,
          //           //     primaryColor: Theme.of(context).colorScheme.primary,
          //           //     toolbarWidgetColor: Theme.of(context).colorScheme.onPrimary,
          //           //     backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          //           //   ),
          //           //   style: FilledButton.styleFrom(backgroundColor: Colors.blue),
          //           //   child: const Row(
          //           //     mainAxisAlignment: MainAxisAlignment.center,
          //           //     children: [
          //           //       Icon(Icons.camera),
          //           //       HSpace(8),
          //           //       Text("Capture using camera"),
          //           //     ],
          //           //   ),
          //           // ),
          //           // const VSpace(8),
          //           // FilledButton(
          //           //   onPressed: () => packetFoodCubit.pickImage(
          //           //     ImageSource.gallery,
          //           //     '',
          //           //     context: context,
          //           //     primaryColor: Theme.of(context).colorScheme.primary,
          //           //     toolbarWidgetColor: Theme.of(context).colorScheme.onPrimary,
          //           //     backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          //           //   ),
          //           //   child: const Row(
          //           //     mainAxisAlignment: MainAxisAlignment.center,
          //           //     children: [
          //           //       Icon(Icons.image_outlined),
          //           //       HSpace(8),
          //           //       Text("Pick from gallery"),
          //           //     ],
          //           //   ),
          //           // ),
          //           // const VSpace(16),
          //           if (packetFoodCubit.ingredients != null && packetFoodCubit.nutrition != null) ...[
          //             FilledButton(
          //               onPressed: packetFoodCubit.continueToFoodAI,
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   Text("Continue to FoodAi"),
          //                   Icon(Icons.keyboard_arrow_right),
          //                 ],
          //               ),
          //             ),
          //             FilledButton(
          //               onPressed: packetFoodCubit.continueToFoodAIV2,
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.center,
          //                 children: [
          //                   Text("Continue to FoodAi V2"),
          //                   Icon(Icons.keyboard_arrow_right),
          //                 ],
          //               ),
          //             ),
          //           ],
          //           const Divider(),
          //           const VSpace(8),
          //           Text(
          //             "Discover a healthier you with FoodAi! Your pocket nutritionist awaits!",
          //             style: Theme.of(context).textTheme.titleLarge,
          //           ),
          //           const VSpace(32),
          //           Text(
          //             "How it works",
          //             style: Theme.of(context).textTheme.titleLarge,
          //           ),
          //           const VSpace(8),
          //           ...howItWorks.map((step) {
          //             return RichText(
          //               text: TextSpan(
          //                 text: "${step['title']}",
          //                 style: Theme.of(context).textTheme.titleMedium,
          //                 children: [
          //                   TextSpan(
          //                     text: " ${step['description']}",
          //                     style: Theme.of(context).textTheme.bodyLarge,
          //                   )
          //                 ],
          //               ),
          //             );
          //           }),
          //         ],
          //       ),
          //     ),
          //   ),
          // );
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
        return Column(
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
        );
      },
    );
  }
}
