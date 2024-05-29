import 'package:flutter/material.dart';

class FavoriteModel with ChangeNotifier{
  dynamic favoriteId;

  FavoriteModel({this.favoriteId});

  factory FavoriteModel.fromMap(Map<String,dynamic> map , {dynamic key}){
    return FavoriteModel(favoriteId: key ?? map["favoriteId"]);
  }
}