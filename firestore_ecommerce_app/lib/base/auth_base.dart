import 'package:firebase_auth/firebase_auth.dart';

import '../model/user_model.dart';

abstract class AuthBase{
  Future<dynamic> signInWithEmailAndPassword(String email,String password,UserModel userModel);
  Future<dynamic> signUpWithEmailAndPassword(String email,String password,String fullName,UserModel userModel);
  Future<void> signOut();
  Future<dynamic> changeEmail(String newEmail,String newUsername);



  Future<User?> getCurrentUser();
  Future<dynamic> resetPassword();
  Future<void> takePicture();
  Future<void> takePictureByCamera();
}