import 'package:flutter/foundation.dart';

class StationModel {
  final String lineID;
  final String lineText;
  final String stopID;
  final String meansOfTransport;
  final String stopText;
  final double longitude;
  final double latitude;

  StationModel({
    @required this.lineID,
    @required this.lineText,
    @required this.stopID,
    @required this.meansOfTransport,
    @required this.stopText,
    @required this.longitude,
    @required this.latitude,
  });
}
