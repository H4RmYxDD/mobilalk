// screens/detail_screen.dart
// Részletes nézet egy törzslap teljes adataival

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/student_provider.dart';
import '../models/student_record.dart';
import 'form_screen.dart';

class DetailScreen extends StatelessWidget {
  final String recordId;

  const DetailScreen({super.key, required this.recordId});

  @override
  Widget build(BuildContext context) {
    // Mindig friss adatot kérünk a Provider-től
    final record = context.watch<StudentProvider>().findById(recordId);

    if (record == null) {
      // Ha közben törölték, visszalépünk
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final dateFormat = DateFormat('yyyy. MM. dd.');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Törzslap részletei',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Szerkesztés',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FormScreen(existingRecord: record),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Alapadatok kártya
            _buildSection(
              title: 'Személyes adatok',
              icon: Icons.person,
              color: const Color(0xFF1A237E),
              children: [
                _buildInfoRow(Icons.badge, 'Név', record.name),
                _buildInfoRow(
                  Icons.cake,
                  'Születési dátum',
                  dateFormat.format(record.birthDate),
                ),
                _buildInfoRow(Icons.woman, 'Anyja neve', record.motherName),
                _buildInfoRow(Icons.school, 'Iskola', record.schoolName),
              ],
            ),
            const SizedBox(height: 16),

            // Érettségi tárgyak
            _buildSection(
              title: 'Érettségi eredmények (${record.examResults.length} tantárgy)',
              icon: Icons.assignment,
              color: const Color(0xFF3949AB),
              children: record.examResults.isEmpty
                  ? [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'Nincsenek érettségi adatok.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    ]
                  : [
                      // Fejléc sor
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Tantárgy',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Text(
                              'Jegy',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      ...record.examResults
                          .map((e) => _buildExamRow(e))
                          ,
                      if (record.examResults.isNotEmpty) ...[
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Átlag:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                record.averageGrade.toStringAsFixed(2),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _gradeColor(record.averageGrade),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
            ),
            const SizedBox(height: 16),

            // Nyelvvizsgák
            _buildSection(
              title: 'Nyelvvizsgák (${record.languageExams.length})',
              icon: Icons.language,
              color: Colors.teal,
              children: record.languageExams.isEmpty
                  ? [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'Nincsenek nyelvvizsga adatok.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    ]
                  : record.languageExams
                      .map((exam) => _buildLanguageExamCard(exam, dateFormat))
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }

  /// Szekció (kártya fejléccel)
  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fejléc
          Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          // Tartalom
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  /// Egy adat sor (ikon + cimke + érték)
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  /// Érettségi tárgy sor
  Widget _buildExamRow(ExamResult exam) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(exam.subject, style: const TextStyle(fontSize: 14)),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _gradeColor(exam.grade.toDouble()),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${exam.grade}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Egy nyelvvizsga megjelenítése
  Widget _buildLanguageExamCard(LanguageExam exam, DateFormat fmt) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.teal.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                exam.language,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF00695C),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  exam.level,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Típus: ${exam.type}',
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
          Text(
            'Dátum: ${fmt.format(exam.date)}',
            style: TextStyle(color: Colors.grey[600], fontSize: 13),
          ),
        ],
      ),
    );
  }

  Color _gradeColor(double grade) {
    if (grade >= 4.5) return Colors.green[700]!;
    if (grade >= 3.5) return Colors.lightGreen[700]!;
    if (grade >= 2.5) return Colors.orange[700]!;
    return Colors.red[700]!;
  }
}
