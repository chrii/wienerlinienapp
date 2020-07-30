import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wienerlinienapp/misc/type_specific_attributes_mixin.dart';
import 'package:wienerlinienapp/misc/wienerlinien_maindata_provider.dart';
import 'package:wienerlinienapp/models/station_request_body.dart';
import 'package:wienerlinienapp/widgets/single_station_card.dart';

class MoreInformationScreen extends StatefulWidget with TypeSpecificAttributes {
  static const routeName = "/more-information-screen";
  _MoreInformationScreenState createState() => _MoreInformationScreenState();
}

class _MoreInformationScreenState extends State<MoreInformationScreen> {
  StationRequestBody _stationRequestBody;
  bool _refreshing = true;

  void checkToRefreshData() async {
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    final timestamp = args['timestamp'] as DateTime;
    final timestampNow = args['timestampNow'] as DateTime;
    print(timestamp);
    print(timestampNow);
    if (false) {
      print("Fetching new Data...");
      final stationRequestBody =
          await Provider.of<WienerLinienMaindataProvider>(context,
                  listen: false)
              .fetchFromAPIWithLineNumber(args["stationLine"]);
      setState(() {
        _stationRequestBody = stationRequestBody;
      });
    }
    if (_refreshing) {
      print("Using previous Data...");
      _stationRequestBody = args['stationLine'];
    }
  }

  Widget build(BuildContext context) {
    Provider.of<WienerLinienMaindataProvider>(context, listen: false)
        .stoerungUeberZeit();
    checkToRefreshData();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _stationRequestBody.lineDetails.first.lineTypeColor,
        actions: [
          IconButton(icon: Icon(Icons.star_border), onPressed: () {}),
        ],
      ),
      body: _stationRequestBody == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.tight,
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(_stationRequestBody
                                    .lineDetails.first.typeImage),
                                fit: BoxFit.fill),
                          ),
                        ),
                        Positioned(
                          bottom: 5.0,
                          left: 5.0,
                          child: CircleAvatar(
                            backgroundColor: _stationRequestBody
                                .lineDetails.first.lineTypeColor,
                            maxRadius: 30.0,
                            child: Text(
                              _stationRequestBody.lineDetails.first.name,
                              style: TextStyle(fontSize: 28),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 10.0,
                          bottom: 15.0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 3.0),
                            decoration: BoxDecoration(color: Colors.black54),
                            child: Text(
                              _stationRequestBody.stationTitle,
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  child: Expanded(
                    flex: 6,
                    child: ListView(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                              _stationRequestBody.lineDetails.first.towards),
                          subtitle: Text("Richtung"),
                          trailing: Icon(Icons.compare_arrows),
                        ),
                        Divider(),
                        DetailedTabMenu(_stationRequestBody),
                        Divider(),
                      ],
                    ),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlatButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.arrow_left),
                      label: Text("Vorige"),
                      textColor: Colors.black87,
                    ),
                    IconButton(
                      onPressed: () async {
                        final res = await Provider.of<
                                    WienerLinienMaindataProvider>(context,
                                listen: false)
                            .fetchFromAPIWithLineNumber(_stationRequestBody);
                        setState(() => _stationRequestBody = res);
                        _refreshing = false;
                      },
                      icon: Icon(Icons.refresh),
                    ),
                    FlatButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.arrow_right),
                      label: Text("Nächste"),
                      textColor: Colors.black87,
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

class DetailedTabMenu extends StatefulWidget {
  final StationRequestBody _stationRequestBody;

  DetailedTabMenu(this._stationRequestBody);

  _DetailedTabMenuState createState() => _DetailedTabMenuState();
}

class _DetailedTabMenuState extends State<DetailedTabMenu> {
  Object _lines;

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: SizedBox(
        height: 300,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 0,
              child: Container(
                height: 40,
                width: double.infinity,
                child: TabBar(
                  labelColor: Colors.black38,
                  indicatorColor: widget
                      ._stationRequestBody.lineDetails.first.lineTypeColor,
                  tabs: <Widget>[
                    Tab(
                      icon: Icon(Icons.timer),
                    ),
                    Tab(
                      icon: Icon(Icons.accessible),
                    ),
                    Tab(
                      icon: Icon(Icons.offline_bolt),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ...widget
                            ._stationRequestBody.lineDetails.first.departures
                            .map(
                              (e) => TimeBox(e.countdown.toString()),
                            )
                            .take(3),
                        if (widget._stationRequestBody.lineDetails.first
                                .departures.length <
                            3)
                          Center(
                            child: Text("Yes"),
                          ),
                      ],
                    ),
                  ),
                  Center(
                    child: !widget
                            ._stationRequestBody.lineDetails.first.barrierFree
                        ? Text("Diese Station ist nicht Barrierefrei")
                        : Text(
                            "Hier erhalten Sie Informationen zu ausgefallenen Aufzügen"),
                  ),
                  Consumer<WienerLinienMaindataProvider>(
                    builder: (context, value, child) {
                      return FutureBuilder(
                        future: value.stoerungAusLinienListe(
                            widget._stationRequestBody.lineDetails.first.name),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting)
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          if (snapshot.data.length == 0)
                            return Center(
                              child: Text("Keine Störungen aufgezeichnet"),
                            );
                          return Center(
                            child: Text(snapshot.data.first["title"] + ",  "),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
