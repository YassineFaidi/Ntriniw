import 'package:flutter_frontend/constants/app_img.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

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

  static String getTimeAgo(String iniTime) {
    final DateTime iniDateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').parse(iniTime);
    final Duration difference = DateTime.now().difference(iniDateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
