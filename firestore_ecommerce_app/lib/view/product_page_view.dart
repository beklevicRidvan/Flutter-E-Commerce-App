import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/product_model.dart';
import '../tools/constants.dart';
import '../tools/controller/navigation_controller.dart';
import '../view_model/product_page_view_model.dart';

class ProductPageView extends StatelessWidget with NavigationController {
  const ProductPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  _buildAppBar() {
    return PreferredSize(
        preferredSize: const Size(double.infinity, 60),
        child: Consumer<ProductPageViewModel>(
          builder: (context, value, child) {
            return AppBar(
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
              title: value.textFieldState
                  ? CupertinoSearchTextField(
                      onChanged: (myValue) {
                        value.getSearchingData(myValue);
                      },
                      backgroundColor: Colors.white,
                    )
                  : Text(
                      "Products",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: Constants.getFontSize(25)),
                    ),
              backgroundColor: Colors.red,
              actionsIconTheme: const IconThemeData(
                size: 35,
                color: Colors.white,
                applyTextScaling: true,
              ),
              actions: [
                Stack(
                  children: [
                    ButtonBar(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              value.changeFieldState(value.textFieldState);
                            },
                            icon: value.textFieldState
                                ? const Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                  )
                                : const Icon(Icons.search)),
                        IconButton(
                            onPressed: () {
                              goBasketPage(context);
                            },
                            icon: const Icon(Icons.shopping_cart_outlined)),
                      ],
                    ),
                    Positioned(
                        top: 5,
                        right: 5,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.white,
                          child: Text(
                            value.productCount.toString(),
                            style: const TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        )),
                  ],
                ),
                const SizedBox(
                  width: 15,
                ),
              ],
            );
          },
        ));
  }

  _buildBody(BuildContext context) {
    return Consumer<ProductPageViewModel>(
      builder: (context, value, child) {
        if (value.products.isNotEmpty) {
          return SizedBox(
            height: 700,
            child: GridView.builder(
              padding: Constants.normalPadding(),
              itemCount: value.products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 300,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 15),
              itemBuilder: (context, index) {
                return _buildListItem(
                    context, index, value, value.products[index]);
              },
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        }
      },
    );
  }

  _buildListItem(BuildContext context, int index,
      ProductPageViewModel viewModel, ProductModel product) {
    return GestureDetector(
      onTap: () {
        goDetailPage(context, product);
      },
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade600, spreadRadius: 1, blurRadius: 1)
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CachedNetworkImage(
                  imageUrl: product.productImage, // Image URL
                  fit: BoxFit.cover,
                  imageBuilder: (context, imageProvider) => Image(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    width: 200,
                    height: 200,
                  ),
                  placeholder: (context, url) => Image.asset(
                    Constants.basketPagePlaceHolderImageAdress,
                    fit: BoxFit.cover,
                    width: 200,
                    height: 200,
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error), // Error widget (optional)
                ),
                Text(Constants.getSpliceWord(product.productName)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${product.productPrice} TL",
                      style: Constants.productMoneyTextStyle(),
                    ),
                    IconButton(
                        onPressed: () {
                          viewModel.addBasketByProduct(product);
                        },
                        icon: Icon(
                          Icons.shopping_basket_outlined,
                          color: Theme.of(context).colorScheme.surface,
                          size: 30,
                        ))
                  ],
                ),
              ],
            ),
          ),
          StreamBuilder(
            stream: viewModel.isFavorited(product),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                List<ProductModel> products = snapshot.data!;
                return Positioned(
                    right: 0,
                    top: 5,
                    child: IconButton(
                        iconSize: 30,
                        style: IconButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary),
                        onPressed: () {
                          if (products.isEmpty) {
                            viewModel.addFavoritesByProduct(product);
                          }

                          viewModel.deleteFavorited(product);
                        },
                        icon: products.isNotEmpty
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_border_outlined,
                                color: Colors.red,
                              )));
              }
            },
          )
        ],
      ),
    );
  }
}
