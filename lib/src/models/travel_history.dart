import 'dart:convert';

TravelHistory travelHistoryFromJson(String str) => TravelHistory.fromJson(json.decode(str));

String travelHistoryToJson(TravelHistory data) => json.encode(data.toJson());

class TravelHistory {
  TravelHistory({
    this.id,
    this.idClient,
    this.idMusic,
    this.from,
    this.to,
    this.timestamp,
    this.price,
    this.calificationClient,
    this.calificationMusic,
    this.nameMusic,
  });

  String id;
  String idClient;
  String idMusic;
  String from;
  String to;
  String nameMusic;
  int timestamp;
  double price;
  double calificationClient;
  double calificationMusic;

  factory TravelHistory.fromJson(Map<String, dynamic> json) => TravelHistory(
    id: json["id"],
    idClient: json["idClient"],
    idMusic: json["idMusic"],
    from: json["from"],
    to: json["to"],
    nameMusic: json["nameMusic"],
    timestamp: json["timestamp"],
    price: json["price"]?.toDouble() ?? 0,
    calificationClient: json["calificationClient"]?.toDouble() ?? 0,
    calificationMusic: json["calificationMusic"]?.toDouble() ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "idClient": idClient,
    "idMusic": idMusic,
    "from": from,
    "to": to,
    "nameDriver": nameMusic,
    "timestamp": timestamp,
    "price": price,
    "calificationClient": calificationClient,
    "calificationDriver": calificationMusic,
  };
}
