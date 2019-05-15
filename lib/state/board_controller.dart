import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe_game/utils/board_utils.dart';

import 'package:synchronized/synchronized.dart';
import 'field_state.dart';
import 'global_controller.dart';

class BoardController with ChangeNotifier {

  var lock = new Lock();

  Map<String, IconData> fields = {
    "00": FieldState.EMPTY,
    "01": FieldState.EMPTY,
    "02": FieldState.EMPTY,
    "10": FieldState.EMPTY,
    "11": FieldState.EMPTY,
    "12": FieldState.EMPTY,
    "20": FieldState.EMPTY,
    "21": FieldState.EMPTY,
    "22": FieldState.EMPTY,
  };

  bool hasGameFinished = false;
  IconData iconData = Icons.clear;
  bool lockButtons = false;

  void click(context) async{

//    if(lockButtons || hasGameFinished){
//      print('Click on field not available yet. Wait a moment !');
//      return;
//    }
//    lockButtons = true;
    await lock.synchronized(() async{
      final x = context.widget.x;
      final y = context.widget.y;
      final GlobalController globalController = Provider.of<GlobalController>(context);

      handleUserClick(x, y, globalController);
      await Future.delayed(Duration(milliseconds: 500),
              ()=> handleComputerClick(globalController));

    });
//    lockButtons = false;
  }

  void handleComputerClick(GlobalController globalController) async {
    print("Computer click");

    String computerFieldsKey = BoardUtils.drawField(fields);
    this.fields[computerFieldsKey] = FieldState.CIRCLE;
    //check if computer won
    if(checkIfWinner(FieldState.CIRCLE)){
      globalController.notifySnackBar("COMPUTER WON");
      this.hasGameFinished = true;
    }
    notifyListeners();
  }

  void handleUserClick(int x, int y, GlobalController globalController) {
    print("click $x, $y");

    String fieldKey = "$x$y";
    IconData fieldState = fields[fieldKey];

    if (fieldState == FieldState.CROSS) {
      globalController.notifySnackBar("Already taken by the enemy !");
      return;
    }

    if (fieldState == FieldState.CIRCLE) {
      globalController.notifySnackBar("You already took this field !");
      return;
    }

    //take a field
    this.fields[fieldKey] = FieldState.CROSS;

    //check if user won
    if(checkIfWinner(FieldState.CROSS)){
      globalController.notifySnackBar("YOU WON");
      this.hasGameFinished = true;
    }

    //check if DRAW
    else if(BoardUtils.checkIfDraw(fields)){
      globalController.notifySnackBar("DRAW");
      this.hasGameFinished = true;
    }

    notifyListeners();
  }

  IconData getIcon(int x, int y) {

    print('Get icon');
    return fields["$x$y"];
  }

  bool checkIfWinner(IconData iconData) {
    return checkIfLineContainsOnly("00", "01", "02", iconData) ||
          checkIfLineContainsOnly("10", "11", "12", iconData) ||
          checkIfLineContainsOnly("20", "21", "22", iconData) ||
          checkIfLineContainsOnly("00", "10", "20", iconData) ||
          checkIfLineContainsOnly("01", "11", "21", iconData) ||
          checkIfLineContainsOnly("02", "12", "22", iconData) ||
          checkIfLineContainsOnly("00", "11", "22", iconData) ||
          checkIfLineContainsOnly("02", "11", "20", iconData);
  }

  bool checkIfLineContainsOnly(String first, String second, String third, IconData iconData) {
    return fields[first] == iconData && fields[second] == iconData && fields[third] == iconData;
  }

  void restartGame() {
    print('Restart game');

    fields.forEach((k, v) => fields[k] = FieldState.EMPTY);
    this.hasGameFinished = false;

    notifyListeners();
  }

  bool isOverlayActive() {

    return this.hasGameFinished;
  }
}
