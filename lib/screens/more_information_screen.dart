import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wienerlinienapp/misc/type_specific_attributes.dart';
import 'package:wienerlinienapp/misc/wienerlinien_maindata_provider.dart';
import 'package:wienerlinienapp/models/station_request_body.dart';
import 'package:wienerlinienapp/widgets/single_station_card.dart';

class MoreInformationScreen extends StatefulWidget with TypeSpecificAttributes {
  static const routeName = "/more-information-screen";
  _MoreInformationScreenState createState() => _MoreInformationScreenState();
}

class _MoreInformationScreenState extends State<MoreInformationScreen> {
  StationRequestBody _stationRequestBody;
  DateTime _timer = DateTime.now();
  bool _refreshing = true;

  @override
  void initState() {
    _timer = DateTime.now();
    super.initState();
  }

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
                  flex: 0,
                  child: Container(
                    //width: double.infinity,^
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Image.asset(
                          _stationRequestBody.lineDetails.first.typeImage,
                          fit: BoxFit.cover,
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
                    flex: 9,
                    child: ListView(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                              _stationRequestBody.lineDetails.first.towards),
                          subtitle: Text("Richtung"),
                          trailing: Icon(Icons.compare_arrows),
                        ),
                        Divider(),
                        ButtonBar(
                          alignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                              disabledColor: Colors.black,
                              icon: Icon(Icons.accessible),
                              onPressed: null,
                              iconSize: 30.0,
                            ),
                            Divider(),
                            IconButton(
                              disabledColor: Colors.black,
                              icon: Icon(Icons.offline_bolt),
                              onPressed: null,
                              iconSize: 30.0,
                            ),
                            Divider(),
                            IconButton(
                              disabledColor: Colors.black,
                              icon: Icon(Icons.timer),
                              onPressed: null,
                              color: Colors.black,
                              iconSize: 30.0,
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            ..._stationRequestBody.lineDetails.first.departures
                                .map(
                                  (e) => TimeBox(e.countdown.toString()),
                                )
                                .take(3),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 0,
                  fit: FlexFit.loose,
                  child: ButtonBar(
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
                ),
              ],
            ),
    );
  }
}
