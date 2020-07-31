import 'package:flutter/foundation.dart';

enum TrafficInfoCategory {
  Aufzugsstoerungen,
  StoerungLang,
  StoerungKurz,
  Unbekannt,
}

class TrafficInfo {
  static TrafficInfoCategory getTrafficCategory(int category) {
    switch (category) {
      case 1:
        return TrafficInfoCategory.Aufzugsstoerungen;
        break;
      case 2:
        return TrafficInfoCategory.StoerungLang;
        break;
      case 3:
        return TrafficInfoCategory.StoerungKurz;
        break;
      default:
        return TrafficInfoCategory.Unbekannt;
    }
  }

  TrafficInfoCategory trafficInfoCategory;

  TrafficInfo({
    @required this.trafficInfoCategory,
  }) {
    trafficInfoCategory ??= TrafficInfoCategory.Unbekannt;
  }
}
