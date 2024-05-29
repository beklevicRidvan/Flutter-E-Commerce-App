import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';
import '../tools/constants.dart';
import '../view_model/profile_page_view_model.dart';

class ProfileInfoPageView extends StatelessWidget {
  final UserModel userModel;
  const ProfileInfoPageView({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        "ABOUT PROFILE",
        style: Constants.getColorBoldStyle(20, Colors.white),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white, size: 30),
    );
  }

  _buildBody(BuildContext context) {
    ProfilePageViewModel viewModel = Provider.of(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTextRow("PROFIL FOTOGRAFI", context),
        Stack(
          children: [
            Container(
                child: userModel.profile_pic.contains("assets/")
                    ? Image.asset(
                        userModel.profile_pic,
                        fit: BoxFit.cover,
                        width: 300,
                      )
                    : CachedNetworkImage(
                        imageUrl: userModel.profile_pic,
                        placeholder: (context, url) =>
                           const CircularProgressIndicator(color: Colors.red,), // Yükleme sırasında gösterilecek widget
                        errorWidget: (context, url, error) => Image.asset(
                          "assets/profile_placeholder.png",
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                        width: 300,
                        fit: BoxFit.cover,
                      )),
            Positioned(
                right: 0,
                top: 0,
                child: ElevatedButton(
                    onPressed: () {
                      viewModel.showBottomSheet(context);
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.white),
                    child: const Icon(Icons.camera_alt)))
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Stack(
          children: [
            Container(
              width: 300,
              alignment: Alignment.center,
              padding: Constants.normalPadding(),
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(8)),
              child: Text(
                userModel.userName,
                style: Constants.getColorBoldStyle(18, Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              left: 0,
              top: -10,
              child: _buildTextRow("AD", context),
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        Stack(
          children: [
            Container(
              width: 300,
              alignment: Alignment.center,
              padding: Constants.normalPadding(),
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(8)),
              child: Text(
                userModel.userEmail,
                style: Constants.getColorBoldStyle(16, Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              left: 0,
              top: -10,
              child: _buildTextRow("E-POSTA ", context),
            )
          ],
        ),
        const SizedBox(
          height: 15,
        ),
        ButtonBar(
          alignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {
                  viewModel.updateMail(context, userModel);
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: Text(
                  "MAILI DEGISTIR",
                  style: Constants.getColorBoldStyle(
                    16,
                    Theme.of(context).colorScheme.surface,
                  ),
                )),
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: Text(
                  "SIFREYI SIFIRLA",
                  style: Constants.getColorBoldStyle(
                    16,
                    Theme.of(context).colorScheme.surface,
                  ),
                )),
          ],
        ),
      ],
    );
  }

  _buildTextRow(String text, BuildContext context) {
    return Container(
      padding: Constants.littlePadding(),
      child: Text(
        text,
        style: Constants.getColorBoldStyle(
          18,
          text == "PROFIL FOTOGRAFI"
              ? Theme.of(context).colorScheme.inversePrimary
              : Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
