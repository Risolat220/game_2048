import 'package:flutter/material.dart';
import 'game.dart';
import '../core/theme/colors.dart';

class GameBoard extends StatelessWidget {
  final Game game;

  const GameBoard({super.key, required this.game});

  Color _getTileColor(int value) {
    switch (value) {
      case 2:
        return AppColors.tile2;
      case 4:
        return AppColors.tile4;
      case 8:
        return AppColors.tile8;
      case 16:
        return AppColors.tile16;
      case 32:
        return AppColors.tile32;
      case 64:
        return AppColors.tile64;
      case 128:
        return AppColors.tile128;
      case 256:
        return AppColors.tile256;
      case 512:
        return AppColors.tile512;
      case 1024:
        return AppColors.tile1024;
      case 2048:
        return AppColors.tile2048;
      default:
        return AppColors.emptyTile;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Ekran o‘lchamlari
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
    double availableHeight = screenHeight - appBarHeight;


    double maxBoardWidth = screenWidth > 600 ? 500 : screenWidth - 32;
    double maxBoardHeight = availableHeight * 0.7;
    double boardSize = maxBoardWidth < maxBoardHeight ? maxBoardWidth : maxBoardHeight;
    double tileSize = (boardSize - 24) / 4;

    return Container(
      width: boardSize,
      height: boardSize,
      decoration: BoxDecoration(
        color: const Color(0xFFbbada0),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8),
      child: GridView.count(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(16, (index) {
          int i = index ~/ 4;
          int j = index % 4;
          int value = game.board[i][j];
          return Container(
            decoration: BoxDecoration(
              color: _getTileColor(value),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                value == 0 ? '' : '$value',
                style: TextStyle(
                  fontSize: tileSize * 0.4,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}