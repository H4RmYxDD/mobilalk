// ─────────────────────────────────────────────
//  game_model.dart  –  Tic Tac Toe game logic
// ─────────────────────────────────────────────

enum Player { x, o }

extension PlayerExt on Player {
  String get symbol => this == Player.x ? 'X' : 'O';
  Player get next => this == Player.x ? Player.o : Player.x;
}

class MoveRecord {
  final int index;        // 0-8
  final Player player;
  final int turnNumber;

  const MoveRecord({
    required this.index,
    required this.player,
    required this.turnNumber,
  });

  String get cell {
    final row = index ~/ 3 + 1;
    final col = index % 3 + 1;
    return 'Sor $row, Oszlop $col';
  }
}

class GameScore {
  int xWins;
  int oWins;
  int draws;

  GameScore({this.xWins = 0, this.oWins = 0, this.draws = 0});
}

class GameModel {
  // Uses a List<String?> – null means empty, 'X' or 'O' means taken
  List<String?> board = List.filled(9, null);

  // History as a List<MoveRecord>
  List<MoveRecord> moveHistory = [];

  Player currentPlayer = Player.x;
  Player? winner;
  bool get isDraw => winner == null && board.every((c) => c != null);
  bool get isOver => winner != null || isDraw;

  // Winning combinations stored as a List<List<int>>
  static const List<List<int>> winLines = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
    [0, 3, 6], [1, 4, 7], [2, 5, 8], // cols
    [0, 4, 8], [2, 4, 6],             // diags
  ];

  List<int>? winningLine;

  bool makeMove(int index) {
    if (board[index] != null || isOver) return false;

    board[index] = currentPlayer.symbol;
    moveHistory = [
      ...moveHistory,
      MoveRecord(
        index: index,
        player: currentPlayer,
        turnNumber: moveHistory.length + 1,
      ),
    ];

    _checkWinner();
    if (!isOver) currentPlayer = currentPlayer.next;
    return true;
  }

  void _checkWinner() {
    for (final line in winLines) {
      final a = board[line[0]];
      if (a != null && a == board[line[1]] && a == board[line[2]]) {
        winner = currentPlayer;
        winningLine = line;
        return;
      }
    }
  }

  void reset() {
    board = List.filled(9, null);
    moveHistory = [];
    currentPlayer = Player.x;
    winner = null;
    winningLine = null;
  }
}
