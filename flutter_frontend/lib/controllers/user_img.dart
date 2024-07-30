import 'package:flutter_frontend/constants/app_img.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class UserImg {
  UserImg();

  static ImageProvider? getuserImg(String profileImg) {
    ImageProvider? profileImage;
    if (profileImg == '') {
      profileImage = const AssetImage(userImg);
    } else {
      profileImage = MemoryImage(base64Decode(profileImg));
    }
    return profileImage;
  }
}
