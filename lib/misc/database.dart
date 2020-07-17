import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sqflite/sqflite.dart';

class SqLiteDatabase {
  static Future<Database> database(String dbName) async {
    final dbPath = await getDatabasesPath();
    return openDatabase(dbPath + "/" + dbName, onCreate: (db, _) {
      print("Database $dbName created...");
      return;
    }, version: 1);
  }

  List stations;
  String databaseName;
  SqLiteDatabase(this.databaseName);

  Future<void> createTableFromList(
      String tableName, List<dynamic> headerList) async {
    final db = await SqLiteDatabase.database(databaseName);
    String table = "";
    // bool containsId = false;
    headerList.forEach((element) {
      table = table + "${element.toString()} TEXT,";
    });
    print(
        "Create Table with these Columns: ${table.substring(0, table.length - 1)}... ");
    await db
        .execute(
            "CREATE TABLE IF NOT EXISTS $tableName($table id TEXT PRIMARY KEY)")
        .catchError((e) => print(e.toString()));
  }

  importCsvToDatabaseTable(String path) async {
    print("Getting Data...");
    final data = await rootBundle.loadString(path);
    final res = CsvToListConverter(fieldDelimiter: ";").convert(data).toList();
    final List<dynamic> header = res.removeAt(0);
    final String tableName =
        path.split("/").last.split(".").first.replaceAll("-", "_");

    final Database db = await SqLiteDatabase.database(databaseName);

    await createTableFromList(tableName, header);

    final batch = db.batch();
    print("Inserting entries for $tableName...");
    res.forEach((element) {
      final Map<String, Object> outputMap = {};
      int i = 0;
      header.forEach((item) {
        outputMap.addAll({header[i]: element[i]});
        i = i + 1;
      });
      batch.insert(tableName, outputMap);
    });
    await batch.commit();
    print("Done!");
  }

  importCsvListToDatabaseTables(List<String> pathList) {
    print("Start importing of List...");
    pathList.forEach((path) async => await importCsvToDatabaseTable(path));
  }

  dropTable(String tableName) async {
    final Database db = await SqLiteDatabase.database(databaseName);
    db.execute("DROP TABLE $tableName");
    print("Dropped Table $tableName");
  }

  buildData() async {
    final db = await SqLiteDatabase.database(databaseName);
    final String sql = '''
      SELECT f.LineID, f.LineText, h.StopID, f.MeansOfTransport, h.StopText,
      h.Longitude, h.Latitude
      FROM wienerlinien_ogd_fahrwegverlaeufe l
      INNER JOIN wienerlinien_ogd_linien f ON l.LineID = f.LineID
      INNER JOIN wienerlinien_ogd_haltepunkte h ON l.StopID = h.StopID
      ''';
    final List res = await db.rawQuery(sql);
    final lineIDs = res.map((element) => element["LineID"]).toSet().toList();
    final haltepunkteMap = lineIDs
        .map((item) => res.firstWhere((element) => item == element['LineID']))
        .toList();
    // final f = res.where((element) => element.StopID == 171);
    // print(f.length);
    print(haltepunkteMap);
    stations = haltepunkteMap;
  }

  Future<List> fetchCoordinateRangeFromDatabase(double lat, double lon) async {
    final d = await SqLiteDatabase.database(databaseName);
    final double adding = 0.0020000;
    final rangeUpLon = lon + adding;
    final rangeDownLon = lon - adding;
    final rangeUpLat = lat + adding;
    final rangeDownLat = lat - adding;

    try {
      final haltepunkte = await d.rawQuery('''
      SELECT f.LineID, f.LineText, h.StopID, f.MeansOfTransport, h.StopText, 
      h.Longitude, h.Latitude
      FROM wienerlinien_ogd_fahrwegverlaeufe l 
      INNER JOIN wienerlinien_ogd_linien f ON l.LineID = f.LineID 
      INNER JOIN wienerlinien_ogd_haltepunkte h ON l.StopID = h.StopID 
      WHERE h.Longitude BETWEEN $rangeDownLon AND $rangeUpLon 
      AND h.Latitude BETWEEN $rangeDownLat AND $rangeUpLat
          ''');

      final stopID =
          haltepunkte.map((element) => element["StopID"]).toSet().toList();
      final haltepunkteMap = stopID
          .map((item) =>
              haltepunkte.firstWhere((element) => item == element['StopID']))
          .toList();
      print("StopIDs: " + stopID.toString());
      // print(haltepunkteMap);

      return haltepunkteMap;
    } catch (e) {
      print("ERROR FETCHING DATA:" + e.toString());
      return null;
    }
  }

  fetch() async {
    final d = await SqLiteDatabase.database(databaseName);

    try {
      final haltepunkte = await d.rawQuery('''
      SELECT f.LineID, f.LineText, h.StopID, f.MeansOfTransport, h.StopText, 
      h.Longitude, h.Latitude
      FROM wienerlinien_ogd_fahrwegverlaeufe l 
      INNER JOIN wienerlinien_ogd_linien f ON l.LineID = f.LineID 
      INNER JOIN wienerlinien_ogd_haltepunkte h ON l.StopID = h.StopID 
          ''');

      final haltepunkteMap = ignoreUnusedIDs(haltepunkte);

      // print(haltepunkteMap);
      // print(haltepunkteMap.length);
    } catch (e) {
      print("ERROR FETCHING DATA:" + e.toString());
      return null;
    }
  }

  ignoreUnusedIDs(List blob) {
    final lineIDs = blob.map((element) => element["LineID"]).toSet().toList();
    final haltepunkteMap = lineIDs
        .map((item) => blob.firstWhere((element) => item == element['LineID']))
        .toList();

    return haltepunkteMap;
  }
}

// String sequence = '''
// SELECT f.LineID, f.LineText, h.StopID, f.MeansOfTransport, h.StopText,
// h.Longitude, h.Latitude
// FROM wienerlinien_ogd_haltepunkte h
// INNER JOIN wienerlinien_ogd_linien f ON l.LineID = f.LineID
// INNER JOIN wienerlinien_ogd_fahrwegverlaeufe l ON l.StopID = h.StopID
// WHERE StopText LIKE
// ''';
// for (int i = 0; stopTextContainer.length > i; i++) {
//   if (i < stopTextContainer.length - 1) {
//     sequence =
//         sequence + " '%${stopTextContainer[i]}%' OR StopText LIKE ";
//     continue;
//   }
//   sequence = sequence + " '%${stopTextContainer[i]}%' ";
// }
// final q = await d.rawQuery(sequence);
// print(q);
// final stopTextContainer =
// haltepunkte.map((element) => element['StopText']).toSet().toList();
// print("StopText: " + stopTextContainer.toString());
