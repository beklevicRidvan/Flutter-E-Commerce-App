import 'package:flutter/material.dart';

import '../model/product_model.dart';
import '../repository/database_repository.dart';
import '../tools/locator.dart';

class FavoritesPageViewModel with ChangeNotifier  {
  final DatabaseRepository _repository = locator<DatabaseRepository>();

  Stream<List<ProductModel>> getData() {
    return _repository.getProductsInFavorites();
  }

  void deleteFavorite(ProductModel productModel) async {
    await _repository.deleteFavorites(productModel);
  }
}
