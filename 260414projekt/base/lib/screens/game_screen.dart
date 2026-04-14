import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/game_provider.dart';
import '../widgets/mahjong_tile.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});
  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      ref.read(gameProvider.notifier).tick();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameProvider);
    final notifier = ref.read(gameProvider.notifier);

    // Győzelem/veszteség dialógus
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state.gameStatus != null) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
            title: Text(state.gameStatus == 'win' ? 'Gratulálok!' : 'Vesztettél'),
            content: Text(state.gameStatus == 'win'
                ? 'Sikeresen eltávolítottad az összes csempét!\nPontszám: ${state.score}'
                : 'Elfogyott a lépéslehetőség.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  notifier.newGame();
                },
                child: const Text('Új játék'),
              ),
            ],
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mahjong Solitaire'),
        backgroundColor: Colors.brown[800],
        actions: [
          IconButton(icon: const Icon(Icons.undo), onPressed: notifier.undo),
          IconButton(icon: const Icon(Icons.refresh), onPressed: notifier.newGame),
        ],
      ),
      body: Column(
        children: [
          // Fejléc
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Idő: ${state.time}s', style: const TextStyle(fontSize: 18)),
                Text('Pont: ${state.score}', style: const TextStyle(fontSize: 18)),
              ],
            ),
          ),
          // Játéktér
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (state.tiles.isEmpty) return const Center(child: CircularProgressIndicator());

                final maxX = state.tiles.map((t) => t.x).reduce((a, b) => a > b ? a : b) + 2;
                final maxY = state.tiles.map((t) => t.y).reduce((a, b) => a > b ? a : b) + 2;

                final tileWidth = (constraints.maxWidth / maxX).clamp(30.0, 70.0);
                final tileHeight = tileWidth * 1.35;

                return Stack(
                  children: state.tiles
                      .where((t) => !t.isRemoved)
                      .map((tile) {
                    final left = tile.x * tileWidth + tile.z * 6.0;
                    final top = tile.y * tileHeight + tile.z * 6.0;

                    return Positioned(
                      left: left,
                      top: top,
                      child: MahjongTile(
                        tile: tile,
                        size: tileWidth,
                        isSelected: tile.id == state.selectedTileId,
                        onTap: () => notifier.selectTile(tile.id),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}