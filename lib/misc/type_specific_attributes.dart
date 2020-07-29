import 'package:flutter/material.dart';

mixin TypeSpecificAttributes {
  static const Color blue = Color.fromRGBO(30, 30, 224, 1);
  static const Color red = Color.fromRGBO(227, 0, 14, 1);
  static const Color violet = Color.fromRGBO(172, 63, 222, 1);
  static const Color orange = Color.fromRGBO(231, 135, 39, 1);
  static const Color green = Color.fromRGBO(67, 181, 22, 1);
  static const Color brown = Color.fromRGBO(181, 78, 22, 1);

  //   "assets/images/wienerlinien-bus.jpg"
  // "image": "assets/images/wienerlinien-ubahn.jpg
  // "image": "assets/images/flexity-nacht-header.jpg"

  setTypeColor(String type, String lineName) {
    switch (type) {
      case "ptBus":
        return blue;
        break;
      case "ptTram":
        return blue;
        break;
      case "ptMetro":
        switch (lineName) {
          case "U1":
            return red;
            break;
          case "U2":
            return violet;
            break;
          case "U3":
            return orange;
            break;
          case "U4":
            return green;
            break;
          case "U6":
            return brown;
            break;
          default:
            return red;
            break;
        }
        break;
      default:
        return blue;
        break;
    }
  }

  setTypeImage(String type) {
    switch (type) {
      case "ptBus":
        return "assets/images/wienerlinien-bus.jpg";
        break;
      case "ptTram":
        return "assets/images/flexity.jpg";
        break;
      case "ptMetro":
        return "assets/images/wienerlinien-ubahn.jpg";
        break;
      default:
        return "assets/images/wienerlinien-bus.jpg";
        break;
    }
  }
}
