import 'dart:convert' as json;

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:wienerlinienapp/misc/database.dart';
import 'package:wienerlinienapp/models/station_model.dart';
import 'package:http/http.dart' as http;
import 'package:wienerlinienapp/models/station_request_body.dart';

class WienerLinienMaindataProvider with ChangeNotifier {
  List<StationModel> maindata;
  String rootUrl = "http://www.wienerlinien.at/ogd_realtime/";

  List<StationModel> nearbyStations = [];
  List<StationRequestBody> realtime = [];

  Future<void> initialize(String databaseName) async {
    final db = SqLiteDatabase(databaseName);
    print("Starting to build maindata");
    await db.buildData();
    maindata = db.stations
        .map((e) => StationModel(
              lineID: e["LineID"],
              lineText: e["LineText"],
              stopID: e["StopID"],
              meansOfTransport: e["MeansOfTransport"],
              stopText: e["StopText"],
              longitude:
                  e["Longitude"].length == 0 ? 0 : double.parse(e["Longitude"]),
              latitude:
                  e["Longitude"].length == 0 ? 0 : double.parse(e["Latitude"]),
            ))
        .toList();
    print("Finished initialization. Notify Listeners...");
    notifyListeners();
  }

  StationModel getByLineID(String id) {
    final line = maindata.firstWhere((element) => element.stopID == id);
    return line;
  }

  Future<List<StationModel>> getNearbyStations() async {
    final db = SqLiteDatabase("test");
    try {
      final Location location = Location();
      final access = await location.requestPermission();
      final actualLocation = await location.getLocation();
      if (access == PermissionStatus.granted) {
        final result = await db.fetchCoordinateRangeFromDatabase(
            actualLocation.latitude, actualLocation.longitude);
        final mapToModel = result.map((item) {
          print(item["LineText"]);
          return StationModel(
            lineID: item["LineID"],
            lineText: item["LineText"],
            stopID: item["StopID"],
            meansOfTransport: item["MeansOfTransport"],
            stopText: item["StopText"],
            longitude: double.parse(item["Longitude"]),
            latitude: double.parse(item["Latitude"]),
          );
        }).toList();
        nearbyStations = mapToModel;
        await fetchStopIDsFromAPI(mapToModel.map((e) => e.stopID).toList(),
            listen: false);
        return mapToModel;
      }
      return null;
    } catch (e) {
      print("ERROR: $e");
      return null;
    }
  }

  Future<void> get refreshNotifier {
    notifyListeners();
    return null;
  }

  Future<void> fetchStopIDsFromAPI(List<String> stopList,
      {listen: true}) async {
    final String url = rootUrl + "monitor?";
    String clampedStopIDs = "";
    stopList.forEach((element) {
      clampedStopIDs += "&stopId=" + element;
    });
    final finalUrl = url + clampedStopIDs;
    print("Build URL: " + finalUrl);

    try {
      final http.Response response = await http.get(finalUrl);
      if (response.statusCode == 200) {
        final parsedJson = json.jsonDecode(response.body);

        final List<StationRequestBody> wrapped = parsedJson['data']['monitors']
            .map<StationRequestBody>((monitorItems) {
          final properties = monitorItems['locationStop']['properties'];
          final lineType = properties['type'];
          final List<LineDetails> line =
              monitorItems['lines'].map<LineDetails>((line) {
            final List<Departures> departure =
                line['departures']['departure'].map<Departures>((dep) {
              if (dep['departureTime'].length <= 0) {
                return Departures(
                    countdown: 0,
                    timePlanned: DateTime.now(),
                    timeReal: DateTime.now());
              }
              return Departures(
                countdown: dep['departureTime']['countdown'],
                timePlanned:
                    DateTime.parse(dep['departureTime']['timePlanned']),
                timeReal: DateTime.parse(dep['departureTime']['timeReal'] ??
                    DateTime.now().toString()),
              );
            }).toList();
            return LineDetails(
              departures: departure,
              barrierFree: line['barrierFree'],
              direction: line['direction'],
              name: line['name'],
              towards: line['towards'],
              type: line['type'],
            );
          }).toList();
          return StationRequestBody(
            lineDetails: line,
            idName: properties['idName'],
            stationTitle: properties['title'],
            type: properties['type'],
            lineType: lineType,
          );
        }).toList();
        realtime = wrapped;
      } else {
        throw new Exception("Error ${response.body}");
      }
    } catch (e) {
      print(e);
    } finally {
      if (listen) notifyListeners();
    }
  }

  String fetchFromAPIWithLineNumber(StationRequestBody station) {
    // print(station.stationTitle);
    // print(station.lineDetails.first.name);
    // print(nearbyStations.first.stopText);
    // print(nearbyStations.first.lineText);
    final List<StationModel> stopId =
        nearbyStations.where((stat) => stat.stopText == "9").toList();
    print(stopId.length);
    // print(stopId[0].stopID);
    // print(stopId[1].stopID);
    // print(stopId[2].stopID);
    // print(stopId[3].stopID);

    return "";
  }
}
