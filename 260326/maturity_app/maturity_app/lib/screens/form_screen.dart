// screens/form_screen.dart
// Adatbeviteli képernyő: új törzslap létrehozása vagy meglévő szerkesztése

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/student_record.dart';
import '../providers/student_provider.dart';

// UUID generátor egyedi azonosítókhoz
const _uuid = Uuid();

class FormScreen extends StatefulWidget {
  /// Ha null, akkor új törzslap; ha meg van adva, szerkesztés
  final StudentRecord? existingRecord;

  const FormScreen({super.key, this.existingRecord});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  // Form kulcs a validációhoz
  final _formKey = GlobalKey<FormState>();

  // Alap mezők kontrollerje
  late final TextEditingController _nameCtrl;
  late final TextEditingController _motherNameCtrl;
  late final TextEditingController _schoolCtrl;

  // Születési dátum
  late DateTime _birthDate;

  // Dinamikus érettségi lista (másolat, hogy szabadon szerkeszthető legyen)
  late List<ExamResult> _examResults;

  // Dinamikus nyelvvizsga lista
  late List<LanguageExam> _languageExams;

  bool get _isEditing => widget.existingRecord != null;

  @override
  void initState() {
    super.initState();
    final rec = widget.existingRecord;
    // Ha szerkesztés: meglévő értékek betöltése; ha új: alapértelmezés
    _nameCtrl = TextEditingController(text: rec?.name ?? '');
    _motherNameCtrl = TextEditingController(text: rec?.motherName ?? '');
    _schoolCtrl = TextEditingController(text: rec?.schoolName ?? '');
    _birthDate = rec?.birthDate ?? DateTime(2000, 1, 1);
    // Másolatot csinálunk, hogy a "Mégsem" ne módosítsa az eredetit
    _examResults = rec?.examResults
            .map((e) => ExamResult(id: e.id, subject: e.subject, grade: e.grade))
            .toList() ??
        [];
    _languageExams = rec?.languageExams
            .map(
              (e) => LanguageExam(
                id: e.id,
                language: e.language,
                level: e.level,
                type: e.type,
                date: e.date,
              ),
            )
            .toList() ??
        [];
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _motherNameCtrl.dispose();
    _schoolCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy. MM. dd.');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Törzslap szerkesztése' : 'Új törzslap',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Személyes adatok ──────────────────────────────────
              _buildSectionHeader('Személyes adatok', Icons.person),
              const SizedBox(height: 8),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Név
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: _inputDecoration(
                          'Tanuló neve',
                          Icons.badge,
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'A név kötelező'
                                : null,
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 12),

                      // Anyja neve
                      TextFormField(
                        controller: _motherNameCtrl,
                        decoration: _inputDecoration(
                          'Anyja neve',
                          Icons.woman,
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Az anyja neve kötelező'
                                : null,
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 12),

                      // Iskola neve
                      TextFormField(
                        controller: _schoolCtrl,
                        decoration: _inputDecoration(
                          'Iskola neve',
                          Icons.school,
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Az iskola neve kötelező'
                                : null,
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 12),

                      // Születési dátum picker
                      InkWell(
                        onTap: () => _pickBirthDate(context),
                        borderRadius: BorderRadius.circular(8),
                        child: InputDecorator(
                          decoration: _inputDecoration(
                            'Születési dátum',
                            Icons.cake,
                          ),
                          child: Text(
                            dateFormat.format(_birthDate),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── Érettségi tárgyak ─────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionHeader(
                      'Érettségi tárgyak', Icons.assignment),
                  TextButton.icon(
                    onPressed: _addExamResult,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Hozzáad'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF1A237E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_examResults.isEmpty)
                _buildEmptyHint('Még nincs tantárgy hozzáadva.')
              else
                ..._examResults.asMap().entries.map(
                      (entry) => _ExamResultRow(
                        key: ValueKey(entry.value.id),
                        result: entry.value,
                        onRemove: () =>
                            setState(() => _examResults.removeAt(entry.key)),
                      ),
                    ),
              const SizedBox(height: 20),

              // ── Nyelvvizsgák ─────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionHeader('Nyelvvizsgák', Icons.language),
                  TextButton.icon(
                    onPressed: _addLanguageExam,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Hozzáad'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.teal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_languageExams.isEmpty)
                _buildEmptyHint('Még nincs nyelvvizsga hozzáadva.')
              else
                ..._languageExams.asMap().entries.map(
                      (entry) => _LanguageExamRow(
                        key: ValueKey(entry.value.id),
                        exam: entry.value,
                        onRemove: () => setState(
                            () => _languageExams.removeAt(entry.key)),
                      ),
                    ),
              const SizedBox(height: 32),

              // ── Mentés gomb ───────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: Text(
                    _isEditing ? 'Mentés' : 'Törzslap létrehozása',
                    style: const TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A237E),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // ── Segéd metódusok ───────────────────────────────────────────────

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF1A237E)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1A237E), size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A237E),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyHint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text,
        style: TextStyle(color: Colors.grey[500], fontStyle: FontStyle.italic),
      ),
    );
  }

  /// Születési dátum kiválasztása
  Future<void> _pickBirthDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Válassz születési dátumot',
      locale: const Locale('hu'),
    );
    if (picked != null) {
      setState(() => _birthDate = picked);
    }
  }

  /// Új érettségi tárgy hozzáadása (alapértelmezett értékekkel)
  void _addExamResult() {
    setState(() {
      _examResults.add(
        ExamResult(
          id: _uuid.v4(),
          subject: '',
          grade: 3,
        ),
      );
    });
  }

  /// Új nyelvvizsga hozzáadása
  void _addLanguageExam() {
    setState(() {
      _languageExams.add(
        LanguageExam(
          id: _uuid.v4(),
          language: 'Angol',
          level: 'B2',
          type: 'komplex',
          date: DateTime.now(),
        ),
      );
    });
  }

  /// Mentés: validáció + Provider frissítés
  void _save() {
    // Form mezők validálása
    if (!_formKey.currentState!.validate()) return;

    // Érettségi sorok validálása
    for (final exam in _examResults) {
      if (exam.subject.trim().isEmpty) {
        _showError('Töltsd ki az összes tantárgy nevét!');
        return;
      }
    }

    final provider = context.read<StudentProvider>();

    if (_isEditing) {
      // Meglévő rekord frissítése
      final updated = widget.existingRecord!
        ..name = _nameCtrl.text.trim()
        ..motherName = _motherNameCtrl.text.trim()
        ..schoolName = _schoolCtrl.text.trim()
        ..birthDate = _birthDate
        ..examResults.clear()
        ..examResults.addAll(_examResults)
        ..languageExams.clear()
        ..languageExams.addAll(_languageExams);

      provider.updateRecord(updated);
    } else {
      // Új rekord létrehozása
      final newRecord = StudentRecord(
        id: _uuid.v4(),
        name: _nameCtrl.text.trim(),
        birthDate: _birthDate,
        motherName: _motherNameCtrl.text.trim(),
        schoolName: _schoolCtrl.text.trim(),
        examResults: _examResults,
        languageExams: _languageExams,
      );
      provider.addRecord(newRecord);
    }

    // Visszalépés a listára
    Navigator.pop(context);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}

