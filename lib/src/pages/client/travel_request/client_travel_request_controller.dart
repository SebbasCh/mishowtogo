import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mishowtogo/src/models/music.dart';
import 'package:mishowtogo/src/models/travel_info.dart';
import 'package:mishowtogo/src/providers/auth_provider.dart';
import 'package:mishowtogo/src/providers/geofire_provider.dart';
import 'package:mishowtogo/src/providers/music_provider.dart';
import 'package:mishowtogo/src/providers/push_notifications_provider.dart';
import 'package:mishowtogo/src/providers/travel_info_provider.dart';
import 'package:mishowtogo/src/utils/snackbar.dart' as utils;

class ClientTravelRequestController {

  BuildContext context;
  Function refresh;
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();


  String from;
  String to;
  LatLng fromLatLng;
  LatLng toLatLng;

  TravelInfoProvider _travelInfoProvider;
  AuthProvider _authProvider;
  MusicProvider _musicProvider;
  GeofireProvider _geofireProvider;
  PushNotificationsProvider _pushNotificationsProvider;

  Timer _timer;
  int seconds = 30;

  List<String> nearbyMusics  = new List();

  StreamSubscription<List<DocumentSnapshot>> _streamSubscription;
  StreamSubscription<DocumentSnapshot> _streamStatusSubscription;


  Future init(BuildContext context, Function refresh) {
    this.context = context;
    this.refresh = refresh;


    _travelInfoProvider = new TravelInfoProvider();
    _authProvider = new AuthProvider();
    _musicProvider = new MusicProvider();
    _geofireProvider = new GeofireProvider();
    _pushNotificationsProvider = new PushNotificationsProvider();

    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    from = arguments['from'];
    to = arguments['to'];
    fromLatLng = arguments['fromLatLng'];
    toLatLng = arguments['toLatLng'];

    _createTravelInfo();
    _getNearbyMusics();
  }

  void _checkMusicResponse() {
    Stream<DocumentSnapshot> stream = _travelInfoProvider.getByIdStream(_authProvider.getUser().uid);
    _streamStatusSubscription = stream.listen((DocumentSnapshot document) {
      TravelInfo travelInfo = TravelInfo.fromJson(document.data());

      if (travelInfo.idMusic  !=  null && travelInfo.status == 'accepted')  {
        Navigator.pushNamedAndRemoveUntil(context, 'client/travel/map', (route) => false);
      }
      else if (travelInfo.status == 'no_accepted') {
        utils.Snackbar.showSnackbar(context, key, 'El Musico No Acepto Tu Solicitud');

        Future.delayed(Duration(milliseconds: 4000), (){
          Navigator.pushNamedAndRemoveUntil(context, 'client/map', (route) => false);

        });
      }
    });
  }

  void dispose ()  {
    _streamSubscription?.cancel();
    _streamStatusSubscription?.cancel();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      seconds = seconds - 1;
      refresh();
      if (seconds == 0) {
        cancelTravel();
      }
    });
  }

  void cancelTravel() {
    Navigator.pushNamedAndRemoveUntil(context, 'client/map', (route) => false);
  }

  void _getNearbyMusics() {
    Stream<List<DocumentSnapshot>> stream = _geofireProvider.getNearbyMusics(
        fromLatLng.latitude,
        fromLatLng.longitude,
        5
    );

    _streamSubscription = stream.listen((List<DocumentSnapshot> documentlist) {
      for (DocumentSnapshot d in documentlist) {
        print('Musico Encontrado ${d.id}');
        nearbyMusics.add(d.id);
      }
      
      getMusicInfo(nearbyMusics[0]);
      _streamSubscription?.cancel();
    });


  }


  void  _createTravelInfo() async {
    TravelInfo travelInfo = new TravelInfo(
      id: _authProvider.getUser().uid,
      from: from,
      to: to,
      fromLat: fromLatLng.latitude,
      fromLng: fromLatLng.longitude,
      toLat: toLatLng.latitude,
      toLng: toLatLng.longitude,
      status: 'created'
    );
    await _travelInfoProvider.create(travelInfo);
    _checkMusicResponse();
  }

  Future<void> getMusicInfo(String idMusic) async {
    Music music = await _musicProvider.getById(idMusic);
    _sendNotification(music.token);
  }

  void _sendNotification(String token) {
    Map<String, dynamic> data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'idClient': _authProvider.getUser().uid,
      'origin,': from,
      'destination': to,
    };

    _pushNotificationsProvider.sendMessage(token, data, 'Solicitud', 'Un cliente esta solicitando un servicio');

  }

}