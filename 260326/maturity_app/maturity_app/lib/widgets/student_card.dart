// widgets/student_card.dart
// Kártya widget egy törzslap összesített megjelenítéséhez

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/student_record.dart';

class StudentCard extends StatelessWidget {
  final StudentRecord record;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const StudentCard({
    super.key,
    required this.record,
    required this.onTap,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy. MM. dd.');
    final hasLanguageExam = record.languageExams.isNotEmpty;
    final examCount = record.examResults.length;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fejléc sáv az iskola nevével
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF1A237E),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  const Icon(Icons.school, color: Colors.white70, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      record.schoolName,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Szerkesztés és törlés gombok
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white70, size: 18),
                    onPressed: onEdit,
                    tooltip: 'Szerkesztés',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                    onPressed: onDelete,
                    tooltip: 'Törlés',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            // Tartalom
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tanuló neve
                  Text(
                    record.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A237E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Születési dátum
                  Text(
                    'Születési dátum: ${dateFormat.format(record.birthDate)}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  // Összesítő chip-ek
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _buildChip(
                        icon: Icons.assignment,
                        label: '$examCount tantárgy',
                        color: const Color(0xFF3949AB),
                      ),
                      if (examCount > 0)
                        _buildChip(
                          icon: Icons.grade,
                          label:
                              'Átlag: ${record.averageGrade.toStringAsFixed(1)}',
                          color: _gradeColor(record.averageGrade),
                        ),
                      if (hasLanguageExam)
                        _buildChip(
                          icon: Icons.language,
                          label:
                              '${record.languageExams.length} nyelvvizsga',
                          color: Colors.teal,
                        )
                      else
                        _buildChip(
                          icon: Icons.language,
                          label: 'Nincs nyelvvizsga',
                          color: Colors.grey,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            // Részletek gomb
            Padding(
              padding: const EdgeInsets.only(right: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: onTap,
                    icon: const Icon(Icons.arrow_forward, size: 16),
                    label: const Text('Részletek'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF1A237E),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Kis összesítő chip builder
  Widget _buildChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Átlag alapján szín
  Color _gradeColor(double avg) {
    if (avg >= 4.5) return Colors.green[700]!;
    if (avg >= 3.5) return Colors.lightGreen[700]!;
    if (avg >= 2.5) return Colors.orange[700]!;
    return Colors.red[700]!;
  }
}
