import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';
import '../tools/constants.dart';
import '../tools/controller/navigation_controller.dart';
import '../view_model/profile_page_view_model.dart';

class ProfilePageView extends StatelessWidget with NavigationController {
  const ProfilePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserModel>>(
      stream:
          Provider.of<ProfilePageViewModel>(context, listen: false).getData(),
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
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        } else {
          List<UserModel> value = snapshot.data!;
          return Column(
            children: [
              Padding(
                padding: Constants.littlePadding(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 40,
                      child: Text(
                        Constants.getFirstLetter(value[0].userName),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                    ),
                    const SizedBox(
                      width: 25,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          value[0].userName,
                          style: Constants.getNormalTextStyle(18),
                        ),
                        Text(
                          value[0].userEmail,
                          style: Constants.productMoneyTextStyle(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: SizedBox(
                      height: 300, child: _buildListView(context, value[0])))
            ],
          );
        }
      },
    );
  }

  ListView _buildListView(BuildContext context, UserModel userModel) {
    List<void Function()?> functions = [
      () => goAboutProfilePage(context, userModel),
      () => goBasketPage(context),
      () {},
      () => goFavoritesPage(context),
      () {},
      () => goPaymentPage(context),
    ];
    return ListView.builder(
      itemCount: Constants.profileInfo.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: Constants.littlePadding(),
          child: Card(
            color: Theme.of(context).colorScheme.secondary,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 30),
              onTap: functions[index],
              leading: Constants.profileIcons[index],
              title: Text(Constants.profileInfo[index]),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 20,
              ),
            ),
          ),
        );
      },
    );
  }
}
