import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:wienerlinienapp/misc/type_specific_attributes_mixin.dart';
import 'package:wienerlinienapp/misc/database.dart';
import 'package:wienerlinienapp/models/station_model.dart';
import 'package:http/http.dart' as http;
import 'package:wienerlinienapp/models/station_request_body.dart';
import 'package:wienerlinienapp/models/traffic_info.dart';

class WienerLinienMaindataProvider with ChangeNotifier, TypeSpecificAttributes {
  List<StationModel> maindata;
  String rootUrl = "http://www.wienerlinien.at/ogd_realtime/";

  List<StationModel> nearbyStations = [];
  List<StationRequestBody> realtime = [];
  List stoerungen = [];

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

  String buildUrl(List<String> stopList) {
    final String url = rootUrl + "monitor?";
    String clampedStopIDs = "";
    stopList.forEach((element) {
      clampedStopIDs += "&stopId=" + element;
    });
    final finalUrl = url + clampedStopIDs;
    print("Build URL: " + finalUrl);
    return finalUrl;
  }

  Future<void> fetchStopIDsFromAPI(List<String> stopList,
      {listen: true}) async {
    final finalUrl = buildUrl(stopList);
    try {
      final http.Response response = await http.get(finalUrl);
      if (response.statusCode == 200) {
        final parsedJson = jsonDecode(response.body);

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
              lineTypeColor: setTypeColor(line["type"], line["name"]),
              typeImage: setTypeImage(line["type"]),
            );
          }).toList();
          return StationRequestBody(
            lineDetails: line,
            idName: properties['name'],
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

  Future<StationRequestBody> fetchFromAPIWithLineNumber(
      StationRequestBody station) async {
    final db = SqLiteDatabase("test");
    try {
      final query = await db.getStationsFromLineAndStop(
          station.lineDetails.first.name, station.stationTitle);
      final url = buildUrl(query);

      final response = await http.get(url);
      if (!(response.statusCode <= 400)) {
        throw new Exception("Error code: ${response.statusCode}");
      }
      final parsedJson = jsonDecode(response.body);
      final List<StationRequestBody> stationRequestBody = parsedJson['data']
              ['monitors']
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
              timePlanned: DateTime.parse(dep['departureTime']['timePlanned']),
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
            lineTypeColor: setTypeColor(line["type"], line["name"]),
            typeImage: setTypeImage(line["type"]),
          );
        }).toList();
        return StationRequestBody(
          lineDetails: line,
          idName: properties['name'],
          stationTitle: properties['title'],
          type: properties['type'],
          lineType: lineType,
        );
      }).toList();
      final StationRequestBody singleLine = stationRequestBody.firstWhere(
          (item) =>
              item.lineDetails.first.name == station.lineDetails.first.name &&
              item.lineDetails.first.towards ==
                  station.lineDetails.first.towards);

      return singleLine;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future trafficInfo() async {
    try {
      final String json =
          await rootBundle.loadString('assets/mock/traffic_info_mock.json');
      final Map<String, dynamic> decoded = jsonDecode(json);
      final List<TrafficInfo> instantiated =
          decoded["data"]["trafficInfos"].map<TrafficInfo>((item) {
        print(jsonEncode(item["start"]));
        return TrafficInfo.getTrafficInfoConstructorFromInput(item);
      }).toList();
      print("STOERUNG:" + instantiated.toString());
      return instantiated;
    } catch (e) {
      print(e);
      //throw Exception(e);
    }
  }

  // stoerungAusLinienListe(String line) async {
  //   try {
  //     final res = await stoerungUeberZeit() as List<dynamic>;
  //     final relatedLines = res.where((item) {
  //       final i = item["relatedLines"] ?? [];
  //       return i.contains(line);
  //     }).toList();
  //     print(relatedLines);
  //     return relatedLines;
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
