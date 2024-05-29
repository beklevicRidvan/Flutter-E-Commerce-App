import 'package:flutter/material.dart';

import '../model/product_model.dart';
import '../repository/database_repository.dart';
import '../tools/locator.dart';

class BasketPageViewModel with ChangeNotifier {

  final DatabaseRepository _repository = locator<DatabaseRepository>();

  BasketPageViewModel() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  Stream<List<ProductModel>> getData() async* {
    yield* _repository.getProductsInBasket();
  }

  void deleteData(ProductModel productModel) async {
    await _repository.deleteProductForBasket(productModel);
  }

  Stream<double?>getBasketTotalPrice(){
  return  _repository.getBasketTotalPrice();
  }

}
