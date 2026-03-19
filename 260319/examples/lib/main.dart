// ─────────────────────────────────────────────
//  game_screen.dart  –  Main UI
//  Widgets used:
//    • List<String?>         → board data
//    • List<MoveRecord>      → move history data
//    • GridView.count        → 3×3 játéktábla
//    • ListView.builder      → lépéstörténet
//    • GridView.count        → eredménypanel
// ─────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'game_model.dart';
import 'score_storage.dart';

// ── Theme palettes ───────────────────────────
class AppTheme {
  final Color bg;
  final Color surface;
  final Color card;
  final Color border;
  final Color text;
  final Color textDim;
  final bool isDark;

  const AppTheme({
    required this.bg,
    required this.surface,
    required this.card,
    required this.border,
    required this.text,
    required this.textDim,
    required this.isDark,
  });

  static const dark = AppTheme(
    bg:      Color(0xFF0D0D1A),
    surface: Color(0xFF16213E),
    card:    Color(0xFF1A2540),
    border:  Color(0xFF0F3460),
    text:    Color(0xFFF0F4FF),
    textDim: Color(0xFF8899AA),
    isDark:  true,
  );

  static const light = AppTheme(
    bg:      Color(0xFFF0F4FF),
    surface: Color(0xFFE2E8F4),
    card:    Color(0xFFFFFFFF),
    border:  Color(0xFFB0BCDC),
    text:    Color(0xFF0D0D1A),
    textDim: Color(0xFF5566AA),
    isDark:  false,
  );
}

const _xColor = Color(0xFFE94560);
const _oColor = Color(0xFF00B4D8);
const _gold   = Color(0xFFFFAA00);

