import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe_game/state/board_controller.dart';
import 'package:tic_tac_toe_game/state/global_controller.dart';
import 'package:tic_tac_toe_game/state/user_controller.dart';
import 'package:tic_tac_toe_game/ui/board_view.dart';

import 'ui/login_page.dart';

void main() => runApp(MyApp());

final routes = {

  '/login': (BuildContext context) => LoginPage(),
  '/game': (BuildContext context) => BoardView(),
  '/statistics': (BuildContext context) => BoardView(),
  '/': (BuildContext context) => BoardView()
};

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => UserController()),
        ChangeNotifierProvider(builder: (_) => BoardController()),
        ChangeNotifierProvider(builder: (_) => GlobalController()),
      ],
      child: AppRouter(),
    );
  }
}

class AppRouter extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Container(
        child:  MaterialApp(
            initialRoute: "/",
            title: "Tic Tac Toe",
            routes: routes)

        );
  }
}


