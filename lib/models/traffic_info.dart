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

  static TrafficInfo getTrafficInfoConstructorFromInput(dynamic blob) {
    if (blob["refTrafficInfoCategoryId"] != 0) {
      final TrafficInfoCategory category =
          getTrafficCategory(blob["refTrafficInfoCategoryId"]);
      switch (category) {
        case TrafficInfoCategory.Aufzugsstoerungen:
          return TrafficInfo.elevator(
            trafficInfoCategory: category,
            troubleName: blob["name"],
            title: blob["title"],
            description: blob["description"],
            fromDateInString: blob["attributes"]["ausVon"],
            toDateInString: blob["attributes"]["ausBis"],
            fromDateInDateTime: DateTime.parse(blob["time"]["start"]),
            toDateInDateTime: DateTime.parse(blob["time"]["end"]),
            reason: blob["attributes"]["reason"],
            relatedLines: blob["attributes"]["relatedLines"],
            towards: blob["attributes"]["towards"],
            relatedStops: blob["attributes"]["relatedStops"],
          );
          break;
        case TrafficInfoCategory.StoerungKurz:
          return TrafficInfo.stoerung(
            trafficInfoCategory: category,
            title: blob["title"],
            description: blob["description"],
            fromDateInDateTime: blob["start"]["start"] == null
                ? DateTime.now()
                : DateTime.parse(blob["time"]["start"]),
            toDateInDateTime: blob["start"]["end"] == null
                ? DateTime.now()
                : DateTime.parse(blob["time"]["end"]),
            relatedLines: blob["attributes"]["relatedLines"],
            towards: blob["attributes"]["towards"],
            relatedStops: blob["attributes"]["relatedStops"],
            owner: blob["attributes"]["owner"],
          );
          break;
        case TrafficInfoCategory.StoerungKurz:
          return TrafficInfo.stoerung(
            trafficInfoCategory: category,
            title: blob["title"],
            description: blob["description"],
            fromDateInDateTime: blob["start"]["start"] == null
                ? DateTime.now()
                : DateTime.parse(blob["time"]["start"]),
            toDateInDateTime: blob["start"]["end"] == null
                ? DateTime.now()
                : DateTime.parse(blob["time"]["end"]),
            relatedLines: blob["attributes"]["relatedLines"],
            towards: blob["attributes"]["towards"],
            relatedStops: blob["attributes"]["relatedStops"],
            owner: blob["attributes"]["owner"],
          );
          break;
        default:
          return TrafficInfo.elevator(
            trafficInfoCategory: category,
            troubleName: blob["name"],
            title: blob["title"],
            description: blob["description"],
            fromDateInString: blob["attributes"]["ausVon"],
            toDateInString: blob["attributes"]["ausBis"],
            fromDateInDateTime: DateTime.parse(blob["time"]["start"]),
            toDateInDateTime: DateTime.parse(blob["time"]["end"]),
            reason: blob["attributes"]["reason"],
            relatedLines: blob["attributes"]["relatedLines"],
            towards: blob["attributes"]["towards"],
            relatedStops: blob["attributes"]["relatedStops"],
          );
      }
    }
    return null;
  }

  TrafficInfoCategory trafficInfoCategory;
  String troubleName;
  String title;
  String description;
  String toDateInString;
  String fromDateInString;
  DateTime toDateInDateTime;
  DateTime fromDateInDateTime;
  String reason;
  List<dynamic> relatedLines;
  List<dynamic> relatedStops;
  String towards;
  String owner;

  TrafficInfo.elevator({
    @required this.trafficInfoCategory,
    @required this.troubleName,
    @required this.title,
    @required this.description,
    @required this.toDateInString,
    @required this.toDateInDateTime,
    @required this.reason,
    @required this.relatedLines,
    @required this.relatedStops,
    @required this.fromDateInString,
    @required this.fromDateInDateTime,
    @required this.towards,
  }) {
    final tStamp = DateTime.now();

    trafficInfoCategory ??= TrafficInfoCategory.Unbekannt;
    troubleName ??= "Unkown trouble name";
    title ??= "Unkown title";
    description ??= "Unknown description";
    toDateInString ??= "Unknown Date";
    fromDateInString ??= "Unkown Date";
    toDateInDateTime ??= tStamp;
    fromDateInDateTime ??= tStamp;
    reason ??= "Unknown reason";
    relatedLines ??= ["Not found"];
    towards ??= "Unkown";
    relatedStops ??= [-1];
    owner ??= "Owner not available";
  }
  TrafficInfo.stoerung({
    @required this.trafficInfoCategory,
    @required this.title,
    @required this.description,
    @required this.toDateInDateTime,
    @required this.fromDateInDateTime,
    @required this.relatedLines,
    @required this.towards,
    @required this.owner,
    @required this.relatedStops,
  }) {
    final tStamp = DateTime.now();

    trafficInfoCategory ??= TrafficInfoCategory.Unbekannt;
    troubleName ??= "Unkown trouble name";
    title ??= "Unkown title";
    description ??= "Unknown description";
    toDateInString ??= "Unknown Date";
    fromDateInString ??= "Unkown Date";
    toDateInDateTime ??= tStamp;
    fromDateInDateTime ??= tStamp;
    reason ??= "Unknown reason";
    relatedLines ??= ["Not found"];
    towards ??= "Unkown";
    relatedStops ??= [-1];
    owner ??= "Owner not available";

    print(toDateInDateTime);
    print(fromDateInDateTime);
  }
}
