import 'package:flutter/material.dart';

class Constants {
  static List<String> profileInfo = [
    "Profil Bilgileri",
    "Siparişler",
    "İade ve İptal İşlemleri",
    "Favoriler",
    "Kuponlar ve İndirimler",
    "Ödeme Bilgileri"
  ];

  static List<Image> images = [
    Image(
      image: const AssetImage("assets/slider/slider3.jpg"),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        basketPagePlaceHolderImageAdress,
        fit: BoxFit.cover,
      ),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return Image.asset(
            basketPagePlaceHolderImageAdress,
            fit: BoxFit.cover,
          );
        }
      },
    ),
    Image(
      image: const AssetImage("assets/slider/slider4.jpg"),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        basketPagePlaceHolderImageAdress,
        fit: BoxFit.cover,
      ),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return Image.asset(
            basketPagePlaceHolderImageAdress,
            fit: BoxFit.cover,
          );
        }
      },
    ),
    Image(
      image: const AssetImage("assets/slider/slider2.jpg"),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        basketPagePlaceHolderImageAdress,
        fit: BoxFit.cover,
      ),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return Image.asset(
            basketPagePlaceHolderImageAdress,
            fit: BoxFit.cover,
          );
        }
      },
    ),
    Image(
      image: const AssetImage("assets/slider/slider1.jpg"),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        basketPagePlaceHolderImageAdress,
        fit: BoxFit.cover,
      ),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return Image.asset(
            basketPagePlaceHolderImageAdress,
            fit: BoxFit.cover,
          );
        }
      },
    ),
    Image(
      image: const AssetImage("assets/slider/slider5.jpg"),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        basketPagePlaceHolderImageAdress,
        fit: BoxFit.cover,
      ),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        } else {
          return Image.asset(
            basketPagePlaceHolderImageAdress,
            fit: BoxFit.cover,
          );
        }
      },
    ),
  ];

  static List<Icon> profileIcons = const [
    Icon(Icons.person_outline_outlined),
    Icon(Icons.shopping_bag_outlined),
    Icon(Icons.recycling),
    Icon(Icons.favorite_border_outlined),
    Icon(Icons.discount_outlined),
    Icon(Icons.payment)
  ];
  static EdgeInsets normalPadding() {
    return const EdgeInsets.all(16);
  }

  static EdgeInsets littlePadding() {
    return const EdgeInsets.all(8);
  }

  static TextStyle getNormalTextStyle(double value) {
    return TextStyle(fontSize: getFontSize(value));
  }

  static TextStyle getNormalColorTextStyle(double value, Color color) {
    return TextStyle(color: color, fontSize: value);
  }

  static TextStyle getColorBoldStyle(double value, Color color) {
    return TextStyle(
        color: color, fontSize: value, fontWeight: FontWeight.bold);
  }

  static TextStyle productMoneyTextStyle() {
    return const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  }

  static Color circularProgressColor = Colors.blue;

  static Color bottomSelectedItemColor = Colors.white;

  static String basketPagePlaceHolderImageAdress = "assets/placeholder.png";

  static String getFirstLetter(String word) {
    String result = "";
    var iterations = word.split(" ");
    for (int i = 0; i < iterations.length; i++) {
      result += iterations[i][0];
    }
    return result;
  }

  static double getFontSize(double value) {
    return value;
  }

  static String getSpliceWord(String word) {
    List<String> words = word.split(" ");
    if (words.length >= 2) {
      return "${words[0]} ${words[1]}\n\t${words.sublist(2).join(" ")}";
    } else {
      return word;
    }
  }

  String formatWithSpaces(String input) {
    if (input.length != 16) {
      throw ArgumentError('String length must be 16 characters.');
    }

    StringBuffer formattedString = StringBuffer();

    for (int i = 0; i < input.length; i++) {
      formattedString.write(input[i]);
      if ((i + 1) % 4 == 0 && i != input.length - 1) {
        formattedString.write(' ');
      }
    }

    return formattedString.toString();
  }

  static String getCardNumberFormatter(String input) {
    if (input.length != 19) {
      throw ArgumentError('Formatted string length must be 19 characters.');
    }

    List<String> chars = input.split('');

    List<int> indexesToReplace = [7, 8, 9, 10, 11];
    for (int index in indexesToReplace) {
      chars[index] = '•';
    }

    return chars.join('');
  }
}
