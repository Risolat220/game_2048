import 'package:flutter/material.dart';
import '../service/game.dart';
import '../service/board.dart';
import '../service/score.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late Game game;

  @override
  void initState() {
    super.initState();
    game = Game();
  }

  void _handleMove(DragEndDetails details) {
    if (game.gameOver || game.gameWon) return;

    bool moved = false;
    final velocity = details.velocity.pixelsPerSecond;

    if (velocity.dx.abs() > velocity.dy.abs()) {
      if (velocity.dx < -500) {
        game.moveLeft();
        moved = true;
      } else if (velocity.dx > 500) {
        game.moveRight();
        moved = true;
      }
    } else {
      if (velocity.dy < -500) {
        game.moveUp();
        moved = true;
      } else if (velocity.dy > 500) {
        game.moveDown();
        moved = true;
      }
    }

    if (moved) {
      setState(() {
        game.checkGameOver();
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
    double availableHeight = screenHeight - appBarHeight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('2048 Game'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                game = Game();
              });
            },
          ),
        ],
      ),
      body: GestureDetector(
        onVerticalDragEnd: _handleMove,
        onHorizontalDragEnd: _handleMove,
        child: Container(
          color: Colors.grey[300],
          width: screenWidth,
          height: availableHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ScoreDisplay(score: game.score),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: GameBoard(game: game),
                ),
              ),
              if (game.gameWon || game.gameOver)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    game.gameWon ? 'You win' : 'Game Over!',
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}