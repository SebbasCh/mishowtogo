import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:mishowtogo/src/api/environment.dart';
import 'package:mishowtogo/src/models/directions.dart';
import 'package:mishowtogo/src/models/prices.dart';
import 'package:mishowtogo/src/providers/google_provider.dart';
import 'package:mishowtogo/src/providers/prices_provider.dart';
import 'package:mishowtogo/src/utils/colors.dart' as utils;

class ClientTravelInfoController {

  BuildContext context;

  GoogleProvider _googleProvider;
  PricesProvider _pricesProvider;

  Function refresh;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _mapCotroller = Completer();

  CameraPosition initialPosition = CameraPosition(
      target: LatLng(4.755786, -74.0417624),
      zoom: 14.0
  );


  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  String from;
  String to;
  LatLng fromLatLng;
  LatLng toLatLng;

  Set<Polyline> polylines = {};
  List<LatLng> points = new List();

  BitmapDescriptor fromMarker;
  BitmapDescriptor toMarker;

  Direction _directions;
  String min;
  String km;

  double minTotal;
  double maxTotal;

  Future init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh =refresh;

    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    from = arguments['from'];
    to = arguments['to'];
    fromLatLng = arguments['fromLatLng'];
    toLatLng = arguments['toLatLng'];

    _googleProvider = new GoogleProvider();
    _pricesProvider = new  PricesProvider();

    fromMarker = await createMarkerImageFromAsset('assets/img/map_pin1.png',);
    toMarker = await createMarkerImageFromAsset('assets/img/map_pin2.png');

    animateCameraToPosition(fromLatLng.latitude, fromLatLng.longitude);
    
    getGoogleMapsDirections(fromLatLng, toLatLng);
  }

  void getGoogleMapsDirections(LatLng from, LatLng to) async {
    _directions = await _googleProvider.getGoogleMapsDirections(
        from.latitude,
        from.longitude,
        to.latitude,
        to.longitude
    );
    min = _directions.duration.text;
    km = _directions.distance.text;

    calculatePrice();
    
    refresh();
  }

  void  goToRequest() {
    Navigator.pushNamed(context, 'client/travel/request', arguments: {
      'from': from,
      'to':to,
      'fromLatLng': fromLatLng,
      'toLatLng': toLatLng,
    });
  }

  void calculatePrice() async {
    Prices prices = await _pricesProvider.getAll();
    double kmValue = double.parse(km.split(" ")[0]) * prices.km;
    double minValue = double.parse(min.split(" ")[0]) * prices.min;
    double total = kmValue = minValue;

    minTotal = total - 400;
    maxTotal = total + 400;

    refresh();
  }

  Future<void> setPolyLines() async {
    PointLatLng pointFromLatLng = PointLatLng(fromLatLng.latitude, fromLatLng.longitude);
    PointLatLng pointToLatLng = PointLatLng(toLatLng.latitude, toLatLng.longitude);

    PolylineResult result = await PolylinePoints().getRouteBetweenCoordinates(
        Environment.API_KEY_MAPS,
        pointFromLatLng,
        pointToLatLng
    );

    for (PointLatLng point in result.points) {
      points.add(LatLng(point.latitude, point.longitude));
    }

    Polyline polyline = Polyline(
        polylineId: PolylineId('poly'),
      color: utils.Colors.MiShowToGoColor,
      points: points,
      width: 6
    );

    polylines.add(polyline);

    addMarker('from', fromLatLng.latitude, fromLatLng.longitude,'Recoger Aqui', '', fromMarker);
    addMarker('to', toLatLng.latitude, toLatLng.longitude,'Destino', '', toMarker);

    refresh();
  }

  Future animateCameraToPosition(double latitude, double longitude) async {
    GoogleMapController controller = await _mapCotroller.future;
    if (controller != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              bearing: 0,
              target: LatLng(latitude, longitude),
              zoom: 15
          )
      ));
    }
  }

  void onMapCreated(GoogleMapController controller) async {
    controller.setMapStyle('[{"elementType":"geometry","stylers":[{"color":"#ebe3cd"}]},{"elementType":"labels.text.fill","stylers":[{"color": "#523735"}]},{"elementType":"labels.text.stroke","stylers":[{"color":"#f5f1e6"}]},{"featureType":"administrative","elementType":"geometry.stroke","stylers":[{"color":"#c9b2a6"}]},{"featureType":"administrative.land_parcel","elementType":"geometry.stroke","stylers":[{"color":"#dcd2be"}]},{"featureType": "administrative.land_parcel","elementType":"labels.text.fill","stylers":[{"color":"#ae9e90"}]},{"featureType":"landscape.natural","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"poi","elementType":"labels.text.fill","stylers": [{"color":"#93817c"}]},{"featureType":"poi.park","elementType":"geometry.fill","stylers":[{"color":"#a5b076"}]},{"featureType":"poi.park","elementType":"labels.text.fill","stylers":[{"color":"#447530"}]},{"featureType":"road","elementType":"geometry","stylers":[{"color":"#f5f1e6"}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#fdfcf8"}]},{"featureType":"road.highway","elementType":"geometry","stylers":[{"color":"#f8c967"}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color": "#e9bc62"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry","stylers":[{"color": "#e98d58"}]},{"featureType":"road.highway.controlled_access","elementType":"geometry.stroke","stylers":[{"color":"#db8555"}]},{"featureType": "road.local","elementType":"labels.text.fill","stylers":[{"color":"#806b63"}]},{"featureType":"transit.line","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"transit.line","elementType":"labels.text.fill","stylers":[{"color":"#8f7d77"}]},{"featureType":"transit.line","elementType":"labels.text.stroke","stylers":[{"color":"#ebe3cd"}]},{"featureType":"transit.station","elementType":"geometry","stylers":[{"color":"#dfd2ae"}]},{"featureType":"water","elementType":"geometry.fill","stylers":[{"color":"#b9d3c2"}]},{"featureType":"water","elementType":"labels.text.fill","stylers":[{"color":"#92998d"}]}]');
    _mapCotroller.complete(controller);
    await setPolyLines();

  }

  Future<BitmapDescriptor> createMarkerImageFromAsset(String path) async {
    ImageConfiguration configuration = ImageConfiguration();
    BitmapDescriptor bitmapDescriptor = await BitmapDescriptor.fromAssetImage(configuration, path);
    return bitmapDescriptor;
  }

  void addMarker(
      String markerId,
      double lat,
      double lng,
      String title,
      String content,
      BitmapDescriptor iconMarker
      ) {

    MarkerId id = MarkerId(markerId);
    Marker marker = Marker(
        markerId: id,
        icon: iconMarker,
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(title: title, snippet: content),

    );

    markers[id] = marker;

  }
}