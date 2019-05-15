import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tic_tac_toe_game/state/board_controller.dart';
import 'package:tic_tac_toe_game/state/global_controller.dart';

class BoardView extends StatefulWidget {
  @override
  _BoardViewState createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {

  @override
  Widget build(BuildContext context) {

    GlobalController globalController = Provider.of<GlobalController>(context);

    return Scaffold(
        key: globalController.scaffoldKey,
        appBar: AppBar(
          title: Text("Top Bar"),
          leading: Icon(Icons.arrow_right),
        ),
        body: Column(children: <Widget>[
          Board(),
          Buttons()
          ]
        )
    );
  }
}



class Board extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Stack(
        children: <Widget>[
          GridView.count(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            crossAxisCount: 3,
            children: <Widget>[
              Field(0, 0),
              Field(1, 0),
              Field(2, 0),

              Field(0, 1),
              Field(1, 1),
              Field(2, 1),

              Field(0, 2),
              Field(1, 2),
              Field(2, 2),
            ],
          ),
          BoardOverlay()
        ],

      ),
    );
  }
}


class Field extends StatefulWidget {

  static final IconData EMPTY = Icons.check_circle;
  static final IconData CIRCLE = Icons.block;
  static final IconData CROSS = Icons.clear;

  final int x, y;

  Field(this.x, this.y);

  @override
  _FieldState createState() => _FieldState(x, y);

}

class _FieldState extends State<Field> {

  final int x, y;
  IconData iconData;

  _FieldState(this.x, this.y);

  @override
  Widget build(BuildContext context) {
    BoardController boardController = Provider.of<BoardController>(context);

    return InkWell(
        onTap: () => clickField(context),
        child: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.black,
                    style: BorderStyle.solid
                )
            ),
            child: Card(
                color: Colors.blue.shade200,
                child: LayoutBuilder(builder: (context, constraint) {
                  return Icon(boardController.getIcon(x, y), size: constraint.biggest.height);
                  }
                )
            )
        )
    );
  }

  clickField(BuildContext context) async {
    BoardController boardController = Provider.of<BoardController>(context);
    await boardController.click(context);
  }
}


class BoardOverlay extends StatefulWidget {
  @override
  _BoardOverlayState createState() => _BoardOverlayState();
}

class _BoardOverlayState extends State<BoardOverlay> with SingleTickerProviderStateMixin {

  AnimationController _controller;
  Animation _colorTween;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: Duration(seconds: 2),
        vsync: this,
        lowerBound: 0,
        upperBound: 1,
        value: 0)
      ..addListener(() => this.setState(() => {}));

    _colorTween = ColorTween(begin: Colors.transparent, end: Colors.black54).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    BoardController boardController = Provider.of(context);

    if (boardController.isOverlayActive()) {
      _controller.forward();

      return Container(
        height: MediaQuery
            .of(context)
            .size
            .width,
        width: double.infinity,
        child: Material(
            color: _colorTween.value,
            child: InkWell(
              onTap: () => handleOverlayClicked(boardController),
            )
        ),
      );
    } else {
      return Container();
    }
  }

  void handleOverlayClicked(BoardController boardController) {
    _controller.reverse();
    boardController.restartGame();
  }
}

class Buttons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(border: Border.all(style: BorderStyle.solid)),
            child: RaisedButton(
              padding: EdgeInsets.all(20),
              child: Text("Restart"),
              onPressed: () => handleRestartGame(context),
            ),
          )
        ],
      ),
    );
  }

  handleRestartGame(context) {
    BoardController boardController = Provider.of<BoardController>(context);

    boardController.restartGame();
  }
}
