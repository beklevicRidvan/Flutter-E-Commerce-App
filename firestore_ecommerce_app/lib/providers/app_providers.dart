import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../view_model/auth_view_model/login_or_register_page_view_model.dart';
import '../view_model/auth_view_model/login_page_view_model.dart';
import '../view_model/auth_view_model/register_page_view_model.dart';
import '../view_model/basket_page_view_model.dart';
import '../view_model/categories_page_view_model.dart';
import '../view_model/favorites_page_view_model.dart';
import '../view_model/home_page_view_model.dart';
import '../view_model/profile_page_view_model.dart';

class Providers {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(
      create: (context) => LoginOrRegisterPageViewModel(),
    ),
    ChangeNotifierProvider(
      create: (context) => LoginPageViewModel(),
    ),
    ChangeNotifierProvider(
      create: (context) => RegisterPageViewModel(),
    ),
    ChangeNotifierProvider(
      create: (context) => HomePageViewModel(),
    ),
    ChangeNotifierProvider(
      create: (context) => CategoriesPageViewModel(),
    ),
    ChangeNotifierProvider(
      create: (context) => FavoritesPageViewModel(),
    ),
    ChangeNotifierProvider(
      create: (context) => BasketPageViewModel(),
    ),
    ChangeNotifierProvider(
      create: (context) => ProfilePageViewModel(),
    ),
  ];
}
