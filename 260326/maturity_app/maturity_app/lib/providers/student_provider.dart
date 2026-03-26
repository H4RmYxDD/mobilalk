// providers/student_provider.dart
// Provider alapú állapotkezelés – a teljes alkalmazás adatait tartja karban

import 'package:flutter/foundation.dart';
import '../models/student_record.dart';

class StudentProvider extends ChangeNotifier {
  // A tárolt törzslapok listája (memóriában, újraindításkor elvész)
  final List<StudentRecord> _records = [];

  /// Olvasható lista a törzslapokról
  List<StudentRecord> get records => List.unmodifiable(_records);

  /// Új törzslap hozzáadása
  void addRecord(StudentRecord record) {
    _records.add(record);
    notifyListeners(); // értesítjük a figyelő widgeteket
  }

  /// Meglévő törzslap frissítése (szerkesztés)
  void updateRecord(StudentRecord updated) {
    final index = _records.indexWhere((r) => r.id == updated.id);
    if (index != -1) {
      _records[index] = updated;
      notifyListeners();
    }
  }

  /// Törzslap törlése ID alapján
  void deleteRecord(String id) {
    _records.removeWhere((r) => r.id == id);
    notifyListeners();
  }

  /// ID alapján keresés
  StudentRecord? findById(String id) {
    try {
      return _records.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }
}
