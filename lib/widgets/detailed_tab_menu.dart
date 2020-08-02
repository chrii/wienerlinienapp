import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wienerlinienapp/misc/wienerlinien_maindata_provider.dart';
import 'package:wienerlinienapp/models/station_request_body.dart';
import 'package:wienerlinienapp/models/traffic_info.dart';
import 'package:wienerlinienapp/widgets/single_station_card.dart';

class DetailedTabMenu extends StatefulWidget {
  final StationRequestBody _stationRequestBody;

  DetailedTabMenu(this._stationRequestBody);

  _DetailedTabMenuState createState() => _DetailedTabMenuState();
}

class _DetailedTabMenuState extends State<DetailedTabMenu> {
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<WienerLinienMaindataProvider>(context, listen: false)
          .getTrafficInfoByRelatedLines(
              widget._stationRequestBody.lineDetails.first.name),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        final List<TrafficInfo> trafficInfo =
            snapshot.data as List<TrafficInfo>;
        final List<TrafficInfo> elevatorInfo = trafficInfo
            .where((item) =>
                item.trafficInfoCategory ==
                TrafficInfoCategory.Aufzugsstoerungen)
            .toList();
        final List<TrafficInfo> constructionInfos = trafficInfo
            .where((item) =>
                item.trafficInfoCategory == TrafficInfoCategory.StoerungKurz ||
                item.trafficInfoCategory == TrafficInfoCategory.StoerungLang)
            .toList();
        print("Const: " + constructionInfos.toString());
        print("Elevator " + elevatorInfo.length.toString());
        print("Barrier " +
            widget._stationRequestBody.lineDetails.first.barrierFree
                .toString());

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
                            ...widget._stationRequestBody.lineDetails.first
                                .departures
                                .map(
                                  (e) => TimeBox(e.countdown.toString()),
                                )
                                .take(3),
                            // if (widget._stationRequestBody.lineDetails.first
                            //         .departures.length <
                            //     3)
                            //   Center(
                            //     child: Text("Yes"),
                            //   ),
                          ],
                        ),
                      ),
                      Center(
                        child: widget._stationRequestBody.lineDetails.first
                                .barrierFree
                            ? ElevatorInfoBuilder(
                                elevatorInfo,
                                widget
                                    ._stationRequestBody.lineDetails.first.name)
                            : Text("Diese Station ist nicht Barrierefrei"),
                      ),
                      Center(
                        child: ConstructionInfoBuilder(constructionInfos),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ElevatorInfoBuilder extends StatelessWidget {
  final List<TrafficInfo> elevatorInfo;
  final String lineName;

  ElevatorInfoBuilder(this.elevatorInfo, this.lineName);

  @override
  Widget build(BuildContext context) {
    return elevatorInfo.length > 0
        ? ListView.builder(
            itemCount: elevatorInfo.length,
            itemBuilder: (context, index) => Card(
              elevation: 3,
              child: ListTile(
                contentPadding: EdgeInsets.all(10.0),
                title: Text(elevatorInfo[index].title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(elevatorInfo[index].description),
                    Divider(),
                    Text(elevatorInfo[index].reason)
                  ],
                ),
              ),
            ),
          )
        : Text("Derzeit keine ausgefallenen Aufzüge auf der Linie $lineName");
  }
}

class ConstructionInfoBuilder extends StatelessWidget {
  final List<TrafficInfo> trafficInfo;

  ConstructionInfoBuilder(this.trafficInfo);

  @override
  Widget build(BuildContext context) {
    return trafficInfo.length <= 0
        ? Text("Derzeit keine Informationen über Störungen vorhanden")
        : ListView.builder(
            itemCount: trafficInfo.length,
            itemBuilder: (context, index) => Card(
              child: ListTile(
                title: Text(trafficInfo[index].title),
              ),
            ),
          );
  }
}
