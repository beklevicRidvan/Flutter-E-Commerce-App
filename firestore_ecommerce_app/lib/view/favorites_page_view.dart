import 'package:cached_network_image/cached_network_image.dart';
import 'package:firestore_ecommerce_app/model/product_model.dart';
import 'package:firestore_ecommerce_app/tools/themes/theme_provider.dart';
import 'package:firestore_ecommerce_app/view_model/favorites_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../tools/constants.dart';

class FavoritesPageView extends StatelessWidget {
  const FavoritesPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
          Provider.of<FavoritesPageViewModel>(context, listen: false).getData(),
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
        }
        else if(snapshot.requireData.isEmpty){
          return  Center(child: Text("Favorileriniz boş.",style: Constants.getNormalTextStyle(20),),);
        }
        else {
          List<ProductModel> products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return _buildListItem(context, products[index], index);
            },
          );
        }
      },
    );
  }

  Widget _buildListItem(
      BuildContext context, ProductModel currentElement, int index) {
    FavoritesPageViewModel value = Provider.of(context, listen: false);
    return Stack(
      children: [
        Padding(
          padding: Constants.normalPadding(),
          child: Slidable(
            key: Key(currentElement.productId),
            endActionPane: ActionPane(motion: const StretchMotion(), children: [
              SlidableAction(
                onPressed: (context) => value.deleteFavorite(currentElement),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                borderRadius: BorderRadius.circular(12),
                label: "Ürünü Kaldır",
                icon: Icons.clear,
              )
            ]),
            child: Container(
              padding: Constants.normalPadding(),
              margin: const EdgeInsets.only(top: 5, bottom: 5),
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
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CachedNetworkImage(
                        imageUrl: currentElement.productImage, // Image URL
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                        imageBuilder: (context, imageProvider) => Image( // Image when loaded successfully
                          image: imageProvider,
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                        placeholder: (context, url) => Image.asset( // Placeholder during loading
                          Constants.basketPagePlaceHolderImageAdress,
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error), // Error widget (optional)
                      ),
                      Column(
                        children: [
                          Text(
                            Constants.getSpliceWord(currentElement.productName),
                            style: Constants.getNormalColorTextStyle(
                                15, Theme.of(context).colorScheme.surface),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            "${currentElement.productPrice} TL",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.surface),
                          ),
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
