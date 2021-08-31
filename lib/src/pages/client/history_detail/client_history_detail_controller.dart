import 'package:flutter/material.dart';
import 'package:mishowtogo/src/models/music.dart';
import 'package:mishowtogo/src/models/travel_history.dart';
import 'package:mishowtogo/src/providers/auth_provider.dart';
import 'package:mishowtogo/src/providers/music_provider.dart';
import 'package:mishowtogo/src/providers/travel_history_provider.dart';


class ClientHistoryDetailController {
  Function refresh;
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TravelHistoryProvider _travelHistoryProvider;
  AuthProvider _authProvider;
  MusicProvider _musicProvider;

  TravelHistory travelHistory;
  Music music;

  String idTravelHistory;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    _travelHistoryProvider = new TravelHistoryProvider();
    _authProvider = new AuthProvider();
    _musicProvider = new MusicProvider();

    idTravelHistory = ModalRoute.of(context).settings.arguments as String;

    getTravelHistoryInfo();
  }

  void getTravelHistoryInfo() async {
    travelHistory = await  _travelHistoryProvider.getById(idTravelHistory);
    getMusicInfo(travelHistory.idMusic);
  }

  void getMusicInfo(String idMusic) async {
    music = await _musicProvider.getById(idMusic);
    refresh();
  }

}

