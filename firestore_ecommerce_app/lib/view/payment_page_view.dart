import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../model/card_model.dart';
import '../tools/constants.dart';
import '../tools/controller/navigation_controller.dart';
import '../view_model/payment_page_view_model.dart';

class PaymentPageView extends StatelessWidget with NavigationController {
  const PaymentPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        "PAYMENT INFO",
        style: Constants.getColorBoldStyle(20, Colors.white),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white, size: 30),
    );
  }

  _buildBody(BuildContext context) {
    return StreamBuilder(
      stream:
          Provider.of<PaymentPageViewModel>(context, listen: false).getData(),
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
          return _buildEmptySection(context);
        } else {
          List<CardModel> cards = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
                child: Text(
                  "KAYITLI KARTLARIM",
                  style: Constants.getColorBoldStyle(
                      17, Theme.of(context).colorScheme.surface),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 16, right: 16, top: 20),
                  child: ListView.builder(
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      return _buildListItem(cards[index], context);
                    },
                  ),
                ),
              ),
              Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  child: _buildAddNewCard(context)),
            ],
          );
        }
      },
    );
  }

  _buildEmptySection(BuildContext context) {
    double deviceHeigth = MediaQuery.of(context).size.height;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _buildAddNewCard(context),
          SizedBox(
            height: deviceHeigth / 5,
          ),
          Column(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: const Icon(
                  Icons.credit_card,
                  color: Colors.red,
                  size: 80,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Kayıtlı Kartınız Bulunmamaktadır",
                style: Constants.getColorBoldStyle(
                    17, Theme.of(context).colorScheme.inversePrimary),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text("Alışverişe Devam Et",
                      style: Constants.getColorBoldStyle(
                          20, Theme.of(context).colorScheme.inversePrimary)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Container _buildAddNewCard(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.tertiary,
      child: ListTile(
        onTap: () => Provider.of<PaymentPageViewModel>(context, listen: false)
            .addCard(context),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        leading: CircleAvatar(
          backgroundColor: Colors.red,
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.inversePrimary,
            size: 30,
          ),
        ),
        title: Text(
          "Yeni Kart Ekle",
          style: Constants.getColorBoldStyle(
              18, Theme.of(context).colorScheme.inversePrimary),
        ),
        trailing: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: Icon(
            Icons.arrow_forward_ios,
            color: Theme.of(context).colorScheme.inversePrimary,
            size: 15,
          ),
        ),
      ),
    );
  }

  _buildListItem(CardModel card, BuildContext context) {
    PaymentPageViewModel viewModel = Provider.of(context, listen: false);
    return Slidable(
      endActionPane: ActionPane(motion: const ScrollMotion(), children: [
        IconButton(
            onPressed: () {
              viewModel.deleteCard(context, card);
            },
            style: IconButton.styleFrom(
                backgroundColor: Colors.red, shape: const CircleBorder()),
            icon: const Icon(Icons.clear))
      ]),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            boxShadow: const [
              BoxShadow(color: Colors.black, blurRadius: 1, spreadRadius: 1),
              BoxShadow(
                  color: Colors.black12, blurRadius: 0.6, spreadRadius: 0.6)
            ]),
        child: Row(

          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder(
              stream: viewModel.getSelectedCardId(),
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
                } else {
                  String? selectedCardId = snapshot.data;
                  return SizedBox(
                    width: 100,
                    height: 100,
                    child: Radio<String?>(
                      fillColor: const WidgetStatePropertyAll(Colors.red),
                      value: card.cardId,
                      groupValue: selectedCardId,
                      onChanged: (value) {
                        selectedCardId = value;

                        viewModel.setSelectedValue(value);
                      },
                    ),
                  );
                }
              },
            ),
            Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  card.cardName,
                  style: Constants.getNormalTextStyle(20),
                ),
                Text(Constants.getCardNumberFormatter(card.cardNumber))
              ],
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.arrow_right,
                  size: 30,
                )),
          ],
        ),
      ),
    );
  }
}
