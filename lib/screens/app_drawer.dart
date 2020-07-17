import 'package:flutter/material.dart';
import 'package:wienerlinienapp/misc/database.dart';

class AppDrawer extends StatelessWidget {
  _prepareDatabase(SqLiteDatabase db) {
    final List<String> pathList = [
      "assets/csv/wienerlinien-ogd-linien.csv",
      "assets/csv/wienerlinien-ogd-haltepunkte.csv",
      "assets/csv/wienerlinien-ogd-steige.csv",
      "assets/csv/wienerlinien-ogd-fahrwegverlaeufe.csv"
    ];

    db.importCsvListToDatabaseTables(pathList);
  }

  @override
  Widget build(BuildContext context) {
    final db = SqLiteDatabase("test");
    return Drawer(
      elevation: 2.0,
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text("Hello"),
            automaticallyImplyLeading: true,
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Home"),
            onTap: () => Navigator.of(context).pushReplacementNamed("/"),
          ),
          Divider(),
          Text("DEBUG OPTIONS"),
          Divider(),
          FlatButton(
              onPressed: () => _prepareDatabase(db),
              child: Text("createTable")),
          FlatButton(
              //48.231338, 16.352092
              //48.213874, 16.326090
              onPressed: () =>
                  db.fetchCoordinateRangeFromDatabase(48.213601, 16.326032),
              child: Text("coordinateFunction")),
          FlatButton(
              //48.231338, 16.352092
              onPressed: () => db.fetch(),
              child: Text("fetchRandom")),
          FlatButton(
              onPressed: () {
                db.dropTable("wienerlinien_ogd_linien");
                db.dropTable("wienerlinien_ogd_haltepunkte");
                db.dropTable("wienerlinien_ogd_steige");
                db.dropTable("wienerlinien_ogd_fahrwegverlaeufe");
              },
              child: Text("drop")),
          FlatButton(
              onPressed: () {
                print(db.stations);
              },
              child: Text("maindata")),
        ],
      ),
    );
  }
}
