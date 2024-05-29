import 'package:firestore_ecommerce_app/view_model/favorites_page_view_model.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/product_model.dart';
import '../../tools/constants.dart';

class AlertFavoritesView extends StatelessWidget {
  const AlertFavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of<FavoritesPageViewModel>(context).getData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.requireData.isEmpty) {
          return Center(
            child: Text(
              "FAVORİLERİNİZ BOŞ",
              style: Constants.getColorBoldStyle(
                  17, Theme.of(context).colorScheme.inversePrimary),
            ),
          );
        } else {
          List<ProductModel> products = snapshot.data!;
          return Padding(
            padding: Constants.normalPadding(),
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return _buildListItem(context, products[index], index);
              },
            ),
          );
        }
      },
    );
  }

  _buildListItem(
      BuildContext context, ProductModel productInBasket, int index) {
    return Stack(
      children: [
        Container(
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              title: Text(productInBasket.productName),
            )),
        Positioned(
            top: 0,
            left: 0,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Colors.red,
              child: Text("${index + 1}"),
            ))
      ],
    );
  }
}
