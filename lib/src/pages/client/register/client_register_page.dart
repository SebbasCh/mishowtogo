import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:mishowtogo/src/pages/Login/login_controller.dart';
import 'package:mishowtogo/src/pages/client/register/client_register_controller.dart';
import 'package:mishowtogo/src/utils/colors.dart' as utils;
import 'package:mishowtogo/src/widgets/button_app.dart';

class ClientRegisterPage extends StatefulWidget {

  @override
  _ClientRegisterPageState createState() => _ClientRegisterPageState();
}

class _ClientRegisterPageState extends State<ClientRegisterPage> {

  ClientRegisterCotroller _con  =  new ClientRegisterCotroller();

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

    print ('METODO  BUILD');

    return Scaffold(
      key: _con.key,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _bannerApp(),
            _textLogin(),
            _textFieldUsername(),
            _textFieldEmail(),
            _textFieldPassword(),
            _textFieldConfirmPassword(),
            _buttonRegister(),
          ],
        ),
      )
    );
  }


  Widget _buttonRegister() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: ButtonApp(
        onPressed: _con.register,
        text: 'Registrar Ahora',
        color: utils.Colors.MiShowToGoColor,
        textColor: Colors.white,
      ),
    );
  }

  Widget _textFieldEmail()  {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        controller: _con.emailController,
        decoration: InputDecoration(
          hintText: 'correo@gmail.com',
          labelText: 'Correo electronico',
          suffixIcon: Icon(
            Icons.email_outlined,
            color: utils.Colors.MiShowToGoColor,
          )
        ),
      ),
    );
  }

  Widget _textFieldUsername()  {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: _con.usernameController,
        decoration: InputDecoration(
            hintText: 'pepito perez',
            labelText: 'Nombre De Usuario',
            suffixIcon: Icon(
              Icons.person_outline,
              color: utils.Colors.MiShowToGoColor,
            )
        ),
      ),
    );
  }

  Widget _textFieldPassword()  {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: TextField(
        obscureText: true,
        controller: _con.passwordController,
        decoration: InputDecoration(
          labelText: 'Contraseña',
          suffixIcon: Icon(
            Icons.lock_clock_outlined,
            color: utils.Colors.MiShowToGoColor,
          )
        ),
      ),
    );
  }

  Widget _textFieldConfirmPassword()  {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: TextField(
        obscureText: true,
        controller: _con.confirmpasswordController,
        decoration: InputDecoration(
            labelText: 'Confirmar Contraseña',
            suffixIcon: Icon(
              Icons.lock_clock_outlined,
              color: utils.Colors.MiShowToGoColor,
            )
        ),
      ),
    );
  }


  Widget _textLogin() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Text(
        'REGISTRO',
        style: TextStyle(
          color: Colors.black,
          fontSize: 25,
          fontFamily: 'NimbusSans',
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _bannerApp() {
    return ClipPath(
      clipper: WaveClipperOne(),
      child: Container(
        color: utils.Colors.MiShowToGoColor,
        height: MediaQuery.of(context).size.height * 0.22,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  color: Colors.white,
                  fontFamily: 'Pacifico',
                  fontSize: 22,
              ),
            )
          ],
        ),
      ),
    );
  }
}
