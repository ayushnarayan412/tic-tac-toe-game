import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TIC TAC TOE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TicTacToe(),
    );
  }
}

class TicTacToe extends StatefulWidget {
  const TicTacToe({super.key});

  @override
  State<TicTacToe> createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  List<List<String>> board = List.generate(3, (_) => List.filled(3, ''));
  List<int> winnerIndex = [];
  bool xTurn = true;
  String winner = '';
  List<MaterialColor> normalColor = [Colors.blue, Colors.red];
  List<MaterialColor> winnerColor = [Colors.green, Colors.green];

  void _onTileTap(int row, int col) {
    if (board[row][col] != '' || winner != '') return;

    setState(() {
      board[row][col] = xTurn ? 'X' : 'O';
      xTurn = !xTurn;
      winner = _checkWinner();
    });
  }

  String _checkWinner() {
    for (int i = 0; i < 3; i++) {
      if (board[i][0] != '' &&
          board[i][0] == board[i][1] &&
          board[i][1] == board[i][2]) {
        winnerIndex.addAll([i * 3, i * 3 + 1, i * 3 + 2]);
        return board[i][0];
      }
      if (board[0][i] != '' &&
          board[0][i] == board[1][i] &&
          board[1][i] == board[2][i]) {
        winnerIndex.addAll([i, i + 3, i + 6]);
        return board[0][i];
      }
    }

    if (board[0][0] != '' &&
        board[0][0] == board[1][1] &&
        board[1][1] == board[2][2]) {
      winnerIndex.addAll([0, 4, 8]);
      return board[0][0];
    }
    if (board[0][2] != '' &&
        board[0][2] == board[1][1] &&
        board[1][1] == board[2][0]) {
      winnerIndex.addAll([2, 4, 6]);
      return board[0][2];
    }
    //checking for a draw condition

    if (!board.any((row) => row.any((cell) => cell == ''))) {
      return 'Draw';
    }
    return '';
  }

  void _resetGame() {
    setState(() {
      board = List.generate(3, (_) => List.filled(3, ''));
      winnerIndex = [];
      xTurn = true;
      winner = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Tic Tac Toe')),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            winner == ''
                ? (xTurn ? 'X\'s turn' : 'O\'s turn')
                : winner == 'Draw'
                    ? 'It \'s a Draw'
                    : 'winner : $winner',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          SizedBox(
              height: 300,
              width: 300,
              child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    int row = index ~/ 3;
                    int col = index % 3;

                    return GestureDetector(
                        onTap: () => _onTileTap(row, col),
                        child: Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: winnerIndex.contains(index)
                                      ? winnerColor
                                      : normalColor,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomLeft,
                                ),
                                border: Border.all(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black26)
                                ]),
                            margin: const EdgeInsets.all(4),
                            child: Center(
                              child: Text(
                                board[row][col],
                                style: const TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                          blurRadius: 10.0,
                                          color: Colors.black26,
                                          offset: Offset(2, 2))
                                    ]),
                              ),
                            )));
                  })),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: _resetGame,
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                )),
            child: const Text(
              'Reset game',
              style: TextStyle(fontSize: 40),
            ),
          )
        ])));
  }
}
