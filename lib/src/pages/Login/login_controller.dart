import 'package:flutter/material.dart';
import 'package:mishowtogo/src/models/client.dart';
import 'package:mishowtogo/src/models/music.dart';
import 'package:mishowtogo/src/providers/auth_provider.dart';
import 'package:mishowtogo/src/providers/client_provider.dart';
import 'package:mishowtogo/src/providers/music_provider.dart';
import 'package:mishowtogo/src/utils/my_progress_dialog.dart';
import 'package:mishowtogo/src/utils/shared_pref.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:mishowtogo/src/utils/snackbar.dart' as utils;



class LoginCotroller {

  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  AuthProvider _authProvider;
  ProgressDialog _progressDialog;
  MusicProvider _musicProvider;
  ClientProvider _clientProvider;

  SharedPref _sharedPref;
  String _typeUser;

  Future init (BuildContext context) async {
    this.context = context;
    _authProvider  = new  AuthProvider();
    _musicProvider = new MusicProvider();
    _clientProvider = new ClientProvider();
    _progressDialog  = MyProgressDialog.createProgressDialog(context, 'Espere un momento...');
    _sharedPref = new SharedPref();
    _typeUser = await _sharedPref.read('typeUser');

    print('=========== TIPO DE USUARIO===========');
    print(_typeUser);

  }

  void goToRegisterPage() {
    if (_typeUser == 'client') {
      Navigator.pushNamed(context, 'client/register');
    }
    else {
      Navigator.pushNamed(context, 'music/register');
    }
  }


  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    print('Email: $email');
    print('Password: $password');

    _progressDialog.show();

    try {

      bool isLogin = await _authProvider.login(email, password);
      _progressDialog.hide();

      if (isLogin) {
        print('El usuario esta logeado');

        if  (_typeUser == 'client') {
          Client client = await _clientProvider.getById(_authProvider.getUser().uid);
          print ('Client: $client');

          if(client != null) {
            print('El cliente no es nullo');
            Navigator.pushNamedAndRemoveUntil(context,'client/map', (route) => false);
          }
          else {
            print('El cliente si es nullo');
            utils.Snackbar.showSnackbar(context, key,'El usuario no es  valido');
            await _authProvider.signOut();

          }
        }

        else if  (_typeUser == 'music') {
          Music music = await _musicProvider.getById(_authProvider.getUser().uid);
          print ('Music: $music');
          if(music != null) {
            Navigator.pushNamedAndRemoveUntil(context,'music/map', (route) => false);
          }
          else {
            utils.Snackbar.showSnackbar(context, key,'El usuario no es  valido');
            await _authProvider.signOut();

          }
        }
      }
      else {
        utils.Snackbar.showSnackbar(context, key,'El usuario no se pudo autenticar');
        print('El usuario no se pudo autenticar');
      }

    } catch(error) {
      utils.Snackbar.showSnackbar(context, key,'Error: $error');
      _progressDialog.hide();
      print('Error: $error');
    }

  }


}