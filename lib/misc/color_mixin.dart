import 'package:flutter/material.dart';

mixin ColorMixin {
  setStationColor(String type, String lineName) {
    switch (type) {
      case "ptBus":
        return Color.fromRGBO(30, 30, 224, 1);
        break;
      case "ptTram":
        return Color.fromRGBO(30, 30, 224, 1);
        break;
      case "ptMetro":
        switch (lineName) {
          case "U1":
            return Color.fromRGBO(227, 0, 14, 1);
            break;
          case "U2":
            return Color.fromRGBO(172, 63, 222, 1);
            break;
          case "U3":
            return Color.fromRGBO(231, 135, 39, 1);
            break;
          case "U4":
            return Color.fromRGBO(67, 181, 22, 1);
            break;
          case "U6":
            return Color.fromRGBO(181, 78, 22, 1);
            break;
          default:
            return Color.fromRGBO(227, 0, 14, 1);
            break;
        }
        break;
      default:
        return Color.fromRGBO(30, 30, 224, 1);
        break;
    }
  }
}
