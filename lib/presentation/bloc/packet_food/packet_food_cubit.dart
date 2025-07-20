import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/helper/helper.dart';

part 'packet_food_state.dart';

class PacketFoodCubit extends Cubit<PacketFoodState> {
  PacketFoodCubit() : super(PacketFoodInitial());

  File? ingredients;
  File? nutrition;

  Future pickImage({
    required ImageSource imageSource,
    required String type,
    required BuildContext context,
    Color? backgroundColor,
    Color? primaryColor,
    Color? toolbarWidgetColor,
  }) async {
    try {
      emit(PacketFoodInitial());
      PermissionStatus? permissionStatus;

      if (imageSource == ImageSource.camera) {
        permissionStatus = await Permission.camera.request();
      } else if (imageSource == ImageSource.gallery) {
        // Only check for storage < Android 13
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        if (androidInfo.version.sdkInt >= 33) {
          permissionStatus = await Permission.photos.request();
        } else {
          permissionStatus = await Permission.storage.request();
        }
      }

      if (permissionStatus == PermissionStatus.granted) {
        actionAfterPermission(
          imageSource,
          type,
          backgroundColor: backgroundColor,
          primaryColor: primaryColor,
          toolbarWidgetColor: toolbarWidgetColor,
        );
      } else {
        emit(PacketFoodPermissionDenied());
      }
    } catch (e) {
      emit(PacketFoodFailed(e.toString()));
    }
  }

  void actionAfterPermission(
    ImageSource imageSource,
    String type, {
    Color? backgroundColor,
    Color? primaryColor,
    Color? toolbarWidgetColor,
  }) async {
    emit(PacketFoodLoading());

    File? file = await Helper().singleImagePicker(
      imageSource,
      allowOriginal: true,
      backgroundColor: backgroundColor,
      primaryColor: primaryColor,
      toolbarWidgetColor: toolbarWidgetColor,
    );
    if (file != null) {
      if (type == "ingredients") {
        ingredients = file;
      } else {
        nutrition = file;
      }
      emit(PacketFoodUpdate(DateTime.now()));
    }
  }

  void continueToFoodAI() {
    List<String> filePaths = [];
    if (ingredients != null) filePaths.add(ingredients!.path);
    if (nutrition != null) filePaths.add(nutrition!.path);

    emit(PacketFoodFileSelected(filePaths));
  }

  void continueToFoodAIV2() {
    List<String> filePaths = [];
    if (ingredients != null) filePaths.add(ingredients!.path);
    if (nutrition != null) filePaths.add(nutrition!.path);

    emit(PacketFoodFileSelectedV2(filePaths));
  }
}
