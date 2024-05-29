import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/product_model.dart';
import '../tools/constants.dart';
import '../tools/controller/navigation_controller.dart';
import '../tools/themes/theme_provider.dart';
import '../view_model/categories_page_view_model.dart';

class CategoriesPageView extends StatelessWidget with NavigationController {
  const CategoriesPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // Carousel Sliver
        SliverToBoxAdapter(
          child: Padding(
            padding: Constants.normalPadding(),
            child: SizedBox(
              width: 300,
              child: CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    aspectRatio: 16 / 9,
                    viewportFraction: 1,
                  ),
                  items: Constants.images),
            ),
          ),
        ),

        // Grid Sliver
        Consumer<CategoriesPageViewModel>(
          builder: (context, value, child) {
            if (value.categories.isNotEmpty) {
              return SliverPadding(
                padding: Constants.normalPadding(),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 300,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      var currentElement = value.categories[index];
                      return _buildListItem(context, currentElement);
                    },
                    childCount: value.categories.length,
                  ),
                ),
              );
            } else {
              return const SliverToBoxAdapter(
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  _buildListItem(BuildContext context, CategoryModel currentElement) {
    return GestureDetector(
      onTap: () {
        goProductsByCategoryId(context, currentElement.categoryId);
      },
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
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CachedNetworkImage(
              imageUrl: currentElement.categoryImage,
              placeholder: (context, url) => Image.asset(
                Constants.basketPagePlaceHolderImageAdress,
                fit: BoxFit.cover,
                width: 200,
                height: 200,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              imageBuilder: (context, imageProvider) => Image(
                image: imageProvider,
                fit: BoxFit.cover,
                width: 200,
                height: 200,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: Text(
                currentElement.categoryName,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Constants.getFontSize(18)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
