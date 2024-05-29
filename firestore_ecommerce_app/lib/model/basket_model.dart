import 'package:flutter/cupertino.dart';

class BasketModel with ChangeNotifier{

  dynamic basketId;

  BasketModel({this.basketId});

  factory BasketModel.fromMap (Map<String,dynamic> map,{dynamic key}){
    return BasketModel(basketId: key ?? map["basketId"]);
  }

  Map<String,dynamic> toMap({dynamic key}){
    return {
      "basketId":key ?? basketId,
    };
  }

}