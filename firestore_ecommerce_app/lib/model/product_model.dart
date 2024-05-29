import 'package:flutter/material.dart';

class ProductModel with ChangeNotifier{
  dynamic productId;
  String productName;
  dynamic productPrice;
  String productImage;
  dynamic productCategory;
  bool isFavorited=false;
  int counter = 0 ;

  ProductModel({this.productId,required this.productName,required this.productPrice,required this.productImage,this.productCategory});


  factory ProductModel.fromMap(Map<String,dynamic>map,{dynamic productKey}){
    return ProductModel(productId: productKey ?? map["productId"],productName: map["productName"], productPrice: map["productPrice"], productImage: map["productImage"],productCategory: map["productCategoryId"]);
  }


  Map<String,dynamic> toMap({dynamic productKey,dynamic categoryKey}){
    return {
      "productId":productKey ?? productId,
      "productName":productName,
      "productPrice":productPrice,
      "productImage":productImage,
      "productCategoryId":categoryKey ?? productCategory,
    };
  }

  void setIsFavorited(bool value){
    isFavorited = value;
    notifyListeners();
  }

  void increase(){
    ++counter;
    notifyListeners();
  }
  void reduce(){
    if(counter > 0 ){
      --counter;
      notifyListeners();
    }
  }

}

class CategoryModel{
  dynamic categoryId;
  String categoryName;
  String categoryImage;

  CategoryModel({this.categoryId,required this.categoryName,required this.categoryImage});

  factory CategoryModel.fromMap(Map<String,dynamic>map,{dynamic key}){
    return CategoryModel(categoryId: key ?? map["categoryId"],categoryName: map["categoryName"], categoryImage: map["categoryImage"]);
  }




}