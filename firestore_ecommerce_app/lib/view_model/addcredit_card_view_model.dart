import 'package:flutter/material.dart';

class AddCreditCardPageViewModel with ChangeNotifier {
  late TextEditingController _controllerCardHolderName;
  late TextEditingController _controllerCardNumber;
  late TextEditingController _controllerExpiryDate;
  late TextEditingController _controllerCvvCode;

  AddCreditCardPageViewModel() {
    _controllerCardHolderName = TextEditingController();
    _controllerCardNumber = TextEditingController();
    _controllerExpiryDate = TextEditingController();
    _controllerCvvCode = TextEditingController();
  }

  @override
  void dispose() {
    _controllerCardHolderName.dispose();
    _controllerCardNumber.dispose();
    _controllerExpiryDate.dispose();
    _controllerCvvCode.dispose();
    super.dispose();
  }

  TextEditingController get controllerCvvCode => _controllerCvvCode;

  TextEditingController get controllerExpiryDate => _controllerExpiryDate;

  TextEditingController get controllerCardNumber => _controllerCardNumber;

  TextEditingController get controllerCardHolderName =>
      _controllerCardHolderName;
}
