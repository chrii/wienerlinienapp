import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wienerlinienapp/misc/type_specific_attributes_mixin.dart';
import 'package:wienerlinienapp/misc/wienerlinien_maindata_provider.dart';
import 'package:wienerlinienapp/models/station_request.dart';
import 'package:wienerlinienapp/models/station_request_body.dart';
import 'package:wienerlinienapp/widgets/detailed_tab_menu.dart';

class MoreInformationScreen extends StatefulWidget with TypeSpecificAttributes {
  static const routeName = "/more-information-screen";
  _MoreInformationScreenState createState() => _MoreInformationScreenState();
}

class _MoreInformationScreenState extends State<MoreInformationScreen> {
  StationRequest _stationRequestBody;
  bool _refreshing = true;

  void checkToRefreshData() async {
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    print("Fetching new Data...");
    if (_refreshing) {
      print("Using previous Data...");
      _stationRequestBody = args['stationData'];
    }
  }

  Widget build(BuildContext context) {
    checkToRefreshData();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _stationRequestBody.lineTypeColor ?? Colors.white,
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
                                image:
                                    AssetImage(_stationRequestBody.typeImage),
                                fit: BoxFit.fill),
                          ),
                        ),
                        Positioned(
                          bottom: 5.0,
                          left: 5.0,
                          child: CircleAvatar(
                            backgroundColor: _stationRequestBody.lineTypeColor,
                            maxRadius: 30.0,
                            child: Text(
                              _stationRequestBody.lineName,
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
                          title: Text(_stationRequestBody.towards),
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
                      onPressed: () async {},
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
