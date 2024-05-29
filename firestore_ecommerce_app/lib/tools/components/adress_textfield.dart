import 'package:flutter/material.dart';

import '../constants.dart';

class AdressTextField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final TextEditingController controller;
  const AdressTextField(
      {super.key,
      required this.hintText,
      required this.labelText,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: Constants.getNormalColorTextStyle(15, Colors.red.shade300),
            labelText: labelText,
            labelStyle: Constants.getNormalColorTextStyle(15, Colors.red.shade300),
            enabledBorder:  OutlineInputBorder(
                borderSide: BorderSide(
                    width: 1,
                    style: BorderStyle.solid,
                    color: Colors.red.shade200)),
            disabledBorder: OutlineInputBorder(

                borderSide: BorderSide(
                    width: 1,
                    style: BorderStyle.solid,
                    color: Theme.of(context).colorScheme.secondary))),
      ),
    );
  }
}
