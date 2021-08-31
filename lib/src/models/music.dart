import 'dart:convert';

Music clientFromJson(String str) => Music.fromJson(json.decode(str));

String clientToJson(Music data) => json.encode(data.toJson());

class Music {
  Music({
    this.id,
    this.username,
    this.email,
    this.password,
    this.plate,
    this.token,
    this.image,

  });

  String id;
  String username;
  String email;
  String password;
  String plate;
  String token;
  String image;



  factory Music.fromJson(Map<String, dynamic> json) => Music(
      id: json["id"],
      username: json["username"],
      email: json["email"],
      password: json["password"],
      plate: json["plate"],
      token: json["token"],
      image: json["image"],


  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "email": email,
    "plate": plate,
    "token": token,
    "image": image,
  };
}