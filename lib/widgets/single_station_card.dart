import 'package:flutter/material.dart';
import 'package:wienerlinienapp/misc/type_specific_attributes_mixin.dart';
import 'package:wienerlinienapp/models/station_request.dart';
import 'package:wienerlinienapp/models/station_request_body.dart';
import 'package:wienerlinienapp/models/station_model.dart';
import 'package:wienerlinienapp/screens/more_information_screen.dart';

class SingleStationCard extends StatefulWidget {
  final StationRequest _stationData;

  SingleStationCard(this._stationData);

  _SingleStationCard createState() => _SingleStationCard();
}

class _SingleStationCard extends State<SingleStationCard> {
  bool _expanded = false;
  DateTime timestamp = DateTime.now();

  _expansionTrigger() {
    setState(() => _expanded = !_expanded);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text(widget._stationData.stationTitle),
            subtitle: Text("Richtung ${widget._stationData.towards ?? "-"}"),
            leading: CircleAvatar(
              backgroundColor: widget._stationData.lineTypeColor,
              child: Text(
                widget._stationData.lineName,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (_expanded)
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...widget._stationData.departures
                      .map((departure) => TimeBox(
                          departure["departureTime"]["countdown"].toString()))
                      .toList()
                      .take(3)
                ],
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton.icon(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                icon: Icon(Icons.access_alarm),
                label: Text("Timetable"),
                onPressed: _expansionTrigger,
              ),
              FlatButton.icon(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                icon: Icon(Icons.info_outline),
                label: Text("More Info"),
                onPressed: () {
                  print("Button pressed: " + widget._stationData.toString());
                  return Navigator.of(context)
                      .pushNamed(MoreInformationScreen.routeName, arguments: {
                    "stationData": widget._stationData,
                    "timestamp": timestamp,
                    "timestampNow": DateTime.now(),
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SingleStationCardOffline extends StatefulWidget {
  final StationModel _stationData;

  SingleStationCardOffline(this._stationData);

  _SingleStationCardOffline createState() => _SingleStationCardOffline();
}

class _SingleStationCardOffline extends State<SingleStationCardOffline>
    with TypeSpecificAttributes {
  bool _expanded = false;

  _expansionTrigger() {
    setState(() => _expanded = !_expanded);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text(widget._stationData.stopText),
            subtitle: Text("Richtung -"),
            leading: CircleAvatar(
              backgroundColor:
                  setTypeColor("ptTram", widget._stationData.lineText).color,
              child: Text(
                widget._stationData.lineText,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (_expanded)
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TimeBox("-"),
                  TimeBox("-"),
                  TimeBox("-"),
                ],
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton.icon(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                icon: Icon(Icons.access_alarm),
                label: Text("Timetable"),
                onPressed: _expansionTrigger,
              ),
              FlatButton.icon(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                icon: Icon(Icons.info_outline),
                label: Text("More Info"),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TimeBox extends StatelessWidget {
  final String _time;

  TimeBox(this._time);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey),
      height: 80,
      width: 80,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _time,
              style: TextStyle(fontSize: 20),
            ),
            Icon(Icons.access_time)
          ],
        ),
      ),
    );
  }
}
