import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wienerlinienapp/misc/color_mixin.dart';
import 'package:wienerlinienapp/misc/wienerlinien_maindata_provider.dart';
import 'package:wienerlinienapp/models/station_request_body.dart';
import 'package:wienerlinienapp/widgets/single_station_card.dart';

class MoreInformationScreen extends StatelessWidget with ColorMixin {
  static const routeName = "/more-information-screen";

  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context).settings.arguments as Map<String, Object>;
    final future =
        Provider.of<WienerLinienMaindataProvider>(context, listen: false)
            .fetchFromAPIWithLineNumber(data["stationLine"]);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorMixin.blue,
        actions: [
          IconButton(icon: Icon(Icons.star_border), onPressed: () {}),
        ],
      ),
      body: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final stationRequestBody = snapshot.data as StationRequestBody;
            return Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Image.asset(
                        "assets/images/flexity-nacht-header.jpg",
                        fit: BoxFit.fitWidth,
                      ),
                      Positioned(
                        bottom: 5.0,
                        left: 5.0,
                        child: CircleAvatar(
                          backgroundColor: ColorMixin.blue,
                          maxRadius: 30.0,
                          child: Text(
                            stationRequestBody.lineDetails.first.name,
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
                            stationRequestBody.stationTitle,
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Expanded(
                    child: ListView(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                              stationRequestBody.lineDetails.first.towards),
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
                            ...stationRequestBody.lineDetails.first.departures
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
                      onPressed: () {},
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
            );
          }),
    );
  }
}
