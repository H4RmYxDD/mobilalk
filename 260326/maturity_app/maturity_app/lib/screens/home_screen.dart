// screens/home_screen.dart
// Főképernyő: a törzslapok listáját jeleníti meg Card widgetekkel

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import '../models/student_record.dart';
import '../widgets/student_card.dart';
import 'form_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Érettségi Törzslapok',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      // Consumer figyeli a Provider változásait és újraépíti a widgetet
      body: Consumer<StudentProvider>(
        builder: (context, provider, _) {
          final records = provider.records;

          // Ha még nincs törzslap, üres állapot megjelenítése
          if (records.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              return StudentCard(
                record: record,
                onTap: () => _openDetail(context, record),
                onDelete: () => _confirmDelete(context, provider, record),
                onEdit: () => _openEdit(context, record),
              );
            },
          );
        },
      ),
      // FAB: új törzslap létrehozása
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreate(context),
        backgroundColor: const Color(0xFF1A237E),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Új törzslap'),
      ),
    );
  }

  /// Üres állapot widget
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Még nincs törzslap',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hozz létre egyet a + gombbal!',
            style: TextStyle(color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _openCreate(context),
            icon: const Icon(Icons.add),
            label: const Text('Új törzslap létrehozása'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A237E),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _openCreate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FormScreen()),
    );
  }

  void _openEdit(BuildContext context, StudentRecord record) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FormScreen(existingRecord: record)),
    );
  }

  void _openDetail(BuildContext context, StudentRecord record) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailScreen(recordId: record.id)),
    );
  }

  /// Törlés előtt megerősítő dialógus
  Future<void> _confirmDelete(
    BuildContext context,
    StudentProvider provider,
    StudentRecord record,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Törlés megerősítése'),
        content: Text('Biztosan törlöd ${record.name} törzslapját?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Mégsem'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Törlés'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      provider.deleteRecord(record.id);
    }
  }
}
