import 'package:cached_network_image/cached_network_image.dart';
import 'package:firestore_ecommerce_app/tools/controller/navigation_controller.dart';
import 'package:firestore_ecommerce_app/view_model/profile_page_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/user_model.dart';
import '../../view_model/home_page_view_model.dart';
import '../themes/theme_provider.dart';

class MyDrawer extends StatelessWidget with NavigationController {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    ProfilePageViewModel viewModel = Provider.of(context, listen: false);
    return Drawer(

      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                StreamBuilder<List<UserModel>>(
                  stream: viewModel.getData(),
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
                    }

                    else {
                      List<UserModel> users = snapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.only(
                          top: 50,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildProfilePage(users[0],context),
                                Column(
                                  children: [
                                    Text(
                                      users[0].userName ?? "placeholder",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              users[0].userEmail,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Divider(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                buildRow(() => Navigator.pop(context), "H O M E", context),
                const SizedBox(
                  height: 15,
                ),
                StreamBuilder<List<UserModel>>(
                  stream: viewModel.getData(),
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
                    } else {
                      List<UserModel> users = snapshot.data!;
                      return AnimatedContainer(
                        duration: const Duration(seconds: 5),
                        curve: Curves.easeInToLinear,
                        child: buildRow(() {
                          goAboutProfilePage(context, users[0]);
                        }, "P R O F I L E", context),
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                _buildModeSwitch(),
              ],
            ),
          ),
          buildRow(() => viewModel.logOut(context), "L O G O U T", context)
        ],
      ),
    );
  }

  Widget buildRow(VoidCallback onTap, String text, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 20, vertical: text == "L O G O U T" ? 50 : 5),
      child: InkWell(
        onTap: () {
          onTap();
          text == "L O G O U T"
              ? Provider.of<HomePageViewModel>(context, listen: false)
                  .selectedIndex = 3
              : () {};
        },
        child: Row(
          mainAxisAlignment: text == "L O G O U T"
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            text == "L O G O U T"
                ? const Icon(Icons.logout)
                : const Icon(Icons.arrow_right),
            SizedBox(
              width: text == "L O G O U T" ? 15 : 0,
            ),
            Text(
              text,
              style: const TextStyle(fontSize: 18),
            )
          ],
        ),
      ),
    );
  }

  _buildProfilePage(UserModel value,BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: 30,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: value.profile_pic ?? '',
          errorWidget: (context, url, error) => const Icon(Icons.error_outline),
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          placeholder: (context, url) =>  CircularProgressIndicator(
            color: Theme.of(context).colorScheme.surface,
          ),
        ),
      ),
    );
  }

  Padding _buildModeSwitch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Consumer<ThemeProvider>(
        builder: (context, value, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "DARK MODE",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(
                width: 20,
              ),
              CupertinoSwitch(
                value: value.isDarkMode,
                onChanged: (deger) => value.toggleTheme(),
              )
            ],
          );
        },
      ),
    );
  }
}
