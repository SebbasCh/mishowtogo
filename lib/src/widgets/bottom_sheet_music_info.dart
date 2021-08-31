import 'package:flutter/material.dart';

class BottomSheetMusicInfo extends StatefulWidget {

  String imageUrl;
  String username;
  String email;

  BottomSheetMusicInfo({
     @required this.imageUrl,
     @required this.username,
    @required this.email,
  });

  @override
  _BottomSheetMusicInfoState createState() => _BottomSheetMusicInfoState();
}

class _BottomSheetMusicInfoState extends State<BottomSheetMusicInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      margin: EdgeInsets.all(30),
      child: Column(
        children: [
          Text(
            'Tu Cliente',
            style: TextStyle(
              fontSize: 18
            ),
          ),
          SizedBox(height: 15),
          CircleAvatar(
            backgroundImage: widget.imageUrl != null
          ? NetworkImage(widget.imageUrl)
            : AssetImage('assets/img/profile.jpg'),
            radius: 50,
          ),
          ListTile(
            title: Text(
              'Nombre',
              style: TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              widget.username ?? '',
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(Icons.person),
          ),
          ListTile(
            title: Text(
              'Correo',
              style: TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              widget.email ?? '',
              style: TextStyle(fontSize: 15),
            ),
            leading: Icon(Icons.email),
          ),
        ],
      ),
    );
  }
}
