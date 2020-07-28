import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wienerlinienapp/misc/wienerlinien_maindata_provider.dart';
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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ChangeNotifierProvider(
        create: (ctx) => WienerLinienMaindataProvider(),
        child: InitWidget(),
      ),
      routes: {
        MoreInformationScreen.routeName: (ctx) => MoreInformationScreen(),
      },
    );
  }
}

class InitWidget extends StatelessWidget {
  Future<bool> _checkInternetAndDatabaseConnectionStatus() async {
    try {
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
    // final db = SqLiteDatabase("test");
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("Nearby"),
      ),
      body: FutureBuilder(
        future: _checkInternetAndDatabaseConnectionStatus(),
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
