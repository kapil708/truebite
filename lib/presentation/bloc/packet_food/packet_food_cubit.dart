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

  Future pickImage(
    ImageSource imageSource, {
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
    ImageSource imageSource, {
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
      emit(PacketFoodFileSelected(file.path));
    }
  }
}
