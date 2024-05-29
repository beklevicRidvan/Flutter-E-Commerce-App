import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/adres_model.dart';
import '../tools/components/my_drawer.dart';
import '../tools/constants.dart';
import '../tools/controller/navigation_controller.dart';
import '../view_model/home_page_view_model.dart';
import '../view_model/profile_page_view_model.dart';

class HomePageView extends StatelessWidget with NavigationController {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(context),
      drawer: const MyDrawer(),
    );
  }

  _buildAppBar(BuildContext context) {
    return PreferredSize(
        preferredSize: Size(double.infinity,
            Provider.of<HomePageViewModel>(context).getSize(context)),
        child: Consumer<HomePageViewModel>(
          builder: (context, value, child) {
            return AppBar(

              title: Image.asset("assets/app_logo.png"),
              iconTheme: const IconThemeData(color: Colors.white, size: 40),
/*
              actions: [
                IconButton(
                    onPressed: () => Provider.of<ProfilePageViewModel>(context,
                            listen: false)
                        .logOut(context),
                    icon: const Icon(Icons.logout))
              ],


 */


              bottom: PreferredSize(
                  preferredSize: const Size(double.infinity, 100),
                  child: value.selectedIndex == 0
                      ? ListTile(
                          onTap: () => goDialog(context),
                          tileColor: Colors.redAccent.shade100,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 40),
                          title: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              StreamBuilder(
                                stream: value.getSelectedAdress(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Center(
                                      child: Text(snapshot.error.toString()),
                                    );
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                      ),
                                    );
                                  } else if (snapshot.requireData.isEmpty) {
                                    return _buildAdressRow(
                                        context, "Adres", "bulunmuyor,Ekleyin");
                                  } else {
                                    List<AdressModel> adress = snapshot.data!;
                                    return _buildAdressRow(context,
                                        adress[0].baslik, adress[0].fullAdress);
                                  }
                                },
                              )
                            ],
                          ),
                          trailing: Icon(
                            Icons.arrow_drop_down,
                            size: 40,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                        )
                      : Container()),
            );
          },
        ));
  }

  Consumer _buildBody() {
    return Consumer<HomePageViewModel>(
      builder: (context, viewModel, child) {
        return PageView.builder(
          physics: const NeverScrollableScrollPhysics(),
          controller: viewModel.controller,
          itemCount: viewModel.widgetList.length,
          itemBuilder: (context, index) {
            return viewModel.widgetList[index];
          },
        );
      },
    );
  }

  Consumer _buildBottomNavigationBar(BuildContext context) {
    return Consumer<HomePageViewModel>(
      builder: (context, viewModel, child) {
        return BottomNavigationBar(
            selectedItemColor: Constants.bottomSelectedItemColor,
            iconSize: 30,
            selectedIconTheme: const IconThemeData(size: 40),
            onTap: (value) {
              viewModel.changeIndex(value);
              viewModel.controller.animateToPage(value,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutBack);
            },
            currentIndex: viewModel.selectedIndex,
            type: BottomNavigationBarType.fixed,
            items: [
              _buildBottomNavigationBarItem(
                  const Icon(
                    Icons.home_outlined,
                  ),
                  const Icon(Icons.home)),
              _buildBottomNavigationBarItem(
                  const Icon(
                    Icons.favorite_border,
                  ),
                  const Icon(Icons.favorite)),
              _buildBottomNavigationBarItem(
                  const Icon(
                    Icons.shopping_bag_outlined,
                  ),
                  const Icon(Icons.shopping_bag)),
              _buildBottomNavigationBarItem(
                  const Icon(
                    Icons.person_2_outlined,
                  ),
                  const Icon(Icons.person)),
            ]);
      },
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      Icon icon, Icon activedIcon) {
    return BottomNavigationBarItem(
        icon: icon, label: "", activeIcon: activedIcon);
  }

  Widget _buildAdressRow(
      BuildContext context, String title, String description) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          title,
          style: Constants.getColorBoldStyle(
              18, Theme.of(context).colorScheme.surface),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          description.length > 25
              ? "${description.substring(0, 25)}..."
              : description,
          style: Constants.getNormalTextStyle(16),
        ),
      ],
    );
  }
}
