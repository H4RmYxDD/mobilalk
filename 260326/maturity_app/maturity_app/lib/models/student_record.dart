// models/student_record.dart
// Az adatmodellek a három fő entitást reprezentálják

import 'package:flutter/foundation.dart';

/// Egy érettségi tantárgy és a hozzá tartozó jegy
class ExamResult {
  final String id;
  String subject; // tantárgy neve
  int grade; // jegy (1–5)

  ExamResult({
    required this.id,
    required this.subject,
    required this.grade,
  });

  /// JSON-ból visszaállítás (perzisztencia előkészítés)
  factory ExamResult.fromMap(Map<String, dynamic> map) {
    return ExamResult(
      id: map['id'] as String,
      subject: map['subject'] as String,
      grade: map['grade'] as int,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'subject': subject,
        'grade': grade,
      };
}

/// Nyelvvizsga adatok
class LanguageExam {
  final String id;
  String language; // pl. "Angol"
  String level; // pl. "B2", "C1"
  String type; // "írásbeli" | "szóbeli" | "komplex"
  DateTime date;

  LanguageExam({
    required this.id,
    required this.language,
    required this.level,
    required this.type,
    required this.date,
  });

  factory LanguageExam.fromMap(Map<String, dynamic> map) {
    return LanguageExam(
      id: map['id'] as String,
      language: map['language'] as String,
      level: map['level'] as String,
      type: map['type'] as String,
      date: DateTime.parse(map['date'] as String),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'language': language,
        'level': level,
        'type': type,
        'date': date.toIso8601String(),
      };
}

/// A tanuló teljes törzslapja
class StudentRecord {
  final String id;
  String name; // tanuló neve
  DateTime birthDate; // születési dátum
  String motherName; // anyja neve
  String schoolName; // iskola neve
  List<ExamResult> examResults; // érettségi tárgyak és jegyek
  List<LanguageExam> languageExams; // nyelvvizsgák

  StudentRecord({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.motherName,
    required this.schoolName,
    List<ExamResult>? examResults,
    List<LanguageExam>? languageExams,
  })  : examResults = examResults ?? [],
        languageExams = languageExams ?? [];

  /// Átlagos érettségi jegy kiszámítása
  double get averageGrade {
    if (examResults.isEmpty) return 0.0;
    final sum = examResults.fold(0, (acc, e) => acc + e.grade);
    return sum / examResults.length;
  }

  factory StudentRecord.fromMap(Map<String, dynamic> map) {
    return StudentRecord(
      id: map['id'] as String,
      name: map['name'] as String,
      birthDate: DateTime.parse(map['birthDate'] as String),
      motherName: map['motherName'] as String,
      schoolName: map['schoolName'] as String,
      examResults: (map['examResults'] as List<dynamic>)
          .map((e) => ExamResult.fromMap(e as Map<String, dynamic>))
          .toList(),
      languageExams: (map['languageExams'] as List<dynamic>)
          .map((e) => LanguageExam.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'birthDate': birthDate.toIso8601String(),
        'motherName': motherName,
        'schoolName': schoolName,
        'examResults': examResults.map((e) => e.toMap()).toList(),
        'languageExams': languageExams.map((e) => e.toMap()).toList(),
      };
}