// ─────────────────────────────────────────────
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {

  final GameModel _game  = GameModel();
  final GameScore _score = GameScore();

  bool _darkMode   = true;
  bool _scoreLoaded = false;   // betöltés folyamatban?
  int? _lastMoved;

  AppTheme get _theme => _darkMode ? AppTheme.dark : AppTheme.light;

  late AnimationController _pulseCtrl;
  late Animation<double>   _pulseAnim;

  // ── Lifecycle ─────────────────────────────
  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnim = Tween(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    _loadScore();
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  // ── Perzisztencia ─────────────────────────
  Future<void> _loadScore() async {
    final saved = await ScoreStorage.load();
    setState(() {
      _score.xWins  = saved['xWins']!;
      _score.oWins  = saved['oWins']!;
      _score.draws  = saved['draws']!;
      _scoreLoaded  = true;
    });
  }

  Future<void> _saveScore() async {
    await ScoreStorage.save(
      xWins: _score.xWins,
      oWins: _score.oWins,
      draws: _score.draws,
    );
  }

  Future<void> _clearScore() async {
    await ScoreStorage.reset();
    setState(() {
      _score.xWins = 0;
      _score.oWins = 0;
      _score.draws = 0;
    });
  }

  // ── Játéklogika ───────────────────────────
  void _onCellTap(int index) {
    if (_game.isOver || _game.board[index] != null) return;
    setState(() {
      _lastMoved = index;
      _game.makeMove(index);
      if (_game.winner != null) {
        if (_game.winner == Player.x) _score.xWins++;
        else _score.oWins++;
        _saveScore();                   // ← mentés győztes esetén
      } else if (_game.isDraw) {
        _score.draws++;
        _saveScore();                   // ← mentés döntetlen esetén
      }
    });
  }

  void _resetGame() {
    setState(() {
      _game.reset();
      _lastMoved = null;
    });
  }

  // ── Eredmény törlése megerősítéssel ───────
  Future<void> _confirmClearScore() async {
    final t = _theme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: t.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Eredmény törlése',
          style: TextStyle(color: t.text, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Biztosan törli az összes mentett eredményt?',
          style: TextStyle(color: t.textDim),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Mégse', style: TextStyle(color: t.textDim)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'Törlés',
              style: TextStyle(color: _xColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) await _clearScore();
  }

  // ── Build ──────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final t = _theme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      color: t.bg,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = constraints.maxHeight;
            final boardSize = (w * 0.88).clamp(0.0, h * 0.48);

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: h),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      _buildHeader(t),
                      const SizedBox(height: 10),
                      _buildScoreGrid(t),
                      const SizedBox(height: 10),
                      _buildStatusBanner(t),
                      const SizedBox(height: 12),
                      _buildBoard(t, boardSize),
                      const SizedBox(height: 12),
                      _buildButtons(t),
                      const SizedBox(height: 12),
                      _buildHistoryPanel(t, h * 0.20),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────
  Widget _buildHeader(AppTheme t) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Dark/light toggle
        GestureDetector(
          onTap: () => setState(() => _darkMode = !_darkMode),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 56,
            height: 28,
            decoration: BoxDecoration(
              color: _darkMode
                  ? _oColor.withOpacity(0.20)
                  : _xColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _darkMode
                    ? _oColor.withOpacity(0.55)
                    : _xColor.withOpacity(0.4),
              ),
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  left: _darkMode ? 2 : 28,
                  top: 2,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: _darkMode ? _oColor : _xColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _darkMode ? '🌙' : '☀️',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Title
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _neon('✕', _xColor, 20),
            const SizedBox(width: 6),
            Text(
              'TIC  TAC  TOE',
              style: TextStyle(
                color: t.text,
                fontSize: 17,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
                shadows: t.isDark
                    ? [Shadow(color: _oColor.withOpacity(0.5), blurRadius: 10)]
                    : [],
              ),
            ),
            const SizedBox(width: 6),
            _neon('○', _oColor, 20),
          ],
        ),

        const SizedBox(width: 56),
      ],
    );
  }

  // ── Score panel – GridView ─────────────────
  Widget _buildScoreGrid(AppTheme t) {
    final List<Map<String, dynamic>> scoreItems = [
      {'label': 'X nyert',   'value': _score.xWins, 'color': _xColor},
      {'label': 'Döntetlen', 'value': _score.draws,  'color': _gold},
      {'label': 'O nyert',   'value': _score.oWins, 'color': _oColor},
    ];

    // Betöltés alatt skeleton-szerű megjelenés
    if (!_scoreLoaded) {
      return SizedBox(
        height: 62,
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.6,
          children: List.generate(3, (_) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: t.card,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: t.border.withOpacity(0.3)),
            ),
            child: Center(
              child: SizedBox(
                width: 16, height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: t.textDim,
                ),
              ),
            ),
          )),
        ),
      );
    }

    return SizedBox(
      height: 62,
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 0,
        childAspectRatio: 2.6,
        physics: const NeverScrollableScrollPhysics(),
        children: scoreItems.map((item) {
          final color = item['color'] as Color;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: t.card,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withOpacity(0.4), width: 1.2),
              boxShadow: t.isDark
                  ? [BoxShadow(color: color.withOpacity(0.08), blurRadius: 8)]
                  : [const BoxShadow(color: Colors.black12, blurRadius: 3)],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${item['value']}',
                  style: TextStyle(
                    color: color,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                Text(
                  item['label'] as String,
                  style: TextStyle(color: t.textDim, fontSize: 10),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Status banner ──────────────────────────
  Widget _buildStatusBanner(AppTheme t) {
    String text;
    Color color;

    if (_game.winner != null) {
      text = '🏆  ${_game.winner!.symbol} nyert!';
      color = _game.winner == Player.x ? _xColor : _oColor;
    } else if (_game.isDraw) {
      text = '🤝  Döntetlen!';
      color = _gold;
    } else {
      text = '${_game.currentPlayer.symbol} következik';
      color = _game.currentPlayer == Player.x ? _xColor : _oColor;
    }

    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (_, __) => Transform.scale(
        scale: _game.isOver ? _pulseAnim.value : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          decoration: BoxDecoration(
            color: color.withOpacity(t.isDark ? 0.12 : 0.10),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
    );
  }

  // ── Board – GridView ───────────────────────
  Widget _buildBoard(AppTheme t, double size) {
    return SizedBox(
      width: size,
      height: size,
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 7,
        mainAxisSpacing: 7,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(9, (i) => _buildCell(i, t)),
      ),
    );
  }

  Widget _buildCell(int index, AppTheme t) {
    final value  = _game.board[index];
    final isWin  = _game.winningLine?.contains(index) ?? false;
    final isLast = _lastMoved == index;

    Color borderColor;
    Color bgColor;

    if (isWin) {
      borderColor = _gold;
      bgColor = _gold.withOpacity(t.isDark ? 0.12 : 0.14);
    } else if (value == 'X') {
      borderColor = _xColor.withOpacity(0.6);
      bgColor = _xColor.withOpacity(t.isDark ? 0.08 : 0.06);
    } else if (value == 'O') {
      borderColor = _oColor.withOpacity(0.6);
      bgColor = _oColor.withOpacity(t.isDark ? 0.08 : 0.06);
    } else {
      borderColor = t.border;
      bgColor = t.card;
    }

    return GestureDetector(
      onTap: () => _onCellTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: isWin ? 2.5 : 1.5),
          boxShadow: isWin
              ? [BoxShadow(color: _gold.withOpacity(0.3), blurRadius: 14)]
              : isLast
                  ? [BoxShadow(
                      color: (value == 'X' ? _xColor : _oColor).withOpacity(0.2),
                      blurRadius: 10,
                    )]
                  : t.isDark
                      ? [const BoxShadow(color: Colors.black26, blurRadius: 4)]
                      : [const BoxShadow(color: Colors.black12, blurRadius: 3)],
        ),
        child: Center(
          child: AnimatedScale(
            scale: value != null ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 280),
            curve: Curves.elasticOut,
            child: value == null
                ? const SizedBox.shrink()
                : _neon(value, value == 'X' ? _xColor : _oColor, 36),
          ),
        ),
      ),
    );
  }

  // ── Buttons row ────────────────────────────
  Widget _buildButtons(AppTheme t) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Új játék
        GestureDetector(
          onTap: _resetGame,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xCCE94560), Color(0xCC00B4D8)],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: _xColor.withOpacity(t.isDark ? 0.3 : 0.18),
                  blurRadius: 14,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Text(
              'ÚJ JÁTÉK',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 13,
                letterSpacing: 2.5,
              ),
            ),
          ),
        ),

        const SizedBox(width: 12),

        // Eredmény törlése
        GestureDetector(
          onTap: _confirmClearScore,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: t.card,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: _xColor.withOpacity(0.45),
                width: 1.3,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete_outline, color: _xColor, size: 15),
                const SizedBox(width: 5),
                Text(
                  'Törlés',
                  style: TextStyle(
                    color: _xColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Move history – ListView ─────────────────
  Widget _buildHistoryPanel(AppTheme t, double maxH) {
    final List<MoveRecord> history = _game.moveHistory;
    final panelH = history.isEmpty ? 38.0 : maxH.clamp(80.0, 150.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.history, color: t.textDim, size: 13),
            const SizedBox(width: 5),
            Text(
              'Lépéstörténet  (${history.length} lépés)',
              style: TextStyle(color: t.textDim, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 5),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: panelH,
          decoration: BoxDecoration(
            color: t.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: t.border.withOpacity(0.5)),
          ),
          child: history.isEmpty
              ? Center(
                  child: Text(
                    'Még nem történt lépés',
                    style: TextStyle(color: t.textDim, fontSize: 12),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(5),
                  itemCount: history.length,
                  reverse: true,
                  itemBuilder: (context, i) {
                    final move  = history[history.length - 1 - i];
                    final color = move.player == Player.x ? _xColor : _oColor;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: color.withOpacity(t.isDark ? 0.07 : 0.06),
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(color: color.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${move.turnNumber}',
                                style: TextStyle(
                                  color: color,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            move.player.symbol,
                            style: TextStyle(
                              color: color,
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '→  ${move.cell}',
                            style: TextStyle(color: t.text, fontSize: 12),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ── Neon text helper ───────────────────────
  Widget _neon(String text, Color color, double size) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.w900,
        shadows: [
          Shadow(color: color.withOpacity(0.7), blurRadius: 8),
          Shadow(color: color.withOpacity(0.3), blurRadius: 20),
        ],
      ),
    );
  }
}