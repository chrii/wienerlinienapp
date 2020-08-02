import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wienerlinienapp/misc/database.dart';
import 'package:wienerlinienapp/misc/wienerlinien_maindata_provider.dart';
import 'package:wienerlinienapp/models/traffic_info.dart';
import 'package:wienerlinienapp/screens/app_drawer.dart';
import 'package:wienerlinienapp/screens/more_information_screen.dart';
import 'package:wienerlinienapp/widgets/single_station_card.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
// LineID
// LineText
// StopID
// MeansOfTransport
// StopText
// Longitude
// Latitude

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => WienerLinienMaindataProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: InitWidget(),
        routes: {
          MoreInformationScreen.routeName: (ctx) => MoreInformationScreen(),
        },
      ),
    );
  }
}

class InitWidget extends StatelessWidget {
  Future<bool> _checkInternetAndDatabaseConnectionStatus(
      BuildContext context) async {
    try {
      _checkIfDBExists(context);
      final result = await InternetAddress.lookup("example.com");
      if (result.isNotEmpty || result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } catch (_) {
      print("No Internet connection");
      return false;
    }
  }

  _checkIfDBExists(BuildContext context) async {
    final db = SqLiteDatabase("test");

    final wienerlinienOgdLinien =
        await db.tableExist("wienerlinien_ogd_linien");
    final wienerlinienOgdHaltepunkte =
        await db.tableExist("wienerlinien_ogd_haltepunkte");
    final wienerlinienOgdSteige =
        await db.tableExist("wienerlinien_ogd_steige");
    final wienerlinienOgdFahrwegverlaeufe =
        await db.tableExist("wienerlinien_ogd_fahrwegverlaeufe");

    if (wienerlinienOgdFahrwegverlaeufe &&
        wienerlinienOgdHaltepunkte &&
        wienerlinienOgdSteige &&
        wienerlinienOgdLinien) {
      print('All DBs recognized');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("Nearby"),
      ),
      body: FutureBuilder(
        future: _checkInternetAndDatabaseConnectionStatus(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return snapshot.data ? MainBuilder() : OfflineBuilder();
        },
      ),
    );
  }
}

class OfflineBuilder extends StatelessWidget {
  Future<void> _refresh(BuildContext context) async {
    await Provider.of<WienerLinienMaindataProvider>(context, listen: false)
        .refreshNotifier;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WienerLinienMaindataProvider>(
      builder: (context, provider, _) {
        return RefreshIndicator(
          onRefresh: () async => await _refresh(context),
          child: FutureBuilder(
            future: provider.getNearbyStations(),
            builder: (ctx, snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        SizedBox(height: 0),
                        Expanded(
                          child: ListView.builder(
                            itemCount: provider.nearbyStations.length,
                            itemBuilder: (ctx, i) => SingleStationCardOffline(
                                provider.nearbyStations[i]),
                          ),
                        ),
                      ],
                    );
            },
          ),
        );
      },
    );
  }
}

class MainBuilder extends StatelessWidget {
  Future<void> _refresh(BuildContext context) async {
    await Provider.of<WienerLinienMaindataProvider>(context, listen: false)
        .refreshNotifier;
  }

  @override
  Widget build(BuildContext context) {
    final mock = {
      "refTrafficInfoCategoryId": 1,
      "name": "ftazS_1031271",
      "title": "Donaustadtbrücke",
      "description":
          "U2 Bahnsteig Richtung Karlsplatz - Ausgang Kaisermühlendamm",
      "attributes": {
        "ausBis": "14.08.2020 00:45",
        "reason":
            "Voraussichtlich bis 03.08.2020 außer Betrieb! Auf Ersatzteile wird gewartet.",
        "relatedLines": ["U2"],
        "station": "Donaustadtbrücke",
        "ausVon": "13.08.2020 20:45",
        "location":
            "U2 Bahnsteig Richtung Karlsplatz - Ausgang Kaisermühlendamm",
        "towards": "U2 Karlsplatz",
        "relatedStops": [4255],
        "status": "außer Betrieb"
      },
      "time": {
        "start": "2020-08-13T20:45:00.000+0200",
        "end": "2020-08-14T00:45:00.000+0200"
      },
      "relatedLines": ["U2"],
      "relatedStops": [4255]
    };
    final TrafficInfo tr = TrafficInfo.getTrafficInfoConstructorFromInput(mock);
    print("TrafficInfo: " + tr.description);
    return Consumer<WienerLinienMaindataProvider>(
      builder: (context, provider, _) {
        return RefreshIndicator(
          onRefresh: () async => await _refresh(context),
          child: FutureBuilder(
            future: provider.getNearbyStations(),
            builder: (ctx, snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                      children: [
                        SizedBox(height: 0),
                        Expanded(
                          child: ListView.builder(
                            itemCount: provider.realtime.length,
                            itemBuilder: (ctx, i) =>
                                SingleStationCard(provider.realtime[i]),
                          ),
                        ),
                      ],
                    );
            },
          ),
        );
      },
    );
  }
}
