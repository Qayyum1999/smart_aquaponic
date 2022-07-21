class DHT {
  final double temp;
  final double waterlevel;
  final double fishphlevel;
  final double soilmoisturelevel;
  final double Fishfeeder;
  final double FeedingCount;
  final double SAJstatus;
  final double RAINstatus;
  final double Hydrostatus;
  final double Irrigastatus;

  DHT({this.temp, this.waterlevel, this.fishphlevel,this.soilmoisturelevel,this.SAJstatus, this.FeedingCount,this.Fishfeeder, this.Hydrostatus,this.RAINstatus, this.Irrigastatus});

  factory DHT.fromJson(Map<dynamic, dynamic> json) {
    double parser(dynamic source) {
      try {
        return double.parse(source.toString());
      } on FormatException {
        return -1;
      }
    }
    return DHT(
        temp: parser(json['Temperature']['TempSensor']),
        waterlevel: parser(json['Waterlevel']['WaterSensor']),
        fishphlevel: parser(json['Phlevel']['Fishph']),
        soilmoisturelevel: parser(json['Moisturelevel']['Soilmoisture']),
        Fishfeeder: parser(json['Fishfeeder']),
        FeedingCount: parser(json['FeedingCount']),
        SAJstatus: parser(json['SAJstatus']),
        RAINstatus: parser(json['RAINstatus']),
        Hydrostatus: parser(json['Hydrostatus']),
        Irrigastatus: parser(json['Irrigastatus']),
    );
  }
}
