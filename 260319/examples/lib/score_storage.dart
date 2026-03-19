// ─────────────────────────────────────────────
//  score_storage.dart
//  Perzisztens eredménytárolás shared_preferences-szel
// ─────────────────────────────────────────────

import 'package:shared_preferences/shared_preferences.dart';

class ScoreStorage {
  static const _keyXWins = 'score_x_wins';
  static const _keyOWins = 'score_o_wins';
  static const _keyDraws = 'score_draws';

  /// Betölti a mentett eredményeket.
  /// Ha nincs mentés, 0-t ad vissza minden mezőre.
  static Future<Map<String, int>> load() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'xWins': prefs.getInt(_keyXWins) ?? 0,
      'oWins': prefs.getInt(_keyOWins) ?? 0,
      'draws': prefs.getInt(_keyDraws) ?? 0,
    };
  }

  /// Elmenti az aktuális eredményeket.
  static Future<void> save({
    required int xWins,
    required int oWins,
    required int draws,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyXWins, xWins);
    await prefs.setInt(_keyOWins, oWins);
    await prefs.setInt(_keyDraws, draws);
  }

  /// Törli az összes mentett eredményt.
  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyXWins);
    await prefs.remove(_keyOWins);
    await prefs.remove(_keyDraws);
  }
}
