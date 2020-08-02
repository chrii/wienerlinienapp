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
            reason: blob["attributes"]["reason"],
            towards: blob["attributes"]["towards"],
            relatedLines: blob["relatedLines"],
            relatedStops: blob["relatedStops"],
          );
          break;
        case TrafficInfoCategory.StoerungKurz:
          return TrafficInfo.stoerung(
            trafficInfoCategory: category,
            title: blob["title"],
            description: blob["description"],
            relatedLines: blob["relatedLines"],
            relatedStops: blob["relatedStops"],
          );
          break;
        case TrafficInfoCategory.StoerungKurz:
          return TrafficInfo.stoerung(
            trafficInfoCategory: category,
            title: blob["title"],
            description: blob["description"],
            relatedLines: blob["relatedLines"],
            relatedStops: blob["relatedStops"],
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
            reason: blob["attributes"]["reason"],
            towards: blob["attributes"]["towards"],
            relatedLines: blob["relatedLines"],
            relatedStops: blob["relatedStops"],
          );
      }
    }
    return null;
  }

  TrafficInfoCategory _trafficInfoCategory;
  String _troubleName;
  String _title;
  String _description;
  String _toDateInString;
  String _fromDateInString;
  String _reason;
  List<dynamic> _relatedLines;
  List<dynamic> _relatedStops;
  String _towards;

  TrafficInfo.elevator({
    @required trafficInfoCategory,
    @required troubleName,
    @required title,
    @required description,
    @required toDateInString,
    @required reason,
    @required relatedLines,
    @required relatedStops,
    @required fromDateInString,
    @required towards,
  }) {
    this._trafficInfoCategory =
        trafficInfoCategory ?? TrafficInfoCategory.Unbekannt;
    this._troubleName = troubleName ?? "Unkown trouble name";
    this._title = title ?? "Unkown title";
    this._description = description ?? "Unknown description";
    this._toDateInString = toDateInString ?? "Unknown Date";
    this._fromDateInString = fromDateInString ?? "Unkown Date";
    this._reason = reason ?? "Unknown reason";
    this._relatedLines = relatedLines ?? ["Not found"];
    this._towards = towards ?? "Unkown";
    this._relatedStops = relatedStops ?? [-1];
  }
  TrafficInfo.stoerung({
    @required trafficInfoCategory,
    @required title,
    @required description,
    @required relatedLines,
    @required relatedStops,
  }) {
    _trafficInfoCategory = trafficInfoCategory ?? TrafficInfoCategory.Unbekannt;
    _title = title ?? "Unkown title";
    _description = description ?? "Unknown description";
    _relatedLines = relatedLines ?? ["Not found"];
    _relatedStops = relatedStops ?? [-1];
  }

  TrafficInfoCategory get trafficInfoCategory => _trafficInfoCategory;
  String get troubleName => _troubleName;
  String get title => _title;
  String get description => _description;
  String get toDateInString => _toDateInString;
  String get fromDateInString => _fromDateInString;
  String get reason => _reason;
  String get towards => _towards;
  List<dynamic> get relatedLines => _relatedLines;
  List<dynamic> get relatedStops => _relatedStops;
}
