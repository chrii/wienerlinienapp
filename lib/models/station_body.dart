class StationRequestBody {
  int steigId;
  int fkLinienId;
  int fkHaltestellenId;
  int reihenfolge;
  int rblNumber;
  int linienId;
  int echtzeit;
  int haltestellenId;
  int diva;
  int gemeindeId;
  String richtung;
  String steig;
  String stand;
  String bezeichnung;
  String verkehrsmittel;
  String typ;
  String name;
  String gemeinde;
  double steigLat;
  double steigLon;
  double lat;
  double lon;

  StationRequestBody(Map<String, dynamic> blob) {
    steigId = blob["STEIG_ID"];
    fkLinienId = blob["FK_LINIEN_ID"];
    fkHaltestellenId = blob["FK_HALTESTELLEN_ID"];
    richtung = blob["RICHTUNG"];
    reihenfolge = blob["REIHENFOLGE"];
    steigLat = blob["STEIG_WGS84_LAT"];
    steigLon = blob["STEIG_WGS84_LON"];
    stand = blob["STAND"];
    linienId = blob["LINIEN_ID"];
    echtzeit = blob["ECHTZEIT"];
    verkehrsmittel = blob["VERKEHRSMITTEL"];
    haltestellenId = blob["HALTESTELLEN_ID"];
    typ = blob["TYP"];
    diva = blob["DIVA"];
    name = blob["NAME"];
    gemeinde = blob["GEMEINDE"];
    gemeindeId = blob["GEMEINDE_ID"];
    lat = blob["WGS84_LAT"];
    lon = blob["WGS84_LON"];

    steig = blob["STEIG"] is int ? blob["STEIG"].toString() : blob["STEIG"];

    bezeichnung = blob["BEZEICHNUNG"] is int
        ? blob["BEZEICHNUNG"].toString()
        : blob["BEZEICHNUNG"];

    rblNumber = blob["RBL_NUMMER"] is String ? null : blob['RBL_NUMMER'];
  }
}
