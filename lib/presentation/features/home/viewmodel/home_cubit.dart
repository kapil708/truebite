import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/utils/helper.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

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
      emit(HomeInitial());
      PermissionStatus? permissionStatus;

      if (imageSource == ImageSource.camera) {
        permissionStatus = await Permission.camera.request();
      } else if (imageSource == ImageSource.gallery) {
        if (Platform.isIOS) {
          permissionStatus = await Permission.photos.request();
        } else {
          // Only check for storage < Android 13
          DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          if (androidInfo.version.sdkInt >= 33) {
            permissionStatus = await Permission.photos.request();
          } else {
            permissionStatus = await Permission.storage.request();
          }
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
        emit(HomePermissionDenied());
      }
    } catch (e) {
      emit(HomeFailed(e.toString()));
    }
  }

  void actionAfterPermission(
    ImageSource imageSource,
    String type, {
    Color? backgroundColor,
    Color? primaryColor,
    Color? toolbarWidgetColor,
  }) async {
    emit(HomeLoading());

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
      emit(HomeUpdate(DateTime.now()));
    }
  }

  void continueToFoodAIV2() {
    if (ingredients != null && nutrition != null) {
      List<String> filePaths = [ingredients!.path, nutrition!.path];

      ingredients = null;
      nutrition = null;

      emit(HomeProcessImages(filePaths));
    }
  }
}
