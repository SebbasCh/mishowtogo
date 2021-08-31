import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mishowtogo/src/providers/client_provider.dart';
import 'package:mishowtogo/src/providers/music_provider.dart';
import 'package:http/http.dart' as http;
import 'package:mishowtogo/src/utils/shared_pref.dart';

class PushNotificationsProvider {

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  StreamController _streamController = StreamController<
      Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get message => _streamController.stream;


  void initPushNotifications() async {

    //ONLAUNCH
    FirebaseMessaging.instance.getInitialMessage().then((
        RemoteMessage message) {
      if (message != null) {
        Map<String, dynamic> data = message.data;
        SharedPref sharedPref = new SharedPref();
        sharedPref.save('isNotification', 'true');
        _streamController.sink.add(data);
      }
    });

    // ON MESSAGE
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      Map<String, dynamic> data = message.data;

      print('Cuando estamos en primer plano');
      print('OnMessage: $data');
      _streamController.sink.add(data);
    });
    // ON RESUME
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      Map<String, dynamic> data = message.data;
      print('OnResume $data');
      _streamController.sink.add(data);
    });
  }

  void saveToken(String idUser, String typeUser) async {
    String token = await FirebaseMessaging.instance.getToken();

    Map<String, dynamic> data = {
      'token': token
    };

    if (typeUser == 'client') {
      ClientProvider clientProvider = new ClientProvider();
      clientProvider.update(data, idUser);
    }
    else {
      MusicProvider musicProvider = new MusicProvider();
      musicProvider.update(data, idUser);
    }

  }

  Future<void> sendMessage(String to, Map<String, dynamic> data, String title, String body) async {
    await http.post(
        'https://fcm.googleapis.com/fcm/send',
        headers: <String, String> {
          'Content-Type': 'application/json',
          'Authorization': 'key=AAAAFC3JJF8:APA91bHqeJj-zPj14UMFi6pH9j15xOOsgiMldSJ6OQt9Ytpw_QHOG6VaVUk-mUqd_k73JWCU7mo3Z5Yk_Uec3OV3UThnKKSyRvukMwHiPYDRA4YBZGk7CRGx7MQeiccU9_VEwwpo_Lwb'
        },
        body: jsonEncode(
            <String, dynamic> {
              'notification': <String, dynamic> {
                'body': body,
                'title': title,
              },
              'priority': 'high',
              'ttl': '4500s',
              'data': data,
              'to': to
            }
        )
    );
  }


  void dispose () {
    _streamController?.onCancel;
  }


}