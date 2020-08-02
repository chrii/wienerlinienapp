import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wienerlinienapp/misc/database.dart';
import 'package:wienerlinienapp/misc/wienerlinien_maindata_provider.dart';
import 'package:wienerlinienapp/models/station_request.dart';
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
      // _checkIfDBExists(context);
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

class MainBuilder extends StatefulWidget {
  _MainBuilderState createState() => _MainBuilderState();
}

class _MainBuilderState extends State<MainBuilder> {
  List<StationRequest> _stationRequest;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<WienerLinienMaindataProvider>(context, listen: false)
          .fetchAllNearbyStationsFromAPI(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        _stationRequest = snapshot.data as List<StationRequest>;
        return RefreshIndicator(
          onRefresh: () async {
            try {
              final response = await Provider.of<WienerLinienMaindataProvider>(
                      context,
                      listen: false)
                  .fetchAllNearbyStationsFromAPI();
              _stationRequest = response;
              setState(() => _stationRequest = response);
            } catch (e) {
              print("Error refreshing Data: " + e.toString());
            }
          },
          child: Column(
            children: [
              SizedBox(height: 0),
              Expanded(
                child: _stationRequest.length <= 0
                    ? Center(
                        child: Text(
                            "Derzeit keine Stationen in der Nähe oder  keine Daten verfügbar"),
                      )
                    : ListView.builder(
                        itemCount: _stationRequest.length,
                        itemBuilder: (ctx, i) =>
                            // SingleStationCard(_stationRequest[i]),
                            Text("Henlo: " + i.toString()),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
