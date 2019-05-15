import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tic_tac_toe_game/state/field_state.dart';


class BoardUtils {

  static var random = Random();

  static bool checkIfDraw(Map<String, IconData> fields){
    
    return !fields.values.any((element) => element == FieldState.EMPTY);
    
  }

  static String drawField(Map<String, IconData> fields){

    Map<String, IconData> freeFields = Map.from(fields)
      ..removeWhere((k, v) => v != FieldState.EMPTY);

    var computerChoice = random.nextInt(freeFields.length);

    String result = List.of(freeFields.keys)[computerChoice];

    print('Computer choose $result');
    return result;
  }

}

