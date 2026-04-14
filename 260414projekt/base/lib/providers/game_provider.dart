import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/tile.dart';
import '../utils/layouts.dart';

class GameState {
  final List<Tile> tiles;
  final String? selectedTileId;
  final int time;
  final int score;
  final int moves;
  final List<List<String>> history; // undo-hoz: [id1, id2] párok
  final String? gameStatus; // 'win' | 'lose' | null

  GameState({
    required this.tiles,
    this.selectedTileId,
    this.time = 0,
    this.score = 1000,
    this.moves = 0,
    required this.history,
    this.gameStatus,
  });

  GameState copyWith({
    List<Tile>? tiles,
    String? selectedTileId,
    int? time,
    int? score,
    int? moves,
    List<List<String>>? history,
    String? gameStatus,
  }) =>
      GameState(
        tiles: tiles ?? this.tiles,
        selectedTileId: selectedTileId,
        time: time ?? this.time,
        score: score ?? this.score,
        moves: moves ?? this.moves,
        history: history ?? this.history,
        gameStatus: gameStatus,
      );
}

class GameNotifier extends StateNotifier<GameState> {
  GameNotifier() : super(GameState(tiles: [], history: [])) {
    _newGame();
  }

  void _newGame() {
    final positions = getTurtleLayout();
    final tileTypes = _generateTileTypes(positions.length);
    final tiles = <Tile>[];

    for (int i = 0; i < positions.length; i++) {
      final (x, y, z) = positions[i];
      tiles.add(Tile(
        id: 'tile_$i',
        type: tileTypes[i],
        x: x,
        y: y,
        z: z,
      ));
    }

    state = GameState(
      tiles: tiles,
      history: [],
      time: 0,
      score: 1000,
      moves: 0,
    );
  }

  List<String> _generateTileTypes(int count) {
    final base = ['1', '2', '3', '4', '5', '6', '7', '8', '9', 'D', 'W', 'F', 'B', 'C'];
    final List<String> types = [];
    final pairs = count ~/ 2;
    for (int i = 0; i < pairs; i++) {
      final t = base[i % base.length];
      types.add(t);
      types.add(t);
    }
    types.shuffle();
    return types;
  }

  bool isFree(Tile tile) {
    if (tile.isRemoved) return false;

    // Fedett-e? (magasabb réteg ugyanazon a helyen)
    final covered = state.tiles.any((t) =>
        t.x == tile.x && t.y == tile.y && t.z > tile.z && !t.isRemoved);
    if (covered) return false;

    // Oldal szabad-e?
    final leftBlocked = state.tiles.any((t) =>
        t.x == tile.x - 1 && t.y == tile.y && t.z == tile.z && !t.isRemoved);
    final rightBlocked = state.tiles.any((t) =>
        t.x == tile.x + 1 && t.y == tile.y && t.z == tile.z && !t.isRemoved);

    return !leftBlocked || !rightBlocked;
  }

  void selectTile(String id) {
    final tile = state.tiles.firstWhere((t) => t.id == id);
    if (tile.isRemoved || !isFree(tile)) return;

    if (state.selectedTileId == id) {
      state = state.copyWith(selectedTileId: null);
      return;
    }

    if (state.selectedTileId == null) {
      state = state.copyWith(selectedTileId: id);
      return;
    }

    final selected = state.tiles.firstWhere((t) => t.id == state.selectedTileId);
    if (selected.type == tile.type) {
      _removePair(selected.id, id);
    } else {
      state = state.copyWith(selectedTileId: id); // másikra vált
    }
  }

  void _removePair(String id1, String id2) {
    final newTiles = state.tiles.map((t) {
      if (t.id == id1 || t.id == id2) return t.copyWith(isRemoved: true);
      return t;
    }).toList();

    final newHistory = List<List<String>>.from(state.history)..add([id1, id2]);

    var newState = state.copyWith(
      tiles: newTiles,
      selectedTileId: null,
      moves: state.moves + 1,
      history: newHistory,
    );

    // Játék vége ellenőrzés
    final freeTiles = newTiles.where((t) => !t.isRemoved && isFree(t)).toList();
    final countMap = <String, int>{};
    for (final t in freeTiles) {
      countMap[t.type] = (countMap[t.type] ?? 0) + 1;
    }
    final hasMoves = countMap.values.any((c) => c >= 2);

    if (newTiles.every((t) => t.isRemoved)) {
      newState = newState.copyWith(gameStatus: 'win');
    } else if (!hasMoves) {
      newState = newState.copyWith(gameStatus: 'lose');
    }

    state = newState;
  }

  void undo() {
    if (state.history.isEmpty) return;
    final last = state.history.last;
    final newTiles = state.tiles.map((t) {
      if (last.contains(t.id)) return t.copyWith(isRemoved: false);
      return t;
    }).toList();

    final newHistory = List<List<String>>.from(state.history)..removeLast();

    state = state.copyWith(tiles: newTiles, history: newHistory);
  }

  void tick() {
    final newScore = (state.score - 5).clamp(0, 1000);
    state = state.copyWith(time: state.time + 1, score: newScore);
  }

  void newGame() => _newGame();
}

final gameProvider = StateNotifierProvider<GameNotifier, GameState>(
  (_) => GameNotifier(),
);