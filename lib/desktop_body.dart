import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shimmer/shimmer.dart';
import 'circularprogressbar.dart';

import 'jsondata.dart';
import 'notification_service.dart';
import 'globals.dart' as globals;

class MyDesktopBody extends StatefulWidget {
  final String body;
  final String title;

  const MyDesktopBody({Key key, @required this.body, @required this.title}) : super(key: key);
  @override
  _MyDesktopBodyState createState() => _MyDesktopBodyState();
}

class _MyDesktopBodyState extends State<MyDesktopBody> with TickerProviderStateMixin {
  final databaseReference =
  FirebaseDatabase.instance.ref().child('ESP32_Device');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Timer _timer;

  bool isLoading = false;
  bool _isNotified = false;
  bool _isNotified2 = false;
  bool _isNotified3 = false;
  bool _isNotified4 = false;
  bool _isNotified5 = false;
  bool _isNotified6 = false;
  bool _isNotified7 = false;
  bool _isNotified8 = false;
  bool _isNotified9 = false;

  NotificationService _notificationService = NotificationService();

  _MyDesktopBodyState();

  @override
  void initState() {
    super.initState();
    // final Query query = databaseReference.child('ESP32_Device').limitToLast(3);
    // query.onValue.listen((event) {
    //   var snapshot = event.snapshot;
    //   setState(() {
    //     double temp = snapshot.value['Temperature']['TempSensor'];
    //     double waterlevel = snapshot.value['Waterlevel']['WaterSensor'];
    //     double plantphlevel = snapshot.value['Phlevel']['Plantph'];
    //     double fishphlevel = snapshot.value['Phlevel']['Fishph'];
    //
    //     print('Temperature value is $temp');
    //     print('Water level value is $waterlevel');
    //     print('Fish pH level value is $fishphlevel');
    //     print(' Plant pH level value is $plantphlevel');
    //
    //     isLoading = true;
    //     _DashboardInit(temp, waterlevel, fishphlevel, plantphlevel);
    //   });
    // });
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (globals.isLoggedIn) {
        setState(() {});
      }
    });
    _signInAnonymously();

  }

  final Shader linearGradient = LinearGradient(
    colors: <Color>[Colors.blueAccent, Colors.greenAccent],
  ).createShader(Rect.fromLTWH(0.0, 0.0, 250.0, 100.0));

  @override
  void dispose() {
    // _tabController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return globals.isLoggedIn ? mainScaffold() : signInScaffold();
  }

  Widget mainScaffold() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.blue,
          ),
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'SmartQuaDro         ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Roboto',
                  foreground: Paint()..shader = linearGradient,
                ),
              ),
            ],
          ),
          bottom: TabBar(
              isScrollable: true,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.lightBlue,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.lightBlueAccent, Colors.greenAccent]),
                  borderRadius: BorderRadius.circular(50)),
              tabs: [
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("AQUARIUM"),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text("PLANT"),
                  ),
                ),
              ]),
        ),
        body: StreamBuilder(
            stream: databaseReference.onValue,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  !snapshot.hasError &&
                  snapshot.data.snapshot.value != null) {
                var _dht = DHT.fromJson(snapshot.data.snapshot.value);
                isLoading = true;

                print(
                    "DHT: ${_dht.temp} / ${_dht.waterlevel} / ${_dht.fishphlevel}/ ${_dht.soilmoisturelevel}");

                double waterProgress = _dht.waterlevel / 100;
                double tempProgress = _dht.temp / 100;
                double fishphProgress = _dht.fishphlevel / 100;
                double soilmoistureProgress = _dht.soilmoisturelevel / 100;
                print(
                    "Meter progress: $tempProgress / $waterProgress / $fishphProgress/ $soilmoistureProgress");

                Color waterForeground = Colors.lightBlueAccent; //HIGH WATER LEVEL
                Color tempForeground = Colors.blueAccent; //COLD
                Color fishphForeground = Colors.deepOrange; //ACIDIC
                Color soilmoistureForeground = Colors.green; //NICE

                // // Color(0xff360b63);
                String body = "Water Level Alert!";
                String title= "";
                String body3 = "";
                String title3= "pH Alert!";

                //FISH PH COLOR CHANGE
                if (_dht.fishphlevel < 7 ) {
                  //ACIDIC
                  fishphForeground = Colors.red; //VERY  ACIDIC
                  title3 = "pH Alert!";
                  body3= "pH water TOO LOW (acidic)";
                  _isNotified3?foo3():phnotify(body3,title3);
                } else if (_dht.fishphlevel == 7) {
                  //NEUTRAL
                  fishphForeground = Colors.green;
                  title3 = "pH Alert!";
                  body3= "Good pH";
                  _isNotified3?foo3():phnotify(body3,title3);
                } else if (_dht.fishphlevel > 7 && _dht.fishphlevel < 10) {
                  //ALKALI
                  fishphForeground = Colors.lightBlue;
                  title3 = "pH Alert!";
                  body3= "pH water HIGH (alkali)";
                  _isNotified3?foo3():phnotify(body3,title3);
                } else if (_dht.fishphlevel >= 10) {
                  //VERY ALKALINE
                  fishphForeground = Color(0xff360b63);
                  title3 = "pH Alert!";
                  body3= "pH water TOO HIGH (alkali)";
                  _isNotified3?foo3():phnotify(body3,title3);
                }else{
                  title3 = "pH Alert!";
                  body3= "pH water LOW (acidic)";
                  _isNotified3?foo3():phnotify(body3,title3);
                }

                String title5 = "Auto Fish Feeder";
                String body5= "Your Fish has been feed ${_dht.FeedingCount.toInt()} times";
                String FeedingCount = '${_dht.FeedingCount.toInt()}';
                if(_dht.Fishfeeder==1) {
                  _isNotified5?foo5():feedernotify(body5,title5);
                }else{
                  cancelnotif();
                }

                //plant
                String Irrigationstatus = 'OFF';
                Color IrrigationstatusColor= Color.fromRGBO(77, 77, 77, 1.0);
                String Hydroponicstatus = 'OFF';
                Color HydroponicstatusColor= Color.fromRGBO(77, 77, 77, 1.0);

                String title7 = "Hydroponic Pump Status Alert!";
                String body7= "Hydroponic pump is ON";
                if(_dht.Hydrostatus==1) {
                  Hydroponicstatus = 'ON';
                  HydroponicstatusColor= Colors.green;
                  _isNotified7?foo7():SAJnotify(body7,title7);
                }
                else{
                  title7 = "Hydroponic Pump Status Alert!";
                  body7= "Hydroponic pump is OFF";
                  Hydroponicstatus = 'OFF';
                  HydroponicstatusColor= Color.fromRGBO(77, 77, 77, 1.0);
                  _isNotified7?foo7():Hydronotify(body7,title7);
                }

                String title8 = "Irrigation Pump Status Alert!";
                String body8= "Plant is now watering";
                if(_dht.Irrigastatus==1) {
                  Irrigationstatus = 'ON';
                  IrrigationstatusColor= Colors.green;
                }
                else{
                  Irrigationstatus = 'OFF';
                  IrrigationstatusColor= Color.fromRGBO(77, 77, 77, 1.0);
                }

                //STATUS valve
                String rainstatus = 'OFF';
                Color rainstatusColor= Color.fromRGBO(77, 77, 77, 1.0);
                String title6 = "Rain water Availability Alert!";
                String body6= "Rain water is not available. Tap water will be use";
                if(_dht.RAINstatus==0) {
                  _isNotified6?foo6():SAJnotify(body6,title6);
                }
                else {
                  rainstatus = 'ON';
                  rainstatusColor= Colors.green;
                }

                String sajstatus = 'OFF';
                Color sajstatusColor= Color.fromRGBO(77, 77, 77, 1.0);
                if(_dht.SAJstatus==1) {
                  sajstatus = 'ON';
                  sajstatusColor= Colors.green;
                }
                else {
                  sajstatus =  'OFF';
                  sajstatusColor= Color.fromRGBO(77, 77, 77, 1.0);
                }

                return Row(
                  children: [
                    Expanded(
                      child: TabBarView(
                        children: [
                          RefreshIndicator(
                            triggerMode: RefreshIndicatorTriggerMode.onEdge,
                            onRefresh: () async {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => MyDesktopBody(body: body, title: title)));
                            },
                            color: Colors.redAccent,
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                                  child: Center(
                                      child: Container(
                                          height: 180,
                                          width: 180,
                                          child: Image.asset(
                                              "assets/images/aquarium.png"))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(2, 0, 2, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Card(
                                        color: Colors.white,
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(13),
                                          side: BorderSide(
                                            color: Colors.grey.withOpacity(0.2),
                                            width: 3,
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(
                                                      20, 20, 0, 0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        'Live Sensor Monitor',
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w700,
                                                          fontFamily: 'Roboto',
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Icon(
                                                        Icons.rss_feed_outlined,
                                                        size: 20,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Divider(
                                                  indent: 10,
                                                  endIndent: 10,
                                                  thickness: 1,
                                                ),
                                                isLoading
                                                    ? Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Container(
                                                      width: 115,
                                                      height: 115,
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                        child: Stack(
                                                          children: [
                                                            Center(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                                children: <Widget>[
                                                                  Text(
                                                                    'Water Level',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        10),
                                                                  ),
                                                                  Text(
                                                                    '${_dht.waterlevel.toInt()}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        20,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                  ),
                                                                  Text(
                                                                    'L',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        10,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            CircleProgressBar(
                                                              backgroundColor:
                                                              waterForeground
                                                                  .withAlpha(
                                                                  70),
                                                              foregroundColor:
                                                              waterForeground,
                                                              value: waterProgress,
                                                              casenumber: 1,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    //WATER METER
                                                    Container(
                                                      width: 115,
                                                      height: 115,
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                        child: Stack(
                                                          children: [
                                                            Center(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                                children: <Widget>[
                                                                  Text(
                                                                    'Temperature',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        10),
                                                                  ),
                                                                  Text(
                                                                    '${_dht.temp.toInt()}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        20,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                  ),
                                                                  Text(
                                                                    '°C',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        10,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            CircleProgressBar(
                                                              backgroundColor:
                                                              tempForeground
                                                                  .withAlpha(
                                                                  70),
                                                              foregroundColor:
                                                              tempForeground,
                                                              value: tempProgress,
                                                              casenumber: 2,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    //TEMPERATURE
                                                    Container(
                                                      width: 115,
                                                      height: 115,
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                        child: Stack(
                                                          children: [
                                                            Center(
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                                children: <Widget>[
                                                                  Text(
                                                                    'pH',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        10),
                                                                  ),
                                                                  maxfishphLimit(
                                                                      _dht),
                                                                  Text(
                                                                    ' ',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        10,
                                                                        fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            CircleProgressBar(
                                                              backgroundColor:
                                                              fishphForeground
                                                                  .withAlpha(
                                                                  70),
                                                              foregroundColor:
                                                              fishphForeground,
                                                              value: fishphProgress,
                                                              casenumber: 3,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    //PH
                                                  ],
                                                )
                                                    : Center(
                                                    child: Padding(
                                                      padding:
                                                      const EdgeInsets.all(20.0),
                                                      child:
                                                      CircularProgressIndicator(),
                                                    )),
                                                Center(
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets.only(
                                                                left: 0.0),
                                                            child: Container(
                                                              height: 17,
                                                              width: 100,
                                                              child: Center(
                                                                  child: getWaterTanktext(
                                                                      _dht)),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets.only(
                                                                left: 0.0),
                                                            child: Container(
                                                              height: 17,
                                                              width: 100,
                                                              child: Center(
                                                                  child: getTempTextcolor(
                                                                      _dht)),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets.only(
                                                                left: 0.0),
                                                            child: Container(
                                                              height: 17,
                                                              width: 100,
                                                              child: Center(
                                                                  child:
                                                                  getFishphTextColor(
                                                                      _dht)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Divider(
                                                        indent: 10,
                                                        endIndent: 10,
                                                        thickness: 1,
                                                      ),
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.fromLTRB(
                                                            20, 0, 0, 0),
                                                        child: new Row(
                                                          children: [
                                                            Text(
                                                              'Overall System: ',
                                                              style: TextStyle(
                                                                color: Colors.black,
                                                                fontWeight:
                                                                FontWeight.w700,
                                                                fontFamily: 'Roboto',
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                            getOverallSystemText(_dht),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                    ],
                                                  ),
                                                ), //METER STATUS FEEDBACK
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Card(
                                        color: Colors.white,
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(13),
                                          side: BorderSide(
                                            color: Colors.grey.withOpacity(0.2),
                                            width: 3,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(
                                                  20, 20, 0, 0),
                                              child: Text(
                                                'Auto Fish Feeder',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Roboto',
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                margin: EdgeInsets.all(10),
                                                padding: EdgeInsets.all(10),
                                                width: 130,
                                                height: 130,
                                                child: Center(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Text(
                                                        'Fish is fed',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w700,
                                                          fontFamily: 'Roboto',
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      Text(
                                                        FeedingCount,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w700,
                                                          fontFamily: 'Roboto',
                                                          fontSize:43,
                                                        ),
                                                      ),
                                                      Text(
                                                        'times today',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w700,
                                                          fontFamily: 'Roboto',
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  gradient: LinearGradient(
                                                      colors: [Colors.lightBlueAccent, Colors.greenAccent]),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Card(
                                        color: Colors.white,
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(13),
                                          side: BorderSide(
                                            color: Colors.grey.withOpacity(0.2),
                                            width: 3,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(
                                                  20, 20, 0, 0),
                                              child: Text(
                                                'Valve Status',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Roboto',
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.all(10),
                                                    padding: EdgeInsets.all(10),
                                                    width: 130,
                                                    height: 50,
                                                    decoration:  BoxDecoration(
                                                      // color: Color.fromRGBO(77, 77, 77, 1.0),
                                                      color: rainstatusColor,
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(22.0), // radius
                                                      ),
                                                    ),
                                                    child:  Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          'RAIN VALVE',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w700,
                                                            fontFamily: 'Roboto',
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        Text(
                                                          rainstatus,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w700,
                                                            fontFamily: 'Roboto',
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.all(10),
                                                    padding: EdgeInsets.all(10),
                                                    width: 130,
                                                    height: 50,
                                                    decoration:  BoxDecoration(
                                                      // color: Color.fromRGBO(77, 77, 77, 1.0),
                                                      color: sajstatusColor,
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(22.0), // radius
                                                      ),
                                                    ),
                                                    child:  Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          'SAJ VALVE',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w700,
                                                            fontFamily: 'Roboto',
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        Text(
                                                          sajstatus,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w700,
                                                            fontFamily: 'Roboto',
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),//livemonitor
                                SizedBox( height: 10.0),
                              ],
                            ),
                          ),
                          RefreshIndicator(
                            triggerMode: RefreshIndicatorTriggerMode.onEdge,
                            onRefresh: () async {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) => MyDesktopBody(body: body, title: title)));
                            },
                            color: Colors.redAccent,
                            child: ListView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Center(
                                      child: Container(
                                          height: 200,
                                          width: 200,
                                          child: Stack(
                                            children: [
                                              Image.asset(
                                                "assets/images/plant.png",
                                              ),
                                            ],
                                          ))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(2, 10, 2, 0),
                                  child: Card(
                                    color: Colors.white,
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),
                                      side: BorderSide(
                                        color: Colors.grey.withOpacity(0.2),
                                        width: 3,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                          const EdgeInsets.fromLTRB(20, 20, 0, 0),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Live Sensor Monitor',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Roboto',
                                                  fontSize: 18,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Icon(
                                                Icons.rss_feed_outlined,
                                                size: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          indent: 10,
                                          endIndent: 10,
                                          thickness: 1,
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                20, 0, 0, 0),
                                            child: isLoading
                                                ? Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 115,
                                                  height: 115,
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.all(
                                                        20.0),
                                                    child: Stack(
                                                      children: [
                                                        Center(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            children: <Widget>[
                                                              Text(
                                                                'Moisture',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    10),
                                                              ),
                                                              Text(
                                                                '${_dht.soilmoisturelevel.toInt()}',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    20,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                              ),
                                                              Text(
                                                                ' ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                    10,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        CircleProgressBar(
                                                          backgroundColor:
                                                          soilmoistureForeground
                                                              .withAlpha(
                                                              70),
                                                          foregroundColor:
                                                          soilmoistureForeground,
                                                          value:
                                                          soilmoistureProgress,
                                                          casenumber: 4,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                                : Center(
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.all(20.0),
                                                  child:
                                                  CircularProgressIndicator(),
                                                )),
                                          ),
                                        ),
                                        Center(
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(
                                                        left: 32.0),
                                                    child: Container(
                                                      height: 17,
                                                      width: 100,
                                                      child: Center(
                                                          child:
                                                          getPlantMoistureTextColor(
                                                              _dht)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Divider(
                                                indent: 10,
                                                endIndent: 10,
                                                thickness: 1,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(
                                                    20, 0, 0, 0),
                                                child: new Row(
                                                  children: [
                                                    Text(
                                                      'Overall System: ',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w700,
                                                        fontFamily: 'Roboto',
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    getOverallSystemText(_dht),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          ),
                                        ), //METER STATUS FEEDBACK
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0,15, 0, 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Card(
                                        color: Colors.white,
                                        elevation: 4,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(13),
                                          side: BorderSide(
                                            color: Colors.grey.withOpacity(0.2),
                                            width: 3,
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                              child: Text(
                                                'Pump Status',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: 'Roboto',
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.all(10),
                                                    padding: EdgeInsets.all(10),
                                                    width: 200,
                                                    height: 50,
                                                    decoration:  BoxDecoration(
                                                      // color: Color.fromRGBO(77, 77, 77, 1.0),
                                                      color: HydroponicstatusColor,
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(22.0), // radius
                                                      ),
                                                    ),
                                                    child:  Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          'HYDROPONIC PUMP',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w700,
                                                            fontFamily: 'Roboto',
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        Text(
                                                          Hydroponicstatus,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w700,
                                                            fontFamily: 'Roboto',
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.all(10),
                                                    padding: EdgeInsets.all(10),
                                                    width: 200,
                                                    height: 50,
                                                    decoration:  BoxDecoration(
                                                      // color: Color.fromRGBO(77, 77, 77, 1.0),
                                                      color: IrrigationstatusColor,
                                                      borderRadius: BorderRadius.all(
                                                        Radius.circular(22.0), // radius
                                                      ),
                                                    ),
                                                    child:  Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text(
                                                          'IRRIGATION PUMP',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w700,
                                                            fontFamily: 'Roboto',
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        Text(
                                                          Irrigationstatus,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w700,
                                                            fontFamily: 'Roboto',
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
              return ListView(
                children: [
                  Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                          child: Center(
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[300],
                              highlightColor: Colors.grey[100],
                              child: Container(
                                height: 180.0,
                                width: 180.0,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                              ),
                            ),
                          )),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300],
                            highlightColor: Colors.grey[100],
                            child: Container(
                              height: 24.0,
                              width: 250.0,
                              color: Colors.grey[300],
                            ),
                          )),
                      Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 90.0,
                                      width: 90.0,
                                      decoration: new BoxDecoration(
                                        color: Colors.grey[300],
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      child: Container(
                                        height: 24.0,
                                        width: 80.0,
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 90.0,
                                      width: 90.0,
                                      decoration: new BoxDecoration(
                                        color: Colors.grey[300],
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      child: Container(
                                        height: 24.0,
                                        width: 80.0,
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 90.0,
                                      width: 90.0,
                                      decoration: new BoxDecoration(
                                        color: Colors.grey[300],
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                      child: Container(
                                        height: 24.0,
                                        width: 80.0,
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300],
                            highlightColor: Colors.grey[100],
                            child: Container(
                              height: 24.0,
                              width: 250.0,
                              color: Colors.grey[300],
                            ),
                          )),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300],
                            highlightColor: Colors.grey[100],
                            child: Container(
                              height: 12.0,
                              width: 230.0,
                              color: Colors.grey[300],
                            ),
                          )),

                    ],
                  ),
                ],
              );
            }),
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width *
              0.60, // 75% of screen will be occupied
          child: Drawer(
            child: Column(
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.lightGreenAccent,
                          Colors.blueAccent,
                        ],
                      )),
                  child: Center(
                    child: Text(
                      'Hello User!',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        fontSize: 28,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Info'),
                      content: const Text(
                          'SmartQuaDro is a Smart Aquaponic and Hydroponic app integrated with IoT. It is use with an Aquaponic system hardware installed with NodeMCU ESP8266.\n\nIt is a product designed by smart people for smart people.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  ),
                  child: Card(
                    child: Container(
                      height: 50,
                      width: 500,
                      child: Center(
                        child: Text(
                          'Info       ',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('About Us'),
                      content: const Text(
                          'Our passionate and hardworking team members\n\n\n'
                              'Qayyum Razali - Programming\n'
                              'Fikkri Sarif - Mechanical\n'
                              'Anis Nadiah - Mechanical\n'
                              'Hisyam Saad - Electrical\n'
                              'Nur Hanan - Mechanical\n'
                              'Aliah Izzati - Mechanical\n'
                              'Ahlam Forqan - Mechanical\n'
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  ),
                  child: Card(
                    child: Container(
                      height: 50,
                      width: 500,
                      child: Center(
                        child: Text(
                          'About Us       ',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(child: Container()),
                // Add this to force the bottom items to the lowest point
                Column(
                  children: [
                    Divider(),
                    // ListTile(
                    //     leading: Icon(Icons.settings),
                    //     title: Text('Settings')),

                    ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.logout_outlined,
                          size: 25,
                        ),
                      ),
                      title: TextButton(
                        child: Text(
                          'Log Out',
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                            fontSize: 16,
                          ),
                        ),
                        onPressed: () async {
                          _signOut();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text getWaterTanktext(DHT _dht) {
    double watertanklevel = _dht.waterlevel;
    if (watertanklevel < 18) {
      //NORMAL
      return Text(
        'LOW',
        style: TextStyle(
          color: Colors.deepOrange,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
          fontSize: 15,
        ),
      );
    } else if (watertanklevel >= 18 && (watertanklevel < 26)) {
      //WARM
      return Text(
        'GOOD',
        style: TextStyle(
          color: Colors.lightBlueAccent,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
          fontSize: 15,
        ),
      );
    } else if (watertanklevel >= 26 && (watertanklevel < 31)) {
      //WARM
      return Text(
        'HIGH',
        style: TextStyle(
          color: Colors.lightBlue,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
          fontSize: 15,
        ),
      );
    } else {
      //WARM
      return Text(
        'FULL',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
          fontSize: 15,
        ),
      );
    }
  }

  Widget getTempTextcolor(DHT _dht) {
    double tempvalue = _dht.temp;
    if (tempvalue >= 10 && tempvalue < 20) {
      //COLD
      return Text(
        'COOL',
        style: TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
          fontSize: 15,
        ),
      );
    } else if (tempvalue >= 20 && tempvalue < 30) {
      //NORMAL
      return Text(
        'NORMAL',
        style: TextStyle(
          color: Colors.lightBlueAccent,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
          fontSize: 15,
        ),
      );
    } else if (tempvalue >= 30 && tempvalue < 40) {
      //WARM
      return Text(
        'WARM',
        style: TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
          fontSize: 15,
        ),
      );
    } else if (tempvalue >= 40) {
      //HOT
      return Text(
        'HOT',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
          fontSize: 15,
        ),
      );
    } else {
      //COLD
      return Text(
        'FREEZING',
        style: TextStyle(
          color: Color(0xFF000080),
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
          fontSize: 15,
        ),
      );
    }
  }

  Text getFishphTextColor(DHT _dht) {
    double fishphvalue = _dht.fishphlevel;
    if (fishphvalue >= 4 && fishphvalue < 7) {
      //NORMAL
      return Text(
        'ACIDIC',
        style: TextStyle(
          color: Colors.deepOrange,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
          fontSize: 15,
        ),
      );
    } else if (fishphvalue == 7.0) {
      //WARM
      return Text(
        'NEUTRAL',
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
          fontSize: 15,
        ),
      );
    } else if (fishphvalue > 7 && fishphvalue < 10) {
      //HOT
      return Text(
        'ALKALINE',
        style: TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
          fontSize: 15,
        ),
      );
    } else if (fishphvalue >= 10) {
      //COLD
      return Text(
        'ALKALINE',
        style: TextStyle(
          color: Color(0xff360b63),
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
          fontSize: 15,
        ),
      );
    } else {
      return Text(
        'ACIDIC',
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
          fontSize: 15,
        ),
      );
    }
  }

  Text getPlantMoistureTextColor(DHT _dht) {
    double soilmoisturevalue = _dht.soilmoisturelevel;
    if (soilmoisturevalue >= 1000) {
      //NORMAL
      return Text(
        'TOO DRY',
        style: TextStyle(
          color: Colors.orangeAccent,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
          fontSize: 15,
        ),
      );
    } else if (soilmoisturevalue >= 600 && soilmoisturevalue < 1000) {
      //WARM
      return Text(
        'DRY',
        style: TextStyle(
          color: Colors.yellow,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
          fontSize: 15,
        ),
      );
    } else if (soilmoisturevalue >= 300 && soilmoisturevalue < 600) {
      //WARM
      return Text(
        'NICE',
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
          fontSize: 15,
        ),
      );
    } else {
      return Text(
        'WET',
        style: TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.w700,
          fontFamily: 'Roboto',
          fontSize: 15,
        ),
      );
    }
  }

  Widget getOverallSystemText(DHT _dht) {
    String labeloverall;
    double value1 = _dht.waterlevel;
    double value2 = _dht.temp;
    double value3 = _dht.fishphlevel;
    double value4 = _dht.soilmoisturelevel;

    if ((value1 >= 18) &&
        (value2 >= 20 && value2 <= 30) &&
        (value3 == 7) &&
        (value4 >= 400 && value4 <= 500)) {
      //IDEAL SYSTEM
      // water more than half, temperature room, fishph neutral,
      labeloverall = 'PERFECT';
    } else if ((value1 >= 18) &&
        (value2 >= 20 && value2 <= 30) &&
        (value3 >= 6.8 && value3 <= 7.8) &&
        (value4 >= 300 && value4 < 600)) {
      //GOOD SYSTEM
      // water less than half, temperature room, fishph neutral,//since fish can live btween 6.8-7.8 ph
      labeloverall = 'GOOD';
    }
    else {
      labeloverall = 'MAINTAINING';
    }
    return Text(
      labeloverall ?? '...', //If null show ...
      style: TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.w700,
        fontFamily: 'Roboto',
        fontSize: 15,
      ),
    );
  }

  //To limit the meter maximum value
  Text maxfishphLimit(DHT _dht) {
    double maxvalue = _dht.fishphlevel;
    if (maxvalue >= 14) {
      return Text(
        '14',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      );
    } else
      return Text(
        '${_dht.fishphlevel.toStringAsFixed(1)}',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      );
  }

  _signOut() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      globals.isLoggedIn = false;
    });
  }

  Widget signInScaffold() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: height,
          width: width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40.0,
                ),
                Container(
                  width: 200,
                  height: 200,
                  child: Icon(
                    Icons.face_outlined,
                    size: 150,
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xff43cea2), Color(0xff185a9d)],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Hello,\nWelcome Back',
                        style: TextStyle(
                            fontSize: 35.0, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                    suffixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    suffixIcon: Icon(Icons.visibility_off),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Forget password?',
                        style: TextStyle(fontSize: 12.0),
                      ),
                      ElevatedButton(
                        child: Text('Login'),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xffEE7B23),
                        ),
                        onPressed: () async {
                          _signInAnonymously();
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () {},
                  child: Text.rich(
                    TextSpan(text: 'Don\'t have an account  ', children: [
                      TextSpan(
                        text: 'Signup',
                        style: TextStyle(color: Color(0xffEE7B23)),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signInAnonymously() async {
    final User user = (await _auth.signInAnonymously()).user;
    print("*** user isAnonymous: ${user.isAnonymous}");
    print("*** user uid: ${user.uid}");

    setState(() {
      if (user != null) {
        globals.isLoggedIn = true;
      } else {
        globals.isLoggedIn = false;
      }
    });
  }

  void waternotify(String body,String title) async {
    // Do some stuff here
    _isNotified = true;
  }
  void temperaturenotify(String body,String title) async {
    // Do some stuff here
    // await _notificationService.showNotifications2(body,title);
    _isNotified2 = true;
  }
  void phnotify(String body,String title) async {
    // Do some stuff here
    await _notificationService.showNotifications3(body,title);
    _isNotified3 = true;
  }
  void soilnotify(String body,String title) async {
    // Do some stuff here
    // await _notificationService.showNotifications4(body,title);
    _isNotified4 = true;
  }
  void feedernotify(String body,String title) async {
    // Do some stuff here
    // await _notificationService.showNotifications5(body,title);
    _isNotified5 = true;
  }
  void SAJnotify(String body,String title) async {
    // Do some stuff here
    // await _notificationService.showNotifications6(body,title);
    _isNotified6 = true;
  }
  void Hydronotify(String body,String title) async {
    // Do some stuff here
    // await _notificationService.showNotifications7(body,title);
    _isNotified7 = true;
  }
  void cancelnotif() async {
    // Do some stuff here
    await _notificationService.cancelNotifications(0);
  }
  void foo()  {
    // Do some stuff here
    Timer(Duration(seconds: 60), () {
      _isNotified = false;
    });}
  void foo2(){
    // Do some stuff here
    Timer(Duration(seconds: 60), () {
      _isNotified2 = false;
    });}
  void foo3() {
    // Do some stuff here
    Timer(Duration(seconds: 60), () {
      _isNotified3 = false;
    });}
  void foo4() {
    // Do some stuff here
    Timer(Duration(seconds: 60), () {
      _isNotified4 = false;
    });}
  void foo5() {
    // Do some stuff here
    Timer(Duration(seconds: 60), () {
      _isNotified5 = false;
    });}
  void foo6() {
    // Do some stuff here
    Timer(Duration(seconds: 30), () {
      _isNotified6 = false;
    });}
  void foo7() {
    // Do some stuff here
    Timer(Duration(seconds: 30), () {
      _isNotified7 = false;
    });}

}
