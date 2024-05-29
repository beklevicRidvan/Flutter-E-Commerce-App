import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_ecommerce_app/model/full_adress_model.dart';

import '../base/api_base.dart';
import '../base/auth_base.dart';
import '../base/database_base.dart';
import '../model/adres_model.dart';
import '../model/card_model.dart';
import '../model/product_model.dart';
import '../model/user_model.dart';
import '../service/auth/auth_service.dart';
import '../service/firestore/firestore_service.dart';
import '../service/http/adress_service.dart';
import '../tools/locator.dart';

class DatabaseRepository implements DatabaseBase, AuthBase, ApiBase {
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AuthService _authService = locator<AuthService>();
  final HttpApiService _apiService = locator<HttpApiService>();

  @override
  Future addFavorites(ProductModel productModel) async {
    // TODO: implement addFavorites
    return await _firestoreService.addFavorites(productModel);
  }

  @override
  Future addProductForBasket(ProductModel productModel) async {
    // TODO: implement addProductForBasket
    return await _firestoreService.addProductForBasket(productModel);
  }

  @override
  Future deleteFavorites(ProductModel productModel) async {
    await _firestoreService.deleteFavorites(productModel);
  }

  @override
  Future deleteProductForBasket(ProductModel productModel) async {
    await _firestoreService.deleteProductForBasket(productModel);
  }

  @override
  Stream<List<ProductModel>> getProducts(dynamic categoryId) {
    return _firestoreService.getProducts(categoryId);
  }

  @override
  Stream<List<ProductModel>> getProductsInBasket() {
    return _firestoreService.getProductsInBasket();
  }

  @override
  Stream<List<ProductModel>> getProductsInFavorites() {
    return _firestoreService.getProductsInFavorites();
  }

  @override
  Future getCategories() async {
    return await _firestoreService.getCategories();
  }

  @override
  Stream<List<UserModel>> getUser() {
    return _firestoreService.getUser();
  }

  @override
  Future signInWithEmailAndPassword(
      String email, String password, UserModel userModel) async {
    await _authService.signInWithEmailAndPassword(email, password, userModel);
  }

  @override
  Future<void> signOut() async {
    await _authService.signOut();
  }

  @override
  Future signUpWithEmailAndPassword(String email, String password,
      String fullName, UserModel userModel) async {
    await _authService.signUpWithEmailAndPassword(
        email, password, fullName, userModel);
  }

  @override
  Future<int> basketCount({categoryId}) async {
    return await _firestoreService.basketCount();
  }

  @override
  Stream<List<ProductModel>> isFavorited(ProductModel productModel) {
    return _firestoreService.isFavorited(productModel);
  }

  @override
  Stream<List<ProductModel>> getSearchingData(
      {categoryId, required String wantedValue}) {
    return _firestoreService.getSearchingData(wantedValue: wantedValue);
  }

  @override
  Future<void> takePicture() async {
    await _authService.takePicture();
  }

  @override
  Future<void> takePictureByCamera() async {
    await _authService.takePictureByCamera();
  }

  @override
  Future changeEmail(String newEmail, String newUsername) async {
    await _authService.changeEmail(newEmail, newUsername);
  }

  @override
  Future resetPassword() async {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  @override
  Future<User?> getCurrentUser() {
    return _authService.getCurrentUser();
  }

  @override
  Future addCard(CardModel cardModel) async {
    return await _firestoreService.addCard(cardModel);
  }

  @override
  Future<void> deleteCard(CardModel cardModel) async {
    await _firestoreService.deleteCard(cardModel);
  }

  @override
  Stream<List<CardModel>> getSavedCards() {
    return _firestoreService.getSavedCards();
  }

  @override
  Future<void> updateCard(CardModel cardModel) async {
    await _firestoreService.updateCard(cardModel);
  }

  @override
  Future<dynamic> addAdress(AdressModel adressModel) async {
    return await _firestoreService.addAdress(adressModel);
  }

  @override
  Future<void> deleteAdress(AdressModel adressModel) async {
    await _firestoreService.deleteAdress(adressModel);
  }

  @override
  Stream<List<AdressModel>> getUserAdress() {
    return _firestoreService.getUserAdress();
  }

  @override
  Future<void> updateAdress(AdressModel adressModel) async {
    await _firestoreService.updateAdress(adressModel);
  }

  @override
  Stream<List<AdressModel>> getUsersSelectedAdress() {
    return _firestoreService.getUsersSelectedAdress();
  }



  @override
  Future<List<FullAdressModel>> getAdress(double lat, double lon) async {
    return await _apiService.getAdress(lat,lon);
  }

  @override
  Future<void> setSelectedValue(String? newSelectedAddressId)async {
    await _firestoreService.setSelectedValue(newSelectedAddressId);
  }

  @override
  Stream<String?> getSelectedAdressId() {
    // TODO: implement getSelectedAdressId
    return _firestoreService.getSelectedAdressId();
  }

  @override
  Stream<double?> getBasketTotalPrice() {
    return _firestoreService.getBasketTotalPrice();
  }

  @override
  Stream<String?> getSelectedCardId() {
   return _firestoreService.getSelectedCardId();
  }

  @override
  Future<void> setSelectedCardValue(String? newSelectedCardId) async{
    return await _firestoreService.setSelectedCardValue(newSelectedCardId);
  }

  @override
  Stream<CardModel?> getSelectedCard() {
    return _firestoreService.getSelectedCard();
  }



}
