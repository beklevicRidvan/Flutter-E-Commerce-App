import 'package:cached_network_image/cached_network_image.dart';
import 'package:firestore_ecommerce_app/tools/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/product_model.dart';
import '../view_model/product_page_view_model.dart';

class ProductDetailPageView extends StatelessWidget {
  final ProductModel product;
  const ProductDetailPageView({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.red,
      title: Text(
        product.productName,
        style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    );
  }

  _buildBody(BuildContext context) {
    return
        Card(
          color: Theme.of(context).colorScheme.background,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CachedNetworkImage(
              imageUrl: product.productImage, // Image URL
              height: 500,
              fit: BoxFit.contain,
              imageBuilder: (context, imageProvider) => Image(
                image: imageProvider,
                height: 500,
                fit: BoxFit.contain,
              ),
              placeholder: (context, url) => Image.asset(
                Constants.basketPagePlaceHolderImageAdress,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error), // Error widget (optional)
                        ),
            ),

              Text(
                product.productName,
                style: Constants.getNormalTextStyle(16),
              ),
              ChangeNotifierProvider.value(
                value: product,
                child: _buildBasketConsumer(context),
              ),
            ],
          ),
        );

  }

  _buildBasketConsumer(BuildContext context) {
    ProductPageViewModel value =
        Provider.of<ProductPageViewModel>(context, listen: false);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          "${product.counter != 0 ? (product.productPrice * product.counter).toStringAsFixed(3) : product.productPrice} TL",
          style: Constants.productMoneyTextStyle(),
        ),
        ElevatedButton(
            onPressed: () {
              value.changeButtonState(value.stateValue);
            },
            child: value.stateValue
                ? Row(
                    children: [
                      IconButton(
                          onPressed: () => product.reduce(),
                          icon: const Icon(CupertinoIcons.minus)),
                      Text(product.counter.toString()),
                      IconButton(
                          onPressed: () => product.increase(),
                          icon: const Icon(Icons.add)),
                      IconButton(
                          onPressed: () {
                            value.changeButtonState(value.stateValue);
                            if (product.counter != 0) {
                              value.addBasketByProduct(product);
                            }
                          },
                          icon: const Icon(Icons.check))
                    ],
                  )
                : TextButton(
                    onPressed: () => value.addBasketByProduct(product),
                    child:  Text("SEPETE EKLE",style: Constants.getColorBoldStyle(17, Theme.of(context).colorScheme.tertiary),)))
      ],
    );
  }
}
