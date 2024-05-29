import '../model/adres_model.dart';
import '../model/card_model.dart';
import '../model/product_model.dart';
import '../model/user_model.dart';

abstract class DatabaseBase {
  Future<dynamic> getCategories();

  Stream<List<UserModel>> getUser();

  Stream<List<AdressModel>> getUserAdress();
  Stream<List<AdressModel>> getUsersSelectedAdress();
  Future<dynamic> addAdress(AdressModel adressModel);
  Future<void> updateAdress(AdressModel adressModel);
  Future<void> deleteAdress(AdressModel adressModel);
  Future<void> setSelectedValue(String? newSelectedAddressId);
  Stream<String?> getSelectedAdressId();

  Stream<List<ProductModel>> getProducts(dynamic categoryId);
  Future<dynamic> addProductForBasket(ProductModel productModel);
  Stream<List<ProductModel>> getSearchingData(
      {dynamic categoryId, required String wantedValue});

  Stream<List<ProductModel>> getProductsInBasket();
  Future<dynamic> deleteProductForBasket(ProductModel productModel);
  Future<int> basketCount({dynamic categoryId});
  Stream<double?> getBasketTotalPrice();

  Future<dynamic> addFavorites(ProductModel productModel);
  Stream<List<ProductModel>> getProductsInFavorites();
  Future<dynamic> deleteFavorites(ProductModel productModel);

  Stream<List<ProductModel>> isFavorited(ProductModel productModel);

  Stream<List<CardModel>> getSavedCards();
  Future<dynamic> addCard(CardModel cardModel);
  Future<void> deleteCard(CardModel cardModel);
  Future<void> updateCard(CardModel cardModel);
  Future<void> setSelectedCardValue(String? newSelectedCardId);
  Stream<String?> getSelectedCardId();
  Stream<CardModel?> getSelectedCard();


}
