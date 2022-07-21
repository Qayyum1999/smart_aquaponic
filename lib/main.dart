
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Dashboard.dart';
import 'notification_service.dart';
import 'responsive_layout.dart';
import 'desktop_body.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
// Replace with actual values
      options: const FirebaseOptions(
        apiKey: "AIzaSyBzsRC_0yyaLJvOJ4UdM4bfY2tITsRdbTk",
        appId: "1:112694300547:android:4fe7ab192e81557322f0b6",
        projectId: "flutteriot-1b30d",
        databaseURL: "https://flutteriot-1b30d-default-rtdb.asia-southeast1.firebasedatabase.app/", // Realtime Database
      ),);
      NotificationService().init();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SmartQuaDro App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ResponsiveLayout( //dashboards layout
          mobileBody: MyMobileBody(),
          desktopBody: MyDesktopBody(),
        ),
        debugShowCheckedModeBanner: false,
      );
  }
}
