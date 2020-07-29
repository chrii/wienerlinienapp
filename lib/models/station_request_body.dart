import 'package:flutter/foundation.dart';

class StationRequestBody {
  String idName;
  String stationTitle;
  String type;
  String lineType;
  List<LineDetails> lineDetails;

  StationRequestBody({
    @required this.idName,
    @required this.lineDetails,
    @required this.stationTitle,
    @required this.type,
    @required this.lineType,
  });
}

class LineDetails {
  String name;
  String towards;
  String direction;
  bool barrierFree;
  String type;
  List<Departures> departures;

  LineDetails({
    @required this.barrierFree,
    @required this.departures,
    @required this.direction,
    @required this.name,
    @required this.towards,
    @required this.type,
  });
}

class Departures {
  DateTime timePlanned;
  DateTime timeReal;
  int countdown;

  Departures({
    @required this.countdown,
    @required this.timePlanned,
    @required this.timeReal,
  });
}
