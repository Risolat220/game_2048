import 'dart:math';
import 'package:audioplayers/audioplayers.dart';

class Game {
  List<List<int>> board;
  int score;
  late AudioPlayer _audioPlayer;
  bool gameOver = false;
  bool gameWon = false;

  Game()
      : score = 0,
        board = List.generate(4, (_) => List.filled(4, 0)) {
    _audioPlayer = AudioPlayer();
    _addNewTile();
    _addNewTile();
  }

  void _addNewTile() {
    if (gameOver || gameWon) return;

    List<List<int>> emptyTiles = [];
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (board[i][j] == 0) emptyTiles.add([i, j]);
      }
    }

    if (emptyTiles.isNotEmpty) {
      var rand = Random();
      var index = rand.nextInt(emptyTiles.length);
      var position = emptyTiles[index];
      var value = rand.nextDouble() < 0.9 ? 2 : 4;
      board[position[0]][position[1]] = value;
    }
  }

  List<int> _compress(List<int> row) {
    List<int> newRow = row.where((val) => val != 0).toList();
    List<int> result = List.filled(4, 0);
    int pos = 0;

    for (int i = 0; i < newRow.length; i++) {
      if (i + 1 < newRow.length && newRow[i] == newRow[i + 1]) {
        result[pos] = newRow[i] * 2;
        addScore(result[pos]);
        i++; // Birlashgan juftni o'tkazib yuboramiz
        pos++;
      } else {
        result[pos] = newRow[i];
        pos++;
      }
    }

    return result;
  }

  void addScore(int value) {
    score += value;
  }

  void moveLeft() {
    bool moved = false;
    for (int i = 0; i < 4; i++) {
      List<int> oldRow = List.from(board[i]);
      board[i] = _compress(board[i]);
      if (board[i].toString() != oldRow.toString()) moved = true;
    }
    if (moved) _addNewTile();
  }

  void moveRight() {
    bool moved = false;
    for (int i = 0; i < 4; i++) {
      board[i] = board[i].reversed.toList();
      List<int> oldRow = List.from(board[i]);
      board[i] = _compress(board[i]);
      board[i] = board[i].reversed.toList();
      if (board[i].toString() != oldRow.reversed.toString()) moved = true;
    }
    if (moved) _addNewTile();
  }

  void moveUp() {
    bool moved = false;
    List<List<int>> transposed = _transposeBoard(board);
    for (int i = 0; i < 4; i++) {
      List<int> oldRow = List.from(transposed[i]);
      transposed[i] = _compress(transposed[i]);
      if (transposed[i].toString() != oldRow.toString()) moved = true;
    }
    board = _transposeBoard(transposed);
    if (moved) _addNewTile();
  }

  void moveDown() {
    bool moved = false;
    List<List<int>> transposed = _transposeBoard(board);
    for (int i = 0; i < 4; i++) {
      transposed[i] = transposed[i].reversed.toList();
      List<int> oldRow = List.from(transposed[i]);
      transposed[i] = _compress(transposed[i]);
      transposed[i] = transposed[i].reversed.toList();
      if (transposed[i].toString() != oldRow.reversed.toString()) moved = true;
    }
    board = _transposeBoard(transposed);
    if (moved) _addNewTile();
  }

  List<List<int>> _transposeBoard(List<List<int>> board) {
    List<List<int>> transposedBoard = List.generate(4, (_) => List.filled(4, 0));
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        transposedBoard[i][j] = board[j][i];
      }
    }
    return transposedBoard;
  }

  bool isGameOver() {
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (board[i][j] == 0) return false;
      }
    }

    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (board[i][j] == board[i][j + 1] || board[i][j] == board[i + 1][j]) {
          return false;
        }
      }
    }

    for (int i = 0; i < 3; i++) {
      if (board[i][3] == board[i + 1][3] || board[3][i] == board[3][i + 1]) {
        return false;
      }
    }

    return true;
  }

  bool isWin() {
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (board[i][j] == 2048) return true;
      }
    }
    return false;
  }

  void _playWinSound() async {
    await _audioPlayer.play(AssetSource('sounds/win.mp3'));
  }

  void _playLoseSound() async {
    await _audioPlayer.play(AssetSource('sounds/lose.mp3'));
  }

  void checkGameOver() {
    if (isGameOver()) {
      gameOver = true;
      _playLoseSound();
    } else if (isWin() && !gameWon) {
      gameWon = true;
      _playWinSound();
    }
  }
}