import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/product_model.dart';
import '../../model/user_model.dart';
import '../../view/dialog_view/alert_basket_view.dart';
import '../../view/dialog_view/alert_favorites_view.dart';
import '../../view/orders_page_view.dart';
import '../../view/payment_page_view.dart';
import '../../view/product_detail_page_view.dart';
import '../../view/product_page_view.dart';
import '../../view/profile_info_page_view.dart';
import '../../view/show_dialog_view.dart';
import '../../view_model/basket_page_view_model.dart';
import '../../view_model/favorites_page_view_model.dart';
import '../../view_model/home_page_view_model.dart';
import '../../view_model/payment_page_view_model.dart';
import '../../view_model/product_page_view_model.dart';
import '../../view_model/profile_page_view_model.dart';

mixin NavigationController on StatelessWidget {
  void goProductsByCategoryId(BuildContext context, dynamic categoryId) {
    MaterialPageRoute pageRoute = MaterialPageRoute(
      builder: (context) {
        return ChangeNotifierProvider(
          key: const Key("0"),
          create: (context) => ProductPageViewModel(categoryId: categoryId),
          child: const ProductPageView(),
        );
      },
    );
    Navigator.push(context, pageRoute);
  }

  void goDetailPage(BuildContext context, ProductModel product) {
    MaterialPageRoute pageRoute = MaterialPageRoute(
      builder: (context) => ChangeNotifierProvider(
        key: const Key("0"),
        create: (context) => ProductPageViewModel(),
        child: ProductDetailPageView(
          product: product,
        ),
      ),
    );
    Navigator.push(context, pageRoute);
  }

  void goBasketPage(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              backgroundColor: Theme.of(context).colorScheme.background,
              child: ChangeNotifierProvider(
                key: const Key("0"),
                create: (context) => BasketPageViewModel(),
                child: const SizedBox(height: 500, child: AlertBasketView()),
              ),
            ));
  }

  void goAboutProfilePage(BuildContext context, UserModel userModel) {
    MaterialPageRoute pageRoute = MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
              key: const Key("0"),
              create: (context) => ProfilePageViewModel(),
              child: ProfileInfoPageView(
                userModel: userModel,
              ),
            ));
    Navigator.push(context, pageRoute);
  }

  void goFavoritesPage(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
              backgroundColor: Theme.of(context).colorScheme.background,
              child: ChangeNotifierProvider(
                key: const Key("0"),
                create: (context) => FavoritesPageViewModel(),
                child: const SizedBox(height: 500, child: AlertFavoritesView()),
              ),
            ));
  }

  void goPaymentPage(BuildContext context) {
    MaterialPageRoute pageRoute = MaterialPageRoute(
      builder: (_) => ChangeNotifierProvider(
        key: const Key("0"),
        create: (_) => PaymentPageViewModel(),
        child: const PaymentPageView(),
      ),
    );

    Navigator.push(context, pageRoute);
  }

  void goDialog(BuildContext context) {
    showModalBottomSheet(
        useSafeArea: true,
        context: context,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withOpacity(0.5),
        isScrollControlled: true,
        builder: (context) => ChangeNotifierProvider(
              create: (context) => HomePageViewModel(),
              child: CustomDraggableDialog(
                maxHeight: MediaQuery.of(context).size.height,
                initialHeight: MediaQuery.of(context).size.height * 0.4,
              ),
            ));
  }

  void goOrdersPageView(BuildContext context) {
    MaterialPageRoute pageRoute = MaterialPageRoute(
      builder: (context) => ChangeNotifierProvider(
        create: (context) => HomePageViewModel(),
        child: ChangeNotifierProvider(
          create: (context) => PaymentPageViewModel(),
          child: ChangeNotifierProvider(create: (context) => BasketPageViewModel(),child: const OrdersPageView(),),
        ),
      ),
    );
    Navigator.push(context, pageRoute);
  }
}
