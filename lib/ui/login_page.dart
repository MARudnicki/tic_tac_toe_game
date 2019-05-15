import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _colorTween;
  bool _clicked;

  @override
  void initState() {
    _controller = AnimationController(
        lowerBound: 0,
        upperBound: 1,
        value: 0,
        duration: Duration(seconds: 3),
        vsync: this)
      ..addListener((){
        setState(() {
        });

    });
    _clicked = false;

    _colorTween = ColorTween(begin: Colors.blue, end:  Colors.green)
        .animate(_controller);

    _controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final int value = (_controller.value * 500).round();

    return Container(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Top Bar"),
              leading: Icon(Icons.arrow_right),
            ),
            body: InkWell(
              customBorder: Border.all(
                color: Colors.black,
                style: BorderStyle.solid,
                  width: 2
              ),
              onTap: (){
                _clicked ? _controller.reverse() : _controller.forward();
                _clicked = !_clicked;
              },
              child: Column(children: <Widget>[
                  Text("Login page $value",
                      style: TextStyle(
                          fontSize: 50,
                          color: _colorTween.value)
                  ),
              ]
              )
        )
      )
    );

  }
}

