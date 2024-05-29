import 'package:cached_network_image/cached_network_image.dart';
import 'package:firestore_ecommerce_app/model/product_model.dart';
import 'package:firestore_ecommerce_app/view_model/home_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../tools/components/myRadioTile.dart';
import '../tools/constants.dart';
import '../tools/controller/navigation_controller.dart';
import '../view_model/basket_page_view_model.dart';
import '../view_model/payment_page_view_model.dart';

class OrdersPageView extends StatelessWidget with NavigationController {
  const OrdersPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      bottomNavigationBar: _buildBottomSheet(context),
    );
  }

  _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.red,
      title: Text(
        "Güvenli Alışveriş",
        style: Constants.getColorBoldStyle(20, Colors.white),
      ),
      shadowColor: Theme.of(context).colorScheme.secondary,
      elevation: 15,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white, size: 30),
      actions: const [
        Icon(
          Icons.shopping_cart_outlined,
          color: Colors.white,
        ),
        SizedBox(
          width: 30,
        ),
      ],
    );
  }

  _buildBody(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildDeliveryAdressSection(context),
          SizedBox(
            height: deviceHeight * 0.02,
          ),
          _buildPaySection(context),
          SizedBox(
            height: deviceHeight * 0.02,
          ),
          _buildDeliveryOptions(context),
          SizedBox(
            height: deviceHeight * 0.02,
          ),
        ],
      ),
    );
  }

  _buildDeliveryAdressSection(BuildContext context) {
    HomePageViewModel viewModel = Provider.of(context, listen: false);
    double deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.grey, blurRadius: 1, spreadRadius: 1)
      ]),
      padding: Constants.normalPadding(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.scale(
            scale: deviceHeight * 0.0016,
            child: Radio(
              fillColor: const WidgetStatePropertyAll(Colors.red),
              value: 0,
              groupValue: 0,
              onChanged: (value) {},
            ),
          ),
          SizedBox(
            width: deviceHeight * 0.01,
          ),
          Container(
            margin: EdgeInsets.only(top: deviceHeight * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Adresime gönder",
                  style: Constants.getColorBoldStyle(
                      17, Theme.of(context).colorScheme.surface),
                ),
                SizedBox(
                  height: deviceHeight * 0.01,
                ),
                StreamBuilder(
                  stream: viewModel.getSelectedAdress(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.red,
                        ),
                      );
                    } else if (snapshot.requireData.isEmpty) {
                      return Container(
                        padding: Constants.normalPadding(),
                        width: deviceHeight / 2.8,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  color: Colors.grey)
                            ]),
                        child: Row(
                          children: [
                            TextButton(
                                onPressed: () =>
                                    viewModel.goAddAdressPageView(context),
                                child: Text(
                                  "Adres seçin / Ekleyin",
                                  style: Constants.getColorBoldStyle(16,
                                      Theme.of(context).colorScheme.surface),
                                ))
                          ],
                        ),
                      );
                    } else {
                      var adress = snapshot.data!;
                      return Container(
                          padding: Constants.normalPadding(),
                          width: deviceHeight / 2.8,
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    color: Colors.grey)
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    adress[0].baslik,
                                    style: Constants.getColorBoldStyle(18,
                                        Theme.of(context).colorScheme.surface),
                                  ),
                                  TextButton(
                                      onPressed: () => viewModel
                                          .goAddAdressPageView(context),
                                      child: Text(
                                        "Ekle / Değiştir",
                                        style: Constants.getColorBoldStyle(
                                            17, Colors.red),
                                      ))
                                ],
                              ),
                              SizedBox(
                                height: deviceHeight * 0.003,
                              ),
                              Text(adress[0].fullAdress.length > 25
                                  ? "${adress[0].fullAdress.substring(0, 25)}.."
                                  : adress[0].fullAdress),
                            ],
                          ));
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildPaySection(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.grey, blurRadius: 1, spreadRadius: 1)
      ]),
      padding: Constants.littlePadding(),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            margin: const EdgeInsets.only(bottom: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform.scale(
                    scale: deviceHeight * 0.0014,
                    child: Radio(
                      value: 0,
                      groupValue: 0,
                      onChanged: (value) {},
                      fillColor: const WidgetStatePropertyAll(Colors.red),
                    )),
                SizedBox(
                  width: deviceHeight * 0.02,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Kartla öde",
                      style: Constants.getColorBoldStyle(17, Colors.black),
                    ),
                    SizedBox(
                      height: deviceHeight * 0.005,
                    ),
                    StreamBuilder(
                      stream: Provider.of<PaymentPageViewModel>(context,
                              listen: false)
                          .getSelectedCardItem(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.red,
                            ),
                          );
                        } else if (snapshot.data == null) {
                          return GestureDetector(
                              onTap: () => Provider.of<PaymentPageViewModel>(
                                      context,
                                      listen: false)
                                  .addCard(context),
                              child: Container(
                                  padding: Constants.normalPadding(),
                                  width: deviceHeight / 2.8,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            color: Colors.grey)
                                      ]),
                                  child: Text(
                                    "Seçili kart yok, Kart Ekleyin",
                                    style: Constants.getColorBoldStyle(17,
                                        Theme.of(context).colorScheme.surface),
                                  )));
                        } else {
                          var cardModel = snapshot.data!;
                          return Container(
                              padding: Constants.normalPadding(),
                              width: deviceHeight / 2.8,
                              decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        color: Colors.grey)
                                  ]),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(cardModel.cardName),
                                      TextButton(
                                          onPressed: () {},
                                          child: Text(
                                            "Ekle / Değiştir",
                                            style: Constants.getColorBoldStyle(
                                                13, Colors.red),
                                          ))
                                    ],
                                  ),
                                  Text(Constants.getCardNumberFormatter(
                                      cardModel.cardNumber)),
                                ],
                              ));
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: Constants.littlePadding(),
            width: deviceHeight / 2.4,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(spreadRadius: 1, blurRadius: 1, color: Colors.grey)
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Radio(
                      value: 0,
                      groupValue: 0,
                      onChanged: (value) {},
                      fillColor: const WidgetStatePropertyAll(Colors.red),
                    ),
                    Text(
                      "Tek Çekim (Peşin)",
                      style: Constants.getNormalColorTextStyle(
                          15, Theme.of(context).colorScheme.surface),
                    ),
                  ],
                ),
                StreamBuilder(
                  stream:
                      Provider.of<BasketPageViewModel>(context, listen: false)
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
                        style: Constants.getNormalColorTextStyle(
                            14, Theme.of(context).colorScheme.surface),
                      );
                    } else {
                      double? totalPrice = snapshot.data!;
                      return Text(
                        "$totalPrice TL",
                        style: Constants.getNormalColorTextStyle(
                            14, Theme.of(context).colorScheme.surface),
                      );
                    }
                  },
                )
              ],
            ),
          ),
          SizedBox(
            height: deviceHeight * 0.03,
          ),
          const MyRadioTile(
            title: "Bakiyeni kullan kartla öde",
            subTitle: "Peşin",
          ),
          const MyRadioTile(
            title: "Havale ile öde",
            subTitle: "Peşin",
          ),
          const MyRadioTile(
            title: "Alışveriş Kredisi ile öde",
            subTitle: "36 aya varan taksitle al, kolayca öde",
          ),
        ],
      ),
    );
  }

  _buildDeliveryOptions(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.grey, blurRadius: 1, spreadRadius: 1)
      ]),
      padding: Constants.littlePadding(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder(
            stream: Provider.of<BasketPageViewModel>(context, listen: false)
                .getData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                );
              } else {
                var products = snapshot.data!;
                var firstProduct = products.first;
                products.remove(firstProduct);
                return Container(
                    padding: Constants.normalPadding(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Teslimat Seçeneklerim",
                          style: Constants.getColorBoldStyle(17, Colors.black),
                        ),
                        Text("Teslim edilecek ürün/ler",
                            style: Constants.getNormalColorTextStyle(
                                17, Colors.black)),
                        SizedBox(
                          height: deviceHeight * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              radius: 25,
                              child: CachedNetworkImage(
                                imageUrl: firstProduct.productImage,
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover,
                                imageBuilder: (context, imageProvider) => Image(
                                  image: imageProvider,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                                placeholder: (context, url) => Image.asset(
                                  Constants.basketPagePlaceHolderImageAdress,
                                  fit: BoxFit.cover,
                                  height: 40,
                                  width: 40,
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(
                                        Icons.error), // Error widget (optional)
                              ),
                            ),
                            SizedBox(width: deviceHeight * 0.01),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  firstProduct.productName,
                                  style: Constants.getColorBoldStyle(
                                      15, Colors.black),
                                ),
                                SizedBox(height: deviceHeight * 0.01),
                                Container(
                                  padding: Constants.normalPadding(),
                                  width: 300,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 1,
                                            spreadRadius: 1)
                                      ]),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Standart Teslimat  (Kargo bedava)",
                                        style:
                                            Constants.getNormalColorTextStyle(
                                                17, Colors.black),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Tahmini teslim",
                                            style: Constants
                                                .getNormalColorTextStyle(
                                                    14, Colors.black),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: deviceHeight * 0.02,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                Container(
                                    padding: Constants.normalPadding(),
                                    child: products.length > 0
                                        ? Text(
                                            "Diğer ürünler",
                                            style: Constants
                                                .getNormalColorTextStyle(
                                                    18, Colors.black),
                                          )
                                        : const Text("")),
                                Positioned(
                                  right: deviceHeight * 0,
                                  top: 0,
                                  child: products.length > 0
                                      ? CircleAvatar(
                                          radius: deviceHeight * 0.01,
                                          backgroundColor: Colors.redAccent,
                                          child: Text(
                                            products.length.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        )
                                      : const Text(""),
                                ),
                              ],
                            ),
                            Expanded(
                              child: _buildStackedImages(context, products),
                              flex: 3,
                            ),
                          ],
                        )
                      ],
                    ));
              }
            },
          )
        ],
      ),
    );
  }

  _buildListItem(BuildContext context, ProductModel product, int index) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return Positioned(
      left: index *
          deviceHeight *
          0.05, // Üst üste binme etkisi için sol konumunu ayarla
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: ClipOval(
          child: Image(
            image: NetworkImage(product.productImage),
            width: deviceHeight * 0.06,
            height: deviceHeight * 0.06,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Image.asset(
                Constants.basketPagePlaceHolderImageAdress,
                fit: BoxFit.cover,
                height: deviceHeight * 0.03,
                width: deviceHeight * 0.03,
              );
            },
          ),
        ),
      ),
    );
  }

  _buildStackedImages(BuildContext context, List<ProductModel> products) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        SizedBox(
          height: deviceHeight / 15,
          child: Stack(
            children: products.asMap().entries.map<Widget>((entry) {
              // <Widget> ekleyerek tipi belirtiyoruz
              int index = entry.key;
              ProductModel product = entry.value;
              return _buildListItem(context, product, index);
            }).toList(),
          ),
        ),
      ],
    );
  }

  _buildBottomSheet(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return Material(
      shadowColor: Colors.red,
      child: Container(
          padding: Constants.littlePadding(),
          height: deviceHeight / 6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: true,
                    onChanged: (value) {},
                  ),
                  const Expanded(
                      child: Text(
                          "Ön bilgilendirme formunu ve Mesafeli satış sözleşmesi'ni onaylıyorum."))
                ],
              ),
              Divider(
                height: 1,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(
                height: deviceHeight * 0.01,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "ÖDENECEK TUTAR",
                          style:
                              Constants.getNormalColorTextStyle(17, Colors.red),
                        ),
                        StreamBuilder(
                          stream: Provider.of<BasketPageViewModel>(context,
                                  listen: false)
                              .getBasketTotalPrice(),
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Text(snapshot.error.toString());
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              var price = snapshot.data!;
                              return Text(
                                "$price TL",
                                style: Constants.getNormalColorTextStyle(
                                    16, Theme.of(context).colorScheme.surface),
                              );
                            }
                          },
                        )
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: Colors.red,
                            shadowColor: Colors.grey.shade900,
                            elevation: 5),
                        child: Text(
                          "Siparişi Onayla",
                          style: Constants.getColorBoldStyle(18, Colors.white),
                        ))
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
