import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/card_model.dart';
import '../repository/database_repository.dart';
import '../tools/locator.dart';
import '../view/add_creditcard_view.dart';
import 'addcredit_card_view_model.dart';

class PaymentPageViewModel with ChangeNotifier {
  final _repository = locator<DatabaseRepository>();

  Stream<List<CardModel>> getData() {
    return _repository.getSavedCards();
  }
  Stream<String?> getSelectedCardId(){
    return _repository.getSelectedCardId();
  }
  void setSelectedValue(String? newSelectedCardId)async{
   await _repository.setSelectedCardValue(newSelectedCardId);
  }
  
  
  
  void deleteCard(BuildContext context,CardModel card)async{
    try{
      await _repository.deleteCard(card);
    }
    catch (e){
      showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: Text(e.toString()),
        );
      },);
    }
  }
  

  void addCard(BuildContext context) async {
    List<String>? result = await goAddCardPage(context);
    if (result != null) {
      try {
        String cardName = result[0];
        String cardNumber = result[1];
        String expiryDate = result[2];
        String cvvCode = result[3];

        CardModel cardModel = CardModel(
            cardName: cardName,
            cardNumber: cardNumber,
            expiryDate: expiryDate,
            cvvCode: cvvCode);

        dynamic cardId = await _repository.addCard(cardModel);
        cardModel.cardId = cardId;
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }
  }

  Future<List<String>?> goAddCardPage(BuildContext context) async {
    MaterialPageRoute pageRoute = MaterialPageRoute(
      builder: (_) => ChangeNotifierProvider(
        create: (context) => AddCreditCardPageViewModel(),
        child: const AddCreditCardView(),
      ),
    );

    var result = await Navigator.push(context, pageRoute);
    return result;
  }

  Stream<CardModel?> getSelectedCardItem(){
    return _repository.getSelectedCard();
  }

}
