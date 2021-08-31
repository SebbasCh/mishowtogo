import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mishowtogo/src/pages/Login/login_page.dart';
import 'package:mishowtogo/src/pages/client/edit/client_edit_page.dart';
import 'package:mishowtogo/src/pages/client/history/client_history_page.dart';
import 'package:mishowtogo/src/pages/client/history_detail/client_history_detail_page.dart';
import 'package:mishowtogo/src/pages/client/map/client_map_page.dart';
import 'package:mishowtogo/src/pages/client/travel_calification/client_travel_calification_page.dart';
import 'package:mishowtogo/src/pages/client/travel_info/client_travel_info_page.dart';
import 'package:mishowtogo/src/pages/client/travel_map/client_travel_map_page.dart';
import 'package:mishowtogo/src/pages/client/travel_request/client_travel_request_page.dart';
import 'package:mishowtogo/src/pages/home/home_page.dart';
import 'package:mishowtogo/src/pages/client/register/client_register_page.dart';
import 'package:mishowtogo/src/pages/music/edit/music_edit_page.dart';
import 'package:mishowtogo/src/pages/music/map/music_map_page.dart';
import 'package:mishowtogo/src/pages/music/register/music_register_page.dart';
import 'package:mishowtogo/src/pages/music/travel_calification/music_travel_calification_page.dart';
import 'package:mishowtogo/src/pages/music/travel_map/music_travel_map_page.dart';
import 'package:mishowtogo/src/pages/music/travel_request/music_travel_request_page.dart';
import 'package:mishowtogo/src/providers/push_notifications_provider.dart';
import 'package:mishowtogo/src/utils/colors.dart'  as utils;
import 'package:firebase_core/firebase_core.dart';

Future<void> _firebaseMessaginBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessaginBackgroundHandler);
  
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  GlobalKey<NavigatorState> navigatorKey  = new GlobalKey<NavigatorState>();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    PushNotificationsProvider pushNotificationsProvider = new PushNotificationsProvider();
    pushNotificationsProvider.initPushNotifications();

    pushNotificationsProvider.message.listen((data) {

      print('----------------NOTIFICACION-------------');
      print(data);

      navigatorKey.currentState.pushNamed('music/travel/request', arguments: data);

    });

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mi Show To Go',
      navigatorKey: navigatorKey,
      initialRoute: 'home',
      theme: ThemeData(
        fontFamily: 'NimbusSans',
        appBarTheme: AppBarTheme(
          elevation: 0
        ),
        primaryColor: utils.Colors.MiShowToGoColor
      ),
      routes: {
        'home' :(buildcontext) =>  HomePage(),
        'login' :(buildcontext) =>  LoginPage(),
        'client/register' :(buildcontext) =>  ClientRegisterPage(),
        'music/register' :(buildcontext) =>  MusicRegisterPage(),
        'music/map' :(buildcontext) =>  MusicMapPage(),
        'music/travel/request' :(buildcontext) =>  MusicTravelRequestPage(),
        'music/travel/map' :(buildcontext) =>  MusicTravelMapPage(),
        'music/travel/calification' : (BuildContext context) => MusicTravelCalificationPage(),
        'music/edit' : (BuildContext context) => MusicEditPage(),
        'client/map' :(buildcontext) =>  ClientMapPage(),
        'client/travel/info' :(buildcontext) =>  ClientTravelInfoPage(),
        'client/travel/request' :(buildcontext) =>  ClientTravelRequestPage(),
        'client/travel/map' :(buildcontext) =>  ClientTravelMapPage(),
        'client/travel/calification' : (BuildContext context) => ClientTravelCalificationPage(),
        'client/edit' : (BuildContext context) => ClientEditPage(),
        'client/history' : (BuildContext context) => ClientHistoryPage(),
        'client/history/detail' : (BuildContext context) => ClientHistoryDetailPage(),
      },
    );
  }
}
