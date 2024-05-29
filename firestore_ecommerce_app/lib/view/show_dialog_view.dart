import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/adres_model.dart';
import '../tools/constants.dart';
import '../view_model/home_page_view_model.dart';

class CustomDraggableDialog extends StatefulWidget {
  final double initialHeight;
  final double maxHeight;

  const CustomDraggableDialog({
    super.key,
    required this.initialHeight,
    required this.maxHeight,
  });

  @override
  _CustomDraggableDialogState createState() => _CustomDraggableDialogState();
}

class _CustomDraggableDialogState extends State<CustomDraggableDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int selectedValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: widget.initialHeight / widget.maxHeight,
    );
    _animation = Tween<double>(
      begin: widget.initialHeight,
      end: widget.maxHeight,
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              _controller.value -= details.primaryDelta! / widget.maxHeight;
            },
            onVerticalDragEnd: (details) {
              if (details.primaryVelocity! < 0) {
                _controller.forward();
              } else if (details.primaryVelocity! > 0) {
                if (_controller.value < 0.2) {
                  _controller.reverse().then((value) {
                    if (_controller.value == 0.0) {
                      Navigator.of(context).pop();
                    }
                  });
                } else {
                  _controller.reverse();
                }
              } else {
                if (_controller.value > 0.5) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              }
            },
            child: Material(
              color: Theme.of(context).colorScheme.background,
              elevation: 4.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).colorScheme.background,
                ),
                height: _animation.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 40.0,
                      child: Center(
                        child: Container(
                          width: 40.0,
                          height: 4.0,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "Teslimat adresini seç",
                        style: Constants.getColorBoldStyle(16, Colors.grey),
                      ),
                      trailing: GestureDetector(
                        onTap: () => Provider.of<HomePageViewModel>(context,
                                listen: false)
                            .goAdressPageView(context),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text("Adreslerim",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.red,
                                  decorationThickness: 1.3,
                                ))
                          ],
                        ),
                      ),
                    ),
                    StreamBuilder(
                      stream:
                          Provider.of<HomePageViewModel>(context, listen: false)
                              .getAdressData(),
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
                        } else if (snapshot.requireData.isEmpty) {
                          return const Center(
                            child: Text(
                                "Kayıtlı Adresiniz bulunmuyor,lütfen adres ekleyin"),
                          );
                        } else {
                          List<AdressModel> adress = snapshot.data!;
                          return Expanded(
                            child: ListView.builder(
                              itemCount: adress.length,
                              itemBuilder: (context, index) {
                                return _buildListItem(
                                    adress[index], context, index);
                              },
                            ),
                          );
                        }
                      },
                    ),
                    GestureDetector(
                      onTap: () {
                        Provider.of<HomePageViewModel>(context, listen: false)
                            .goAddAdressPageView(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 20),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.add,
                              size: 30,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 2),
                            Container(
                              width: 1,
                              height: 20,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 15),
                            Text(
                              "Yeni Adres Ekle",
                              style:
                                  Constants.getColorBoldStyle(17, Colors.red),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildListItem(AdressModel adres, BuildContext context, int index) {
    HomePageViewModel viewModel = Provider.of(context, listen: false);
    double deviceHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 0.8, color: Theme.of(context).colorScheme.primary))),
        child: Row(
          children: [
            StreamBuilder(
              stream: viewModel.getSelectedAdressId(),
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
                  String? selectedAdressId = snapshot.data;
                  return Radio<String?>(
                    fillColor: const WidgetStatePropertyAll(Colors.red),
                    value: adres.adressId,
                    groupValue: selectedAdressId,
                    onChanged: (value) {
                      setState(() {
                        selectedAdressId = value;
                      });
                      viewModel.updateSelectedAdress(value);
                    },
                  );
                }
              },
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildImageType(adres),
                      SizedBox(
                        width: deviceHeight * 0.01,
                      ),
                      Text(
                        adres.baslik,
                        style: Constants.getColorBoldStyle(
                            17, Theme.of(context).colorScheme.surface),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${adres.fullAdress} No:${adres.binaNo}/${adres.daireNo}", // Adres detaylarını buraya ekleyin
                    style: Constants.getNormalColorTextStyle(15,
                        Theme.of(context).colorScheme.surface.withOpacity(0.8)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildImageType(AdressModel adresModel) {
    if (adresModel.baslik == "Ev") {
      return Center(
        child: Image.asset(
          "assets/home.png",
          width: 30,
          height: 30,
          fit: BoxFit.cover,
        ),
      );
    } else if (adresModel.baslik == "İş") {
      return Center(
        child: Image.asset(
          "assets/business.png",
          width: 30,
          height: 30,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Center(
        child: Image.asset(
          "assets/other.png",
          width: 30,
          height: 30,
          fit: BoxFit.cover,
        ),
      );
    }
  }
}
