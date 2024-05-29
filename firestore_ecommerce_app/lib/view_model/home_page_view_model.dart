import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/adres_model.dart';
import '../repository/database_repository.dart';
import '../tools/locator.dart';
import '../view/add_adress_view.dart';
import '../view/adress_page_view.dart';
import '../view/basket_page_view.dart';
import '../view/categories_page_view.dart';
import '../view/favorites_page_view.dart';
import '../view/profile_page_view.dart';
import 'adress_view_model.dart';

class HomePageViewModel with ChangeNotifier {
  int _selectedIndex = 3;
  late CategoriesPageView _categoriesPageView;
  late FavoritesPageView _favoritesPageView;
  late BasketPageView _basketPageView;
  late ProfilePageView _profilePageView;
  late List<Widget> _widgetList;
  late final PageController controller;

  final _repository = locator<DatabaseRepository>();

  void changeIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  HomePageViewModel() {
    controller = PageController(initialPage: _selectedIndex);
    _categoriesPageView = const CategoriesPageView();
    _favoritesPageView = const FavoritesPageView();
    _basketPageView = const BasketPageView();
    _profilePageView = const ProfilePageView();
    _widgetList = [
      _categoriesPageView,
      _favoritesPageView,
      _basketPageView,
      _profilePageView
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  Stream<List<AdressModel>> getSelectedAdress() {
    return _repository.getUsersSelectedAdress();
  }

  Stream<List<AdressModel>> getAdressData() {
    return _repository.getUserAdress();
  }

  void updateSelectedAdress(String? newSelectedAdressId) async {
    await _repository.setSelectedValue(newSelectedAdressId);
  }

  void goAddAdressPageView(BuildContext context) {
    MaterialPageRoute pageRoute = MaterialPageRoute(
      builder: (context) => ChangeNotifierProvider(
        create: (context) => AdressViewModel(),
        child: const AddAdressView(),
      ),
    );

    Navigator.push(context, pageRoute);
  }

  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  double getSize(BuildContext context) {
    if (selectedIndex == 0) {
      return MediaQuery.of(context).size.height / 6;
    } else {
      return MediaQuery.of(context).size.height / 12;
    }
  }

  void goAdressPageView(BuildContext context) {
    MaterialPageRoute pageRoute = MaterialPageRoute(
      builder: (context) => ChangeNotifierProvider(
        create: (context) => HomePageViewModel(),
        child: const AdressPageView(),
      ),
    );
    Navigator.push(context, pageRoute);
  }


  void deleteAdress(AdressModel adressModel)async{
    await _repository.deleteAdress(adressModel);
  }


  Stream<String?> getSelectedAdressId(){
    return _repository.getSelectedAdressId();
  }

  int get selectedIndex => _selectedIndex;

  List<Widget> get widgetList => _widgetList;
}
