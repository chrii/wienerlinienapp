import 'package:flutter/material.dart';
import 'package:wienerlinienapp/misc/color_mixin.dart';
import 'package:wienerlinienapp/widgets/single_station_card.dart';

class MoreInformationScreen extends StatelessWidget with ColorMixin {
  static const routeName = "/more-information-screen";

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorMixin.blue,
        actions: [
          IconButton(icon: Icon(Icons.star_border), onPressed: () {}),
        ],
      ),
      body: Column(
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
                      "44",
                      style: TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                Positioned(
                  right: 10.0,
                  bottom: 15.0,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                    decoration: BoxDecoration(color: Colors.black54),
                    child: Text(
                      "Maroltingergasse",
                      style: TextStyle(fontSize: 20.0, color: Colors.white),
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
                    title: Text("Ottakring"),
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
                      TimeBox("3"),
                      TimeBox("6"),
                      TimeBox("9"),
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
      ),
    );
  }
}
