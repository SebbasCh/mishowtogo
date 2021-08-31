import 'package:flutter/material.dart';
import 'package:mishowtogo/src/models/client.dart';
import 'package:mishowtogo/src/models/music.dart';
import 'package:mishowtogo/src/providers/auth_provider.dart';
import 'package:mishowtogo/src/providers/client_provider.dart';
import 'package:mishowtogo/src/providers/music_provider.dart';
import 'package:mishowtogo/src/utils/my_progress_dialog.dart';
import 'package:mishowtogo/src/utils/snackbar.dart' as utils;
import 'package:progress_dialog/progress_dialog.dart';


class MusicRegisterCotroller {

  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TextEditingController usernameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmpasswordController = new TextEditingController();


  TextEditingController pin1Controller = new TextEditingController();
  TextEditingController pin2Controller = new TextEditingController();
  TextEditingController pin3Controller = new TextEditingController();
  TextEditingController pin4Controller = new TextEditingController();
  TextEditingController pin5Controller = new TextEditingController();
  TextEditingController pin6Controller = new TextEditingController();


  AuthProvider _authProvider;
  MusicProvider _musicProvider;
  ProgressDialog _progressDialog;

  Future init (BuildContext context) {
    this.context = context;
    _authProvider  = new  AuthProvider();
    _musicProvider =  new MusicProvider();
    _progressDialog  = MyProgressDialog.createProgressDialog(context, 'Espere un momento...');

  }

  void register() async {
    String username = usernameController.text;
    String email = emailController.text.trim();
    String confirmpassword = confirmpasswordController.text.trim();
    String password = passwordController.text.trim();

    String pin1 = pin1Controller.text.trim();
    String pin2 = pin2Controller.text.trim();
    String pin3 = pin3Controller.text.trim();
    String pin4 = pin4Controller.text.trim();
    String pin5 = pin5Controller.text.trim();
    String pin6 = pin6Controller.text.trim();

    String plate = '$pin1$pin2$pin3-$pin4$pin5$pin6';

    print('Email: $email');
    print('Password: $password');

    if (username.isEmpty && email.isEmpty && password.isEmpty && confirmpassword.isEmpty) {
      print('debes ingresar todos los campos');
      utils.Snackbar.showSnackbar(context, key, 'Debes ingresar todos los campos');
      return;
    }

    if (confirmpassword != password) {
      print('Las contraseñas no coinciden');
      utils.Snackbar.showSnackbar(context, key, 'Las contraseñas no coinciden');
      return;
    }

    if (password.length <6) {
      print('La contraseña debe tener al menos 6 caracteres');
      utils.Snackbar.showSnackbar(context, key, 'La contraseña debe tener al menos 6 caracteres');
      return;
    }

    _progressDialog.show();

    try {

      bool isRegister = await _authProvider.register(email, password);

      if (isRegister) {

        Music music = new Music(
          id: _authProvider.getUser().uid,
          email: _authProvider.getUser().email,
          username: username,
          password: password,
          plate: plate
        );

        await _musicProvider.create(music);

        _progressDialog.hide();
        Navigator.pushNamedAndRemoveUntil(context,'music/map', (route) => false);

        utils.Snackbar.showSnackbar(context, key, 'El usuario se registro correctamente');
        print('El usuario se registro correctamente');
      }

      else {
        _progressDialog.hide();
        print('El usuario no se pudo registrar');
      }

    } catch(error) {
      _progressDialog.hide();
      utils.Snackbar.showSnackbar(context, key, 'Error: $error');
      print('Error: $error');
    }

  }


}