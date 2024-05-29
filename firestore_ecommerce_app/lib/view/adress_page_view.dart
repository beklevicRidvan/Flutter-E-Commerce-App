import 'package:firestore_ecommerce_app/model/adres_model.dart';
import 'package:firestore_ecommerce_app/view_model/home_page_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../tools/constants.dart';

class AdressPageView extends StatelessWidget {
  const AdressPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        "Adreslerim",
        style: TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          )),
    );
  }

  _buildBody(BuildContext context) {
    HomePageViewModel viewModel = Provider.of(context, listen: false);
    return StreamBuilder(
      stream: viewModel.getAdressData(),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Kayıtlı Adresiniz yok",
                  style: Constants.getColorBoldStyle(
                      20, Theme.of(context).colorScheme.surface),
                ),
                ElevatedButton(
                    onPressed: () => viewModel.goAddAdressPageView(context),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Colors.red),
                    child: Text(
                      "ADRES EKLEYİN",
                      style: Constants.getColorBoldStyle(
                          20, Theme.of(context).colorScheme.background),
                    ))
              ],
            ),
          );
        } else {
          var adress = snapshot.data!;
          return ListView.builder(
            itemCount: adress.length,
            itemBuilder: (context, index) {
              return _buildListItem(adress[index], context, index);
            },
          );
        }
      },
    );
  }

  _buildListItem(AdressModel adres, BuildContext context, int index) {
    double deviceHeight = MediaQuery.of(context).size.height;
    HomePageViewModel viewModel = Provider.of(context, listen: false);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: Theme.of(context).colorScheme.primary, width: 0.8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildImageType(adres),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                adres.baslik,
                style: Constants.getColorBoldStyle(17, Colors.black),
              ),
              SizedBox(
                height: deviceHeight * 0.004,
              ),
              SizedBox(
                width: deviceHeight * 0.3,
                child: Text(
                  "${adres.fullAdress} ${adres.binaNo}/${adres.daireNo}",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                ),
              ),
              SizedBox(
                height: deviceHeight * 0.02,
              )
            ],
          ),
          IconButton(
              onPressed: () => viewModel.deleteAdress(adres),
              icon: const Icon(
                Icons.delete_forever_outlined,
                color: Colors.red,
              ))
        ],
      ),
    );
  }

  _buildImageType(AdressModel adresModel) {
    if (adresModel.baslik == "Ev") {
      return Center(
        child: Image.asset(
          "assets/home.png",
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        ),
      );
    } else if (adresModel.baslik == "İş") {
      return Center(
        child: Image.asset(
          "assets/business.png",
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Center(
        child: Image.asset(
          "assets/other.png",
          width: 40,
          height: 40,
          fit: BoxFit.cover,
        ),
      );
    }
  }
}
