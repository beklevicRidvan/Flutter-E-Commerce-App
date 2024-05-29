import 'package:firestore_ecommerce_app/tools/constants.dart';
import 'package:flutter/material.dart';

class MyRadioTile extends StatelessWidget {
  final String title;
  final String subTitle;
  const MyRadioTile({super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.scale(
              scale: deviceHeight * 0.0014,
              child: const Icon(
                Icons.circle_outlined,
                color: Colors.red,
              )),
          SizedBox(
            width: deviceHeight * 0.02,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Constants.getColorBoldStyle(
                    17, Colors.black),
              ),
              Text(
                subTitle,
                style: Constants.getNormalColorTextStyle(
                    15, Colors.grey.shade800),
              )
            ],
          )
        ],
      ),
    );
  }
}
