import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firestore_ecommerce_app/model/user_model.dart';
import 'package:image_picker/image_picker.dart';

import '../auth_base_service.dart';

class AuthService extends AuthBaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future signInWithEmailAndPassword(
      String email, String password, UserModel userModel) async {
    try {
      var userCollectionRef = await _firestore
          .collection("users")
          .where("userEmail", isEqualTo: email)
          .get();

      if (userCollectionRef.docs.isNotEmpty) {
        UserCredential user = await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        String currentUserID = user.user!.uid;
        var favoriteQuery = await _firestore
            .doc("users/$currentUserID")
            .collection("favorites")
            .doc(currentUserID)
            .set({"favoriteId": currentUserID}, SetOptions(merge: true));
        var basketQuery = await _firestore
            .doc("users/$currentUserID")
            .collection("basket")
            .doc(currentUserID)
            .set({"basketId": currentUserID},
                SetOptions(merge: true)).whenComplete(() => favoriteQuery);

        await _firestore.collection("users").doc(currentUserID).set(
            {"lastLogged": Timestamp.now()},
            SetOptions(merge: true)).whenComplete(() => basketQuery);
        if (user.user!.emailVerified == false) {
          user.user!.sendEmailVerification();
        }
        return user;
      } else {
        throw Exception("SİSTEMDE KAYDINIZ BULUNMUYOR LÜTFEN KAYIT OLUN");
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  @override
  Future signUpWithEmailAndPassword(String email, String password,
      String fullName, UserModel userModel) async {
    try {
      UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      String currentUserID = user.user!.uid;

      var favoriteQuery = await _firestore
          .doc("users/$currentUserID")
          .collection("favorites")
          .doc(currentUserID)
          .set({"favoriteId": currentUserID}, SetOptions(merge: true));
      var basketQuery = await _firestore
          .doc("users/$currentUserID")
          .collection("basket")
          .doc(currentUserID)
          .set({"basketId": currentUserID},
              SetOptions(merge: true)).whenComplete(() => favoriteQuery);

      await _firestore
          .collection("users")
          .doc(currentUserID)
          .set(userModel.toMap(key: currentUserID, newUserName: fullName),
              SetOptions(merge: true))
          .whenComplete(() => basketQuery);

      if (user.user!.emailVerified == false) {
        user.user!.sendEmailVerification();
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  @override
  Future<void> takePicture() async {
    final ImagePicker picker = ImagePicker();

    User? user = _auth.currentUser;
    if (user != null) {
      XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        var profileRef = _storage.ref("users/profile_image/${user.uid}");
        var task = profileRef.putFile(
            File(file.path), SettableMetadata(contentType: 'image/png'));
        await task.whenComplete(() async {
          var url = await profileRef.getDownloadURL();
          await _firestore.collection("users").doc(user.uid).set({
            "profile_pic": url.toString(),
          }, SetOptions(merge: true));
        });
      }
    }
  }

  @override
  Future<void> takePictureByCamera() async {
    final ImagePicker picker = ImagePicker();

    User? user = _auth.currentUser;
    if (user != null) {
      XFile? file = await picker.pickImage(source: ImageSource.camera);
      if (file != null) {
        var profileRef = _storage.ref("users/profile_image/${user.uid}");
        var task = profileRef.putFile(
            File(file.path), SettableMetadata(contentType: 'image/png'));
        await task.whenComplete(() async {
          var url = await profileRef.getDownloadURL();
          await _firestore.collection("users").doc(user.uid).set({
            "profile_pic": url.toString(),
          }, SetOptions(merge: true));
        });
      }
    }
  }

  @override
  Future changeEmail(String newEmail, String newUsername) async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        if (currentUser.emailVerified) {
          await currentUser.verifyBeforeUpdateEmail(newEmail);

          await _firestore.collection("users").doc(currentUser.uid).update({
            "userEmail": newEmail,
            "userName": newUsername,
          });
        } else {
          print("E-mail doğrulama gönderildi");
          currentUser.sendEmailVerification();
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future resetPassword() async {
    throw UnimplementedError();
  }

  @override
  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }




}
