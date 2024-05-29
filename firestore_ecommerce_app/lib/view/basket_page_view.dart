import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/product_model.dart';
import '../tools/constants.dart';
import '../tools/controller/navigation_controller.dart';
import '../tools/themes/theme_provider.dart';
import '../view_model/basket_page_view_model.dart';

class BasketPageView extends StatelessWidget with NavigationController {
  const BasketPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          Provider.of<BasketPageViewModel>(context, listen: false).getData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        } else if (snapshot.requireData.isEmpty) {
          return Center(
            child: Text(
              "Sepetiniz boş.",
              style: Constants.getNormalTextStyle(20),
            ),
          );
        } else {
          List<ProductModel> products = snapshot.data!;
          return Column(
            children: [
              Expanded(
                  child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  var currentProduct = products[index];
                  return _buildListItem(context, index, currentProduct);
                },
              )),
              GestureDetector(
                child: Container(
                  padding: Constants.normalPadding(),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      boxShadow: const [
                        BoxShadow(color: Colors.grey, blurRadius: 2)
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            "TOPLAM FİYAT",
                            style: Constants.getColorBoldStyle(15, Colors.red),
                          ),
                          StreamBuilder(
                            stream: Provider.of<BasketPageViewModel>(context,
                                    listen: false)
                                .getBasketTotalPrice(),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(snapshot.error.toString()),
                                );
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.red,
                                  ),
                                );
                              } else if (snapshot.requireData == null) {
                                return Text(
                                  "0 TL",
                                  style: Constants.getColorBoldStyle(18,
                                      Theme.of(context).colorScheme.surface),
                                );
                              } else {
                                double? totalPrice = snapshot.data!;
                                return Text(
                                  "$totalPrice TL",
                                  style: Constants.getColorBoldStyle(18,
                                      Theme.of(context).colorScheme.surface),
                                );
                              }
                            },
                          )
                        ],
                      ),
                      ElevatedButton(
                          onPressed: () => goOrdersPageView(context),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          child: Text(
                            "Alışverişi Tamamla",
                            style:
                                Constants.getColorBoldStyle(18, Colors.white),
                          ))
                    ],
                  ),
                ),
              )
            ],
          );
        }
      },
    );
  }

  _buildListItem(
      BuildContext context, int index, ProductModel productInBasket) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Dismissible(
            onDismissed: (direction) =>
                context.read<BasketPageViewModel>().deleteData(productInBasket),
            key: Key(productInBasket.productId.toString()),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Provider.of<ThemeProvider>(context, listen: false)
                              .isDarkMode
                          ? Colors.red
                          : Colors.grey.shade900,
                      blurRadius: 0.2,
                      spreadRadius: 0.2)
                ],
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: Constants.normalPadding(),
              margin: const EdgeInsets.only(top: 20, bottom: 5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CachedNetworkImage(
                        imageUrl: productInBasket.productImage, // Image URL
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                        imageBuilder: (context, imageProvider) => Image(
                          image: imageProvider,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        placeholder: (context, url) => Image.asset(
                          Constants.basketPagePlaceHolderImageAdress,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error), // Error widget (optional)
                      ),
                      Column(
                        children: [
                          Text(Constants.getSpliceWord(
                              productInBasket.productName)),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(productInBasket.productPrice.toString()),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
            top: 10,
            left: 10,
            child: CircleAvatar(
              backgroundColor: Colors.red,
              child: Text("${index + 1}"),
            ))
      ],
    );
  }
}
