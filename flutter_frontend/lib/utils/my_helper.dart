import 'package:flutter_frontend/constants/app_img.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class MyHelper {
  MyHelper();

  static ImageProvider? getuserImg(String? profileImg) {
    ImageProvider? profileImage;
    if (profileImg == '') {
      profileImage = const AssetImage(userImg);
    } else {
      profileImage = MemoryImage(base64Decode(profileImg!));
    }
    return profileImage;
  }

  static ImageProvider getDbImg(String dbImg) {
    ImageProvider? extImage;

    extImage = MemoryImage(base64Decode(dbImg));

    return extImage;
  }
}
