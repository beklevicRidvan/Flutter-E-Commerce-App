import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  dynamic userId;
  dynamic userName;
  String userEmail;
  dynamic profile_pic;

  UserModel(
      {this.userId, this.userName, required this.userEmail, this.profile_pic});

  factory UserModel.fromMap(Map<String, dynamic> map, {dynamic key}) {
    return UserModel(
        userId: key ?? map["userId"],
        userName: map["userName"],
        userEmail: map["userEmail"],
        profile_pic: map["profile_pic"]);
  }

  Map<String, dynamic> toMap({dynamic key, dynamic newUserName}) {
    return {
      "userId": key ?? userId,
      "userName": newUserName,
      "userEmail": userEmail,
      "profile_pic": "https://www.pngall.com/wp-content/uploads/5/Profile-PNG-Images.png",
      "lastLogged": Timestamp.now(),
    };
  }

  Map<String, dynamic> toUpdatedMap(
      {required String newUserName, required String newUserEmail}) {
    return {
      "userId": userId,
      "userName": newUserName,
      "userEmail": newUserEmail,
    };
  }
}