// ══ Érettségi tárgy beviteli sor ══════════════════════════════════════════════

class _ExamResultRow extends StatefulWidget {
  final ExamResult result;
  final VoidCallback onRemove;

  const _ExamResultRow({
    super.key,
    required this.result,
    required this.onRemove,
  });

  @override
  State<_ExamResultRow> createState() => _ExamResultRowState();
}

class _ExamResultRowState extends State<_ExamResultRow> {
  late final TextEditingController _subjectCtrl;

  @override
  void initState() {
    super.initState();
    _subjectCtrl = TextEditingController(text: widget.result.subject);
  }

  @override
  void dispose() {
    _subjectCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Tantárgy neve
            Expanded(
              child: TextFormField(
                controller: _subjectCtrl,
                decoration: const InputDecoration(
                  labelText: 'Tantárgy neve',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                ),
                onChanged: (v) => widget.result.subject = v,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            const SizedBox(width: 10),
            // Jegy dropdown (1–5)
            SizedBox(
              width: 80,
              child: DropdownButtonFormField<int>(
                value: widget.result.grade,
                decoration: const InputDecoration(
                  labelText: 'Jegy',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                ),
                items: [1, 2, 3, 4, 5]
                    .map(
                      (g) => DropdownMenuItem(
                        value: g,
                        child: Text('$g'),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    setState(() => widget.result.grade = v);
                  }
                },
              ),
            ),
            const SizedBox(width: 4),
            // Törlés
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
              onPressed: widget.onRemove,
              tooltip: 'Eltávolítás',
            ),
          ],
        ),
      ),
    );
  }
}

