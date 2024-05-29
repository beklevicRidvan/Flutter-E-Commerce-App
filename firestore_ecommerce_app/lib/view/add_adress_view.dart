import 'package:firestore_ecommerce_app/tools/components/adress_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../tools/constants.dart';
import '../view_model/adress_view_model.dart';

class AddAdressView extends StatelessWidget {
  const AddAdressView({super.key});

  @override
  Widget build(BuildContext context) {
    Provider.of<AdressViewModel>(context, listen: false).createIcon(context);
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      bottomSheet: _buildShowBottomSheet(context),
      resizeToAvoidBottomInset: false,
    );
  }

  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: const Size(double.infinity, 60),
        child: Consumer<AdressViewModel>(
          builder: (context, viewModel, child) {
            return AppBar(
              title: Text(
                "Yeni Adres Ekle",
                style: Constants.getColorBoldStyle(
                    20, Theme.of(context).colorScheme.inversePrimary),
              ),
              centerTitle: true,
              backgroundColor: Colors.red,
              leading: IconButton(
                  onPressed: () {
                    if (viewModel.isTapped) {
                      viewModel.changeStateTapped(viewModel.isTapped);
                    } else {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  },
                  icon: Icon(
                    viewModel.isTapped ? Icons.arrow_back : Icons.clear,
                    size: 30,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  )),
            );
          },
        ));
  }

  Widget _buildBody(BuildContext context) {
    return _buildMap(context);
  }

  Widget _buildMap(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Stack(
        children: [
          SizedBox(
            height: deviceHeight * 0.8,
            child: Consumer<AdressViewModel>(
              builder: (context, viewModel, child) {
                return GoogleMap(
                  scrollGesturesEnabled: true,
                  mapType: MapType.normal,
                  initialCameraPosition: viewModel.baslangicKonum,
                  onTap: (argument) {
                    viewModel.selectedLocation = argument;
                    viewModel.konumaGit(argument);
                  },
                  onMapCreated: (controller) {
                    viewModel.haritaKontrol.complete(controller);
                  },
                  markers: Set<Marker>.of(viewModel.isaretler),
                );
              },
            ),
          ),
          Positioned(
            bottom: deviceHeight * 0.13,
            right: deviceHeight * 0.01,
            child: IconButton(
              onPressed: () =>
                  Provider.of<AdressViewModel>(context, listen: false)
                      .goCurrentPosition(),
              style: IconButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  elevation: 5,
                  shadowColor: Colors.grey),
              icon: Icon(
                Icons.my_location,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    AdressViewModel viewModel = Provider.of(context, listen: false);

    return GestureDetector(
      onTap: () {
        viewModel.changeStateTapped(viewModel.isTapped);
        viewModel.getFullAdressData();
      },
      child: Container(
        alignment: Alignment.center,
        color: Colors.red,
        height: deviceHeight * 0.08,
        child: Text(
          "Devam",
          style: Constants.getColorBoldStyle(20, Colors.white),
        ),
      ),
    );
  }

  Widget _buildShowBottomSheet(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return Consumer<AdressViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          child: viewModel.isTapped
              ? Container(
                  height: deviceHeight * 0.5,
                  color: Theme.of(context).colorScheme.secondary,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: AdressTextField(
                                  controller: viewModel.mahalleController,
                                  hintText: "",
                                  labelText: "Mahalle / Cadde / Sokak"),
                            )
                          ],
                        ),
                        SizedBox(
                          height: deviceHeight * 0.02,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: AdressTextField(
                                    hintText: "",
                                    labelText: "Bina No",
                                    controller: viewModel.binaNoController)),
                            Expanded(
                                child: AdressTextField(
                                    hintText: "",
                                    labelText: "Kat",
                                    controller: viewModel.katController)),
                            Expanded(
                                child: AdressTextField(
                                    hintText: "",
                                    labelText: "Daire No",
                                    controller: viewModel.daireNoController)),
                          ],
                        ),
                        SizedBox(
                          height: deviceHeight * 0.01,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Divider(
                            height: 1,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 10),
                          child: Text(
                            "Adres Detayları",
                            style: Constants.getColorBoldStyle(
                                18, Theme.of(context).colorScheme.primary),
                          ),
                        ),
                        SizedBox(
                          height: deviceHeight * 0.02,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  viewModel.updateSelectedAddress("Ev");
                                },
                                child: _buildAddressChoiceContainer(
                                    context, "Ev", "home.png"),
                              ),
                              GestureDetector(
                                onTap: () {
                                  viewModel.updateSelectedAddress("İş");
                                },
                                child: _buildAddressChoiceContainer(
                                    context, "İş", "business.png"),
                              ),
                              GestureDetector(
                                onTap: () {
                                  viewModel.updateSelectedAddress("Diğer");
                                },
                                child: _buildAddressChoiceContainer(
                                    context, "Diğer", "other.png"),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: deviceHeight * 0.02,
                        ),
                        AdressTextField(
                            hintText: "",
                            labelText: "Başlık",
                            controller: viewModel.baslikController),
                        GestureDetector(
                          onTap: () {
                            viewModel.changeStateTapped(viewModel.isTapped);
                            viewModel.addAdressInfo();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.all(25),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: Center(
                              child: Text(
                                "Kaydet",
                                style: Constants.getColorBoldStyle(
                                    17, Theme.of(context).colorScheme.surface),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : _buildSaveButton(context),
        );
      },
    );
  }

  Widget _buildAddressChoiceContainer(
      BuildContext context, String title, String assetName) {
    return Consumer<AdressViewModel>(
      builder: (context, viewModel, child) {
        return Container(
            width: 100,
            height: 100,
            alignment: Alignment.center,
            padding: Constants.normalPadding(),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                border: viewModel.selectedAdress == title
                    ? Border.all(color: Colors.red)
                    : null,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                      color: viewModel.selectedAdress == title
                          ? Colors.red
                          : Colors.grey,
                      blurRadius: 5),
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(
                  "assets/$assetName",
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
                Text(
                  title,
                  style: Constants.getColorBoldStyle(
                      16, Theme.of(context).colorScheme.surface),
                ),
              ],
            ));
      },
    );
  }
}
