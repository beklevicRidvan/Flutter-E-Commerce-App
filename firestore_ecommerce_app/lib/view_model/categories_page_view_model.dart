import 'package:flutter/material.dart';

import '../model/product_model.dart';
import '../repository/database_repository.dart';
import '../tools/locator.dart';

class CategoriesPageViewModel with ChangeNotifier {
  List<CategoryModel> _categories = [];

  List<CategoryModel> get categories => _categories;

  final DatabaseRepository _repo = locator<DatabaseRepository>();

  CategoriesPageViewModel() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  void getData() async {
    _categories = await _repo.getCategories();
    notifyListeners();
  }
}