// ══ Nyelvvizsga beviteli sor ══════════════════════════════════════════════════

class _LanguageExamRow extends StatefulWidget {
  final LanguageExam exam;
  final VoidCallback onRemove;

  const _LanguageExamRow({
    super.key,
    required this.exam,
    required this.onRemove,
  });

  @override
  State<_LanguageExamRow> createState() => _LanguageExamRowState();
}

class _LanguageExamRowState extends State<_LanguageExamRow> {
  // Elérhető nyelvek
  static const _languages = [
    'Angol', 'Német', 'Francia', 'Olasz', 'Spanyol',
    'Orosz', 'Kínai', 'Japán', 'Magyar', 'Egyéb',
  ];

  // Elérhető szintek
  static const _levels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

  // Vizsgatípusok
  static const _types = ['írásbeli', 'szóbeli', 'komplex'];

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy. MM. dd.');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Colors.teal.withOpacity(0.03),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.language, color: Colors.teal, size: 18),
                const SizedBox(width: 6),
                const Text(
                  'Nyelvvizsga',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon:
                      const Icon(Icons.remove_circle_outline, color: Colors.red),
                  onPressed: widget.onRemove,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Eltávolítás',
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Nyelv + Szint egy sorban
            Row(
              children: [
                // Nyelv dropdown
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: widget.exam.language,
                    decoration: const InputDecoration(
                      labelText: 'Nyelv',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    ),
                    items: _languages
                        .map(
                          (l) => DropdownMenuItem(value: l, child: Text(l)),
                        )
                        .toList(),
                    onChanged: (v) =>
                        setState(() => widget.exam.language = v ?? 'Angol'),
                  ),
                ),
                const SizedBox(width: 10),
                // Szint dropdown
                SizedBox(
                  width: 90,
                  child: DropdownButtonFormField<String>(
                    value: widget.exam.level,
                    decoration: const InputDecoration(
                      labelText: 'Szint',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    ),
                    items: _levels
                        .map(
                          (l) => DropdownMenuItem(value: l, child: Text(l)),
                        )
                        .toList(),
                    onChanged: (v) =>
                        setState(() => widget.exam.level = v ?? 'B2'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Típus + Dátum
            Row(
              children: [
                // Típus dropdown
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: widget.exam.type,
                    decoration: const InputDecoration(
                      labelText: 'Típus',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    ),
                    items: _types
                        .map(
                          (t) => DropdownMenuItem(value: t, child: Text(t)),
                        )
                        .toList(),
                    onChanged: (v) =>
                        setState(() => widget.exam.type = v ?? 'komplex'),
                  ),
                ),
                const SizedBox(width: 10),
                // Dátum picker
                Expanded(
                  child: InkWell(
                    onTap: () => _pickDate(context),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Dátum',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today, size: 18),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      ),
                      child: Text(
                        dateFormat.format(widget.exam.date),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.exam.date,
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
      helpText: 'Vizsga dátuma',
    );
    if (picked != null) {
      setState(() => widget.exam.date = picked);
    }
  }
}
