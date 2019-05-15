import 'package:flutter/material.dart';

class GlobalController with ChangeNotifier{

  GlobalKey<ScaffoldState> _scaffoldKey= new GlobalKey<ScaffoldState>();

  get scaffoldKey => _scaffoldKey;

  notifySnackBar(String text){
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
            duration: Duration(seconds: 2),
            content: Text(text, style: TextStyle(
              color: Colors.cyanAccent,
              fontSize: 20
            )),
        )
    );
  }

}

