import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mishowtogo/src/pages/music/travel_map/music_travel_map_controller.dart';
import 'package:flutter/scheduler.dart';
import 'package:mishowtogo/src/widgets/button_app.dart';


class MusicTravelMapPage extends StatefulWidget {
  @override
  _MusicTravelMapPageState createState() => _MusicTravelMapPageState();
}

class _MusicTravelMapPageState extends State<MusicTravelMapPage> {

  MusicTravelMapController _con = new MusicTravelMapController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _con.key,
      body: Stack(
        children: [
          _googleMapsWidget(),
          SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buttonUserInfo(),
                    Column(
                      children: [
                        _cardKmInfo(_con.km?.toStringAsFixed(1)),
                        _cardMinInfo(_con.seconds?.toString())
                      ],
                    ),

                    _buttonCenterPosition(),
                  ],
                ),
                Expanded(child: Container()),
                _buttonStatus()
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _cardKmInfo(String km) {
    return SafeArea(
        child: Container(
          width: 110,
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Text(
            '${km ?? ''} km',
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        )
    );
  }


  Widget _cardMinInfo(String min) {
    return SafeArea(
        child: Container(
          width: 110,
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Text(
            '${min ?? ''} seg',
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        )
    );
  }

  Widget _buttonUserInfo() {
    return GestureDetector(
      onTap: _con.openBottomSheet,
      child: Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Card(
          shape: CircleBorder(),
          color: Colors.white,
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.person,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonCenterPosition() {
    return GestureDetector(
      onTap: _con.centerPosition,
      child: Container(
        alignment: Alignment.centerRight,
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: Card(
          shape: CircleBorder(),
          color: Colors.white,
          elevation: 4.0,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Icon(
              Icons.location_searching,
              color: Colors.grey[600],
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonStatus() {
    return Container(
      height: 50,
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.symmetric(horizontal: 60, vertical: 30),
      child: ButtonApp(
        onPressed: _con.updateStatus,
        text: _con.currentStatus,
        color: _con.colorStatus,
        textColor: Colors.black,
      ),
    );
  }

  Widget _googleMapsWidget() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      markers: Set<Marker>.of(_con.markers.values),
      polylines: _con.polylines,
    );
  }

  void refresh() {
    setState(() {});
  }
}
