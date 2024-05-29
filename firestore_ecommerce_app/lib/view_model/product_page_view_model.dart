import 'dart:async';

import 'package:flutter/material.dart';

import '../model/product_model.dart';
import '../repository/database_repository.dart';
import '../tools/locator.dart';

class ProductPageViewModel with ChangeNotifier {
  StreamSubscription<List<ProductModel>>? _subscription;
  dynamic categoryId;
  List<ProductModel> _products = [];
  bool _stateValue = false;
  int _productCount = 0;
  bool _textFieldState = false;


  final DatabaseRepository _repository = locator<DatabaseRepository>();

  ProductPageViewModel({this.categoryId}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getProductsData(categoryId);
      getProductCount();
    });
  }

  void getProductsData(dynamic categoryId) {
    _subscription = _repository.getProducts(categoryId).listen((products) {
      _products = products;
      notifyListeners();
    });
  }

  Stream<List<ProductModel>> isFavorited(ProductModel productModel) {
    return _repository.isFavorited(productModel);
  }

  void deleteFavorited(ProductModel productModel) async {
    await _repository.deleteFavorites(productModel);
  }

  void addFavoritesByProduct(ProductModel productModel) async {
    await _repository.addFavorites(productModel);
  }

  void addBasketByProduct(ProductModel productModel) async {
    await _repository.addProductForBasket(productModel);
  }

  void changeButtonState(bool value) {
    _stateValue = !value;
    notifyListeners();
  }

  void changeFieldState(bool value) {
    _textFieldState = !value;
    notifyListeners();
  }

  void getProductCount() async {
    _productCount = await _repository.basketCount(categoryId: categoryId);
    notifyListeners();
  }

  void getSearchingData(String wantedValue) {
    _subscription?.cancel(); // Önceki dinleyiciyi iptal et
    _subscription = _repository.getProducts(categoryId).listen((products) {
      _products = products
          .where((element) => element.productName
              .toLowerCase()
              .contains(wantedValue.toLowerCase()))
          .toList();
      notifyListeners();
    });
  }



  set productCount(int value) {
    _productCount = value;
    notifyListeners();
  }

  List<ProductModel> get products => _products;

  bool get stateValue => _stateValue;

  int get productCount => _productCount;

  bool get textFieldState => _textFieldState;
}
