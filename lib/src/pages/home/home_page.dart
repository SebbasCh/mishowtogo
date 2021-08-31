import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:mishowtogo/src/pages/home/home_controller.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeController _con =  new HomeController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('INIT STATE');

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.black, Colors.black87, Colors.black, Colors.black87]
              )
            ),
            child: Column(
              children: [

            _bannerApp(context),

                SizedBox(height: 50),
                _textSelectYourRol(),
                SizedBox(height: 30),
                _imageTypeUser(context, 'assets/img/cliente.png', 'client'),
                SizedBox(height: 10),
                _texTypeUser('Cliente'),
                SizedBox(height: 30),
                _imageTypeUser(context, 'assets/img/Musico1.png', 'music'),
                SizedBox(height: 10),
                _texTypeUser('Musico')

              ],
            ),
          ),
        )
    );
  }

  Widget _bannerApp(BuildContext context) {
    return ClipPath(
      clipper: WaveClipperOne(),
      child: Container(
        color: Colors.white,
        height: MediaQuery.of(context).size.height * 0.25,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/img/Logo-La-Compania-1024x814.png',
              width: 150,
              height: 150,
            ),
            Text(
              'Celebremos En Grande',
              style: TextStyle(
                  color: Colors.black87,
                  fontFamily: 'Pacifico',
                  fontSize: 22,
                  fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _textSelectYourRol () {
    return Text(
      'Selecciona Tu Rol',
      style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'OneDay'
      ),
    );
  }

  Widget _imageTypeUser(BuildContext context, String image, String typeUser) {
    return GestureDetector(
      onTap: () => _con.goToLoginPage(typeUser),
      child: CircleAvatar(
        backgroundImage: AssetImage(image),
        radius: 75,
        backgroundColor: Colors.deepOrangeAccent,
      ),
    );
  }

  Widget  _texTypeUser(String typeUser) {
    return Text(
      typeUser,
      style: TextStyle(
          color: Colors.white,
          fontSize: 16
      ),
    );
  }
}
