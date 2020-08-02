import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wienerlinienapp/misc/type_specific_attributes_mixin.dart';

class StationRequest with TypeSpecificAttributes {
  static StationRequest buildModel(Map<String, dynamic> blob) {
    final checkDeparute =
        blob["lines"].first["departures"]["departure"].map((deparuteItem) {
      if (deparuteItem.length <= 0) {
        return {
          "timePlanned": DateTime.now().toIso8601String(),
          "timeReal": DateTime.now().toIso8601String(),
          "countdown": 0,
        };
      }
      return deparuteItem;
    }).toList();
    return StationRequest(
      idName: blob["name"],
      lineType: blob["lineType"],
      stationTitle: blob["locationStop"]["properties"]["title"],
      type: blob["locationStop"]["properties"]["type"],
      lineName: blob["lines"].first["name"],
      towards: blob["lines"].first["towards"],
      richtungsId: blob["lines"].first["richtungsId"],
      barrierFree: blob["lines"].first["barrierFree"],
      departures: checkDeparute,
      category: blob["lines"].first["type"],
      lineId: blob["lines"].first["lineId"],
    );
  }

  String _idName;
  String _stationTitle;
  String _type;
  String _lineType;
  String _lineName;
  String _towards;
  String _richtungsId;
  String _category;
  int _lineId;
  bool _barrierFree;
  List _departures;
  Color _lineTypeColor;
  String _typeImage;

  StationRequest({
    @required idName,
    @required stationTitle,
    @required type,
    @required lineType,
    @required lineName,
    @required towards,
    @required richtungsId,
    @required barrierFree,
    @required departures,
    @required category,
    @required lineId,
  }) {
    try {
      this._idName = idName ?? "ID Unkown";
      this._stationTitle = stationTitle ?? " Unkonw Stationtitle";
      this._type = type ?? "Unkown type";
      this._lineType = lineType ?? "Unkown line type";
      this._lineName = lineName ?? "Unknown line name";
      this._towards = towards ?? "Unkown direction";
      this._richtungsId = richtungsId ?? "Unkown direction ID";
      this._barrierFree = barrierFree ?? false;
      this._departures = departures ?? [];
      this._category = category ?? "Unkonwn type";
      this._lineId = lineId ?? -1;
      this._lineTypeColor = setTypeColor(this._category, this._lineName);
      this._typeImage = setTypeImage(this._category);
    } catch (e) {
      print(e);
    }
  }
  String get idName => _idName;
  String get stationTitle => _stationTitle;
  String get type => _type;
  String get lineType => _lineType;
  String get lineName => _lineName;
  //TODO: "towards" -> Endstation validieren
  String get towards => _towards;
  String get richtungsId => _richtungsId;
  String get category => _category;
  int get lineId => _lineId;
  bool get barrierFree => _barrierFree;
  List get departures => _departures;
  Color get lineTypeColor => _lineTypeColor;
  String get typeImage => _typeImage;
}
