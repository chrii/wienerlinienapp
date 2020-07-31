import 'package:flutter/material.dart';
import 'package:wienerlinienapp/models/station_request_body.dart';
import 'package:wienerlinienapp/widgets/single_station_card.dart';

class DetailedTabMenu extends StatefulWidget {
  final StationRequestBody _stationRequestBody;

  DetailedTabMenu(this._stationRequestBody);

  _DetailedTabMenuState createState() => _DetailedTabMenuState();
}

class _DetailedTabMenuState extends State<DetailedTabMenu> {
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
                  Center(
                    child: Text("Text"),
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
