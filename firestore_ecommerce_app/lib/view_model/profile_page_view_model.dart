import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/user_model.dart';
import '../repository/database_repository.dart';
import '../tools/locator.dart';

class ProfilePageViewModel with ChangeNotifier {
  final DatabaseRepository _repository = locator<DatabaseRepository>();

  Stream<List<UserModel>> getData() {
    Future.delayed(const Duration(seconds: 2));
    return _repository.getUser();
  }

  void takePicture(BuildContext context) async {
    try {
      await _repository.takePicture();
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  @override
  void dispose() async {
    User? user = await _repository.getCurrentUser();
    if (user == null) {
      getData().distinct();
    }
    // TODO: implement dispose
    super.dispose();
  }

  void takePictureByCamera(BuildContext context) async {
    try {
      await _repository.takePictureByCamera();
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  void logOut(BuildContext context) async {
    try {
      await _repository.signOut();
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: MediaQuery.of(context).size.height * 0.2,
                height: 3,
                color: Theme.of(context).colorScheme.surface,
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 50),
                onTap: () => takePicture(context),
                title: const Text("FOTOĞRAF YÜKLE"),
                trailing: const Icon(Icons.photo),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 50),
                onTap: () => takePictureByCamera(context),
                title: const Text("KAMERADAN ÇEK"),
                trailing: const Icon(Icons.camera),
              ),
            ],
          ),
        );
      },
    );
  }

  void updateMail(BuildContext context, UserModel userModel) async {
    try {
      List<String>? result = await updateMailDialog(context, userModel);
      if (result != null) {
        String newEmail = result[0];
        String newUsername = result[1];
        await _repository.changeEmail(newEmail, newUsername);
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  Future<List<String>?> updateMailDialog(
      BuildContext context, UserModel userModel) {
    return showDialog<List<String>?>(
      context: context,
      builder: (context) {
        TextEditingController newMailController =
            TextEditingController(text: userModel.userEmail);
        TextEditingController newUsernameController =
            TextEditingController(text: userModel.userName);
        return AlertDialog(
          title: const Text("UPDATE E-MAİL"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("New Email"),
              TextField(
                controller: newMailController,
              ),
              const Text("New Username"),
              TextField(
                controller: newUsernameController,
              ),
            ],
          ),
          actions: [
            ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("IPTAL")),
                ElevatedButton(
                    onPressed: () {
                      if (EmailValidator.validate(newMailController.text) &&
                          newUsernameController.text.isNotEmpty) {
                        Navigator.pop(context, [
                          newMailController.text,
                          newUsernameController.text
                        ]);
                      }
                    },
                    child: const Text("KAYDET")),
              ],
            ),
          ],
        );
      },
    );
  }
}
