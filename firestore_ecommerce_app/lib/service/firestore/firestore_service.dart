import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../model/adres_model.dart';
import '../../model/basket_model.dart';
import '../../model/card_model.dart';
import '../../model/favorite_model.dart';
import '../../model/product_model.dart';
import '../../model/user_model.dart';
import '../database_base_service.dart';

class FirestoreService extends DatabaseBaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future addFavorites(ProductModel productModel) async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        String currentUserId = currentUser.uid;

        var favoritesRef = await _firestore
            .doc("users/$currentUserId")
            .collection("favorites")
            .get();
        var maps = favoritesRef.docs;
        var favoriteList = maps
            .map((e) => FavoriteModel.fromMap(key: e.id, e.data()))
            .toList();

        return await _firestore
            .doc("users/$currentUserId")
            .collection("favorites")
            .doc(favoriteList[0].favoriteId)
            .collection("products")
            .doc(productModel.productId)
            .set(productModel.toMap(
                categoryKey: productModel.productCategory,
                productKey: productModel.productId));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future addProductForBasket(ProductModel productModel) async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        String currentUserID = currentUser.uid;

        var basketRef = await _firestore
            .doc("users/$currentUserID")
            .collection("basket")
            .get();
        var maps = basketRef.docs;
        var basketList =
            maps.map((e) => BasketModel.fromMap(key: e.id, e.data())).toList();
        return await _firestore
            .doc("users/$currentUserID")
            .collection("basket")
            .doc(basketList[0].basketId)
            .collection("products")
            .doc(productModel.productId)
            .set(productModel.toMap(
                productKey: productModel.productId,
                categoryKey: productModel.productCategory));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future deleteFavorites(ProductModel productModel) async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        String currentUserId = currentUser.uid;

        var basketRef = await _firestore
            .doc("users/$currentUserId")
            .collection("favorites")
            .get();
        var maps = basketRef.docs;
        var favoritesList = maps
            .map((e) => FavoriteModel.fromMap(key: e.id, e.data()))
            .toList();
        await _firestore
            .doc("users/$currentUserId")
            .collection("favorites")
            .doc(favoritesList[0].favoriteId)
            .collection("products")
            .doc("${productModel.productId}")
            .delete();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future deleteProductForBasket(ProductModel productModel) async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        String currentUserID = currentUser.uid;
        var favoritesRef = await _firestore
            .doc("users/$currentUserID")
            .collection("favorites")
            .get();
        var maps = favoritesRef.docs;
        var basketList =
            maps.map((e) => BasketModel.fromMap(key: e.id, e.data())).toList();
        await _firestore
            .doc("users/$currentUserID")
            .collection("basket")
            .doc(basketList[0].basketId)
            .collection("products")
            .doc("${productModel.productId}")
            .delete();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Stream<List<ProductModel>> getProducts(dynamic categoryId) {
    try {
      return _firestore
          .doc("categories/$categoryId")
          .collection("products")
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((e) => ProductModel.fromMap(productKey: e.id, e.data()))
              .toList());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Stream<List<ProductModel>> getProductsInBasket() async* {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        String currentUserId = currentUser.uid;
        var basketRef = await _firestore
            .doc("users/$currentUserId")
            .collection("basket")
            .get();
        var maps = basketRef.docs;
        var basketList =
            maps.map((e) => BasketModel.fromMap(key: e.id, e.data())).toList();

        dynamic basketId = basketList[0].basketId;

        yield* _firestore
            .doc("users/$currentUserId")
            .collection("basket")
            .doc(basketId)
            .collection("products")
            .snapshots()
            .map((snapshots) => snapshots.docs
                .map((e) => ProductModel.fromMap(productKey: e.id, e.data()))
                .toList());
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Stream<List<ProductModel>> getProductsInFavorites() async* {
    try {
      User? currentUser = _auth.currentUser;

      String currentUserId = currentUser!.uid;
      var favoritesRef = await _firestore
          .doc("users/$currentUserId")
          .collection("favorites")
          .get();
      var maps = favoritesRef.docs;
      var favoriteList =
          maps.map((e) => FavoriteModel.fromMap(key: e.id, e.data())).toList();
      dynamic favoriteId = favoriteList[0].favoriteId;
      yield* _firestore
          .doc("users/$currentUserId")
          .collection("favorites")
          .doc(favoriteId)
          .collection("products")
          .snapshots()
          .map((snapshots) => snapshots.docs
              .map((e) => ProductModel.fromMap(productKey: e.id, e.data()))
              .toList());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future getCategories() async {
    try {
      List<CategoryModel> categories = [];
      var collectionRef = await _firestore
          .collection("categories")
          .orderBy("categoryName")
          .get();

      var maps = collectionRef.docs;
      categories =
          maps.map((e) => CategoryModel.fromMap(e.data(), key: e.id)).toList();
      return categories;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Stream<List<UserModel>> getUser() {
    try {
      User? currentUser = _auth.currentUser;

      return _firestore
          .collection("users")
          .where("userId", isEqualTo: currentUser!.uid)
          .snapshots()
          .map((event) => event.docs
              .map((e) => UserModel.fromMap(e.data(), key: e.id))
              .toList());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Stream<List<ProductModel>> isFavorited(ProductModel productModel) async* {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        String userID = currentUser.uid;

        var favoritesRef =
            await _firestore.doc("users/$userID").collection("favorites").get();
        var maps = favoritesRef.docs;
        var favoriteList = maps
            .map((e) => FavoriteModel.fromMap(key: e.id, e.data()))
            .toList();
        yield* _firestore
            .doc("users/$userID")
            .collection("favorites")
            .doc(favoriteList[0].favoriteId)
            .collection("products")
            .where("productId", isEqualTo: productModel.productId)
            .snapshots()
            .map((event) => event.docs
                .map((e) => ProductModel.fromMap(productKey: e.id, e.data()))
                .toList());
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<int> basketCount({dynamic categoryId}) async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        String userId = currentUser.uid;
        List<BasketModel> basket = [];
        var basketRef =
            await _firestore.doc("users/$userId").collection("basket").get();
        var maps = basketRef.docs;

        basket =
            maps.map((e) => BasketModel.fromMap(key: e.id, e.data())).toList();
        var element = await _firestore
            .doc("users/$userId")
            .collection("basket")
            .doc(basket[0].basketId)
            .collection("products")
            .where("productCategoryId", isEqualTo: categoryId)
            .get();

        /*
      var element = await _firestore
          .doc("users/$userId")
          .collection("basket")
          .doc(basket[0].basketId)
          .collection("products")
          .where("productCategoryId", isEqualTo: categoryId)
          .get();

       */
        return element.size;
      }
      return -1;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Stream<List<ProductModel>> getSearchingData({
    dynamic categoryId,
    required String wantedValue,
  }) {
    try {
      return _firestore
          .collection("categories")
          .doc(categoryId)
          .collection("products")
          .snapshots()
          .map((event) => event.docs
              .map((e) => ProductModel.fromMap(e.data(), productKey: e.id))
              .toList());
    } catch (e) {
      throw Exception("Error fetching data: ${e.toString()}");
    }
  }

  @override
  Future addCard(CardModel cardModel) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        var cardId = _firestore
            .collection("users")
            .doc(currentUser.uid)
            .collection("cards")
            .doc()
            .id;
        return await _firestore
            .doc("users/${currentUser.uid}")
            .collection("cards")
            .doc(cardId)
            .set(cardModel.toMap(key: cardId));
      } else {
        throw Exception("SİSTEMDE KULLANICI YOK");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> deleteCard(CardModel cardModel) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await _firestore
            .doc("users/${currentUser.uid}")
            .collection("cards")
            .doc(cardModel.cardId)
            .delete();
      } else {
        throw Exception("SİSTEMDE KULLANICI YOK");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Stream<List<CardModel>> getSavedCards() {
    try {
      User? currentUser = _auth.currentUser;
      return _firestore
          .collection("users")
          .doc(currentUser!.uid)
          .collection("cards")
          .orderBy("isSelected", descending: true)
          .snapshots()
          .map((event) => event.docs
              .map((e) => CardModel.fromMap(key: e.id, e.data()))
              .toList());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> updateCard(CardModel cardModel) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await _firestore
            .collection("users")
            .doc(currentUser.uid)
            .collection("cards")
            .doc(cardModel.cardId)
            .update(cardModel.toMap());
      } else {
        throw Exception("SİSTEMDE KULLANICI YOK");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<dynamic> addAdress(AdressModel adressModel) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        dynamic docId = _firestore
            .doc("users/${currentUser.uid}")
            .collection("adress")
            .doc()
            .id;

        var collectionRef =
            await _firestore.collection("AdressIndexCount").get();
        var docs = collectionRef.docs;
        Map<String, dynamic> indexDocument = {};
        for (var element in docs) {
          indexDocument = element.data();
        }
        int indexCount = indexDocument['count'];

        var increaseQuery = await _firestore
            .collection("AdressIndexCount")
            .doc("BCm50TDoPFq1Pi9hlDUK")
            .update({'count': FieldValue.increment(1)});

        return await _firestore
            .collection("users")
            .doc(currentUser.uid)
            .collection("adress")
            .doc(docId)
            .set(adressModel.toMap(key: docId, indexCount: indexCount))
            .whenComplete(() => increaseQuery);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> deleteAdress(AdressModel adressModel) async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser != null) {
        await _firestore
            .doc("users/${currentUser.uid}")
            .collection("adress")
            .doc(adressModel.adressId)
            .delete();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Stream<List<AdressModel>> getUserAdress() {
    try {
      return _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("adress")
          .orderBy('isSelected', descending: true)
          .snapshots()
          .map((event) => event.docs
              .map((e) => AdressModel.fromMap(e.data(), key: e.id))
              .toList());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> updateAdress(AdressModel adressModel) async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await _firestore
            .collection("users")
            .doc(currentUser.uid)
            .collection("adress")
            .doc(adressModel.adressId)
            .update(adressModel.toUpdatedMap(
                adressModel.fullAdress,
                adressModel.isSelected,
                adressModel.mahalleAdi,
                adressModel.binaNo,
                adressModel.kat,
                adressModel.daireNo,
                adressModel.baslik));
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Stream<List<AdressModel>> getUsersSelectedAdress() {
    try {
      return _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("adress")
          .where("isSelected", isEqualTo: true)
          .snapshots()
          .map((event) => event.docs
              .map((e) => AdressModel.fromMap(key: e.id, e.data()))
              .toList());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> setSelectedValue(String? newSelectedAddressId) async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      var addressesRef = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('adress');

      var batch = FirebaseFirestore.instance.batch();

      var currentSelectedAddressQuery =
          await addressesRef.where('isSelected', isEqualTo: true).get();
      if (currentSelectedAddressQuery.docs.isNotEmpty) {
        var currentSelectedAddress = currentSelectedAddressQuery.docs.first;
        batch.update(currentSelectedAddress.reference, {'isSelected': false});
      }

      if (newSelectedAddressId != null) {
        var newSelectedAddressRef = addressesRef.doc(newSelectedAddressId);
        batch.update(newSelectedAddressRef, {'isSelected': true});
      }

      await batch.commit();
    }
  }

  @override
  Stream<String?> getSelectedAdressId() {
    User? currentUser = _auth.currentUser;

    try {
      var addressesRef = _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('adress');

      return addressesRef
          .where('isSelected', isEqualTo: true)
          .limit(1)
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs.first.id;
        } else {
          return null;
        }
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Stream<double?> getBasketTotalPrice() {
    // Kullanıcının sepetindeki ürünlerin stream'ini dinle
    User? currentUser = _auth.currentUser;
    return _firestore
        .collection("users")
        .doc(currentUser!.uid)
        .collection("basket")
        .doc(currentUser.uid)
        .collection("products")
        .snapshots()
        .map((querySnapshot) {
      // Sepetteki ürünlerin toplam fiyatını hesapla
      double totalPrice = 0.0;

      // Her bir dökümanı gezerek fiyatları topla
      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final price = data['productPrice'];
        if (price is int) {
          totalPrice += price.toDouble();
        } else if (price is double) {
          totalPrice += price;
        }
      }

      return totalPrice;
    });
  }

  @override
  Stream<String?> getSelectedCardId() {
    User? currentUser = _auth.currentUser;

    try {
      var addressesRef = _firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('cards');

      return addressesRef
          .where('isSelected', isEqualTo: true)
          .limit(1)
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs.first.id;
        } else {
          return null;
        }
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> setSelectedCardValue(String? newSelectedCardId) async {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      var cardsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('cards');

      var batch = FirebaseFirestore.instance.batch();

      var currentSelectedCardQuery =
          await cardsRef.where('isSelected', isEqualTo: true).get();
      if (currentSelectedCardQuery.docs.isNotEmpty) {
        var currentSelectedCard = currentSelectedCardQuery.docs.first;
        batch.update(currentSelectedCard.reference, {'isSelected': false});
      }

      if (newSelectedCardId != null) {
        var newSelectedCardRef = cardsRef.doc(newSelectedCardId);
        batch.update(newSelectedCardRef, {'isSelected': true});
      }

      Future.delayed(const Duration(seconds: 2));

      await batch.commit();
    }
  }

  @override
  Stream<CardModel?> getSelectedCard() {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        var collectionRef = _firestore
            .collection("users")
            .doc(currentUser.uid)
            .collection("cards")
            .where('isSelected', isEqualTo: true)
            .snapshots();

        return collectionRef.map((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            var doc = snapshot.docs.first;
            return CardModel.fromMap(key: doc.id, doc.data());
          } else {
            return null;
          }
        });
      } else {
        throw Exception("SİSTEMDE KULLANICI YOK");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
