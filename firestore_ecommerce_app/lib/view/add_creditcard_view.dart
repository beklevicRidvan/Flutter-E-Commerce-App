import 'package:firestore_ecommerce_app/view_model/addcredit_card_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:provider/provider.dart';

import '../tools/constants.dart';

class AddCreditCardView extends StatefulWidget {
  const AddCreditCardView({super.key});

  @override
  State<AddCreditCardView> createState() => _AddCreditCardViewState();
}

class _AddCreditCardViewState extends State<AddCreditCardView> {
  String cardNumber = "";
  String expiryDate = "";
  String cardHolderName = "";
  String cvvCode = "";
  bool isCvvFocused = false;
  bool useGlassMorphism = false;

  bool useFloatingAnimation = true;
  final OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.7),
      width: 2.0,
    ),
  );

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
        "ADD CARD",
        style: Constants.getColorBoldStyle(20, Colors.white),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white, size: 30),
    );
  }

  Widget _buildBody(BuildContext context) {
    AddCreditCardPageViewModel viewModel = Provider.of(context, listen: false);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            CreditCardWidget(
              enableFloatingCard: useFloatingAnimation,
              glassmorphismConfig: Glassmorphism.defaultConfig(),
              cardNumber: viewModel.controllerCardNumber.text,
              expiryDate: viewModel.controllerExpiryDate.text,
              cardHolderName: viewModel.controllerCardHolderName.text,
              cvvCode: viewModel.controllerCvvCode.text,
              bankName: 'RBVC',
              frontCardBorder:
                  useGlassMorphism ? null : Border.all(color: Colors.grey),
              backCardBorder:
                  useGlassMorphism ? null : Border.all(color: Colors.grey),
              showBackView: isCvvFocused,
              obscureCardNumber: true,
              obscureCardCvv: true,
              isChipVisible: true,
              isHolderNameVisible: true,
              isSwipeGestureEnabled: true,
              onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CreditCardForm(
                      cardNumber: viewModel.controllerCardNumber.text,
                      expiryDate: viewModel.controllerExpiryDate.text,
                      cardHolderName: viewModel.controllerCardHolderName.text,
                      cvvCode: viewModel.controllerCvvCode.text,
                      onCreditCardModelChange: onCreditCardModelChange,
                      formKey: formKey,
                      isCardNumberVisible: true,
                      isHolderNameVisible: true,
                      isExpiryDateVisible: true,
                      inputConfiguration: const InputConfiguration(
                        cardNumberDecoration: InputDecoration(
                          labelText: 'Number',
                          hintText: 'XXXX XXXX XXXX XXXX',
                        ),
                        expiryDateDecoration: InputDecoration(
                          labelText: 'Expired Date',
                          hintText: 'XX/XX',
                        ),
                        cvvCodeDecoration: InputDecoration(
                          labelText: 'CVV',
                          hintText: 'XXX',
                        ),
                        cardHolderDecoration: InputDecoration(
                          labelText: 'Card Holder',
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _onValidate,
                      child: Container(
                        color: Theme.of(context).colorScheme.primary,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        alignment: Alignment.center,
                        child: Text(
                          'Validate',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.background,
                            fontFamily: 'halter',
                            fontSize: 15,
                            package: 'flutter_credit_card',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onValidate() {
    AddCreditCardPageViewModel viewModel = Provider.of(context, listen: false);
    bool? value = formKey.currentState?.validate();
    if (value != null) {
      if (value) {
        List<String> result = [
          viewModel.controllerCardHolderName.text,
          viewModel.controllerCardNumber.text,
          viewModel.controllerExpiryDate.text,
          viewModel.controllerCvvCode.text,
        ];

        Navigator.pop(context, result);
      } else {}
    } else {}
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    AddCreditCardPageViewModel viewModel = Provider.of(context, listen: false);
    setState(() {
      viewModel.controllerCardNumber.text = creditCardModel.cardNumber;
      viewModel.controllerExpiryDate.text = creditCardModel.expiryDate;
      viewModel.controllerCardHolderName.text = creditCardModel.cardHolderName;
      viewModel.controllerCvvCode.text = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
