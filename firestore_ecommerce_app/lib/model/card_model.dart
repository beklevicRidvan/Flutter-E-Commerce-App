class CardModel {
  dynamic cardId;
  String cardName;
  String cardNumber;
  String expiryDate;
  String cvvCode;
  bool isSelected = false;

  CardModel({
    this.cardId,
    required this.cardName,
    required this.cardNumber,
    required this.expiryDate,
    required this.cvvCode,
    this.isSelected = false,
  });

  factory CardModel.fromMap(Map<String, dynamic> map, {dynamic key}) {
    return CardModel(
        cardId: key ?? map["cardId"],
        cardName: map["cardName"],
        cardNumber: map["cardNumber"],
        expiryDate: map["expiryDate"],
        cvvCode: map["cvvCode"]);
  }

  Map<String, dynamic> toMap({dynamic key}) {
    return {
      "cardId": key ?? cardId,
      "cardName": cardName,
      "cardNumber": cardNumber,
      "expiryDate": expiryDate,
      "cvvCode": cvvCode,
      "isSelected": isSelected
    };
  }

  Map<String, dynamic> toUpdatedMap(String newCardName, String newCardNumber,
      String newExpiryDate, String newCvvCode, bool newSelected) {
    return {
      "cardId": cardId,
      "cardName": newCardName,
      "cardNumber": newCardNumber,
      "expiryDate": newExpiryDate,
      "cvvCode": newCvvCode,
      "isSelected": newSelected,
    };
  }
}
