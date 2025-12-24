import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../models/schedule.dart';
import './add_medication_screen.dart';

class MedicationRemindersScreen extends StatelessWidget {
  const MedicationRemindersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userId = authProvider.currentUser!.uid;
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengingat Obat'),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Tambah Obat',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddMedicationScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Schedule>>(
        stream: firestoreService.streamSchedules(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 64, color: Colors.red.shade300),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                ],
              ),
            );
          }

          final medications = snapshot.data
                  ?.where((schedule) => schedule.type == 'medication')
                  .toList() ??
              [];

          if (medications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.medication, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada pengingat obat',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap tombol + untuk menambah pengingat',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddMedicationScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Pengingat Pertama'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // Group by active/past
          final activeMeds = medications.where((m) => m.isUpcoming).toList();
          final pastMeds = medications.where((m) => !m.isUpcoming).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (activeMeds.isNotEmpty) ...[
                Text(
                  'Aktif (${activeMeds.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...activeMeds.map((med) => _buildMedicationCard(
                    context, med, firestoreService, userId)),
                const SizedBox(height: 24),
              ],
              if (pastMeds.isNotEmpty) ...[
                Text(
                  'Selesai (${pastMeds.length})',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 12),
                ...pastMeds.map((med) => _buildMedicationCard(
                    context, med, firestoreService, userId,
                    isPast: true)),
              ],
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddMedicationScreen(),
            ),
          );
        },
        backgroundColor: Colors.orange.shade700,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildMedicationCard(
    BuildContext context,
    Schedule medication,
    FirestoreService firestoreService,
    String userId, {
    bool isPast = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isPast ? 0 : 2,
      color: isPast ? Colors.grey.shade100 : Colors.white,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isPast ? Colors.grey.shade300 : Colors.orange.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.medication,
            color: isPast ? Colors.grey.shade600 : Colors.orange.shade700,
          ),
        ),
        title: Text(
          medication.title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isPast ? Colors.grey.shade600 : null,
            decoration: isPast ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${DateFormat('dd MMM yyyy').format(medication.date)} - ${medication.time}',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            if (medication.frequency != null)
              Text(
                _getFrequencyText(medication.frequency!),
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
            if (medication.notes.isNotEmpty)
              Text(
                medication.notes,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: !isPast
            ? PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Hapus'),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) async {
                  if (value == 'delete') {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Hapus Pengingat'),
                        content:
                            const Text('Yakin ingin menghapus pengingat ini?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Hapus',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      await firestoreService.deleteSchedule(
                          userId, medication.id);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Pengingat dihapus')),
                        );
                      }
                    }
                  }
                },
              )
            : null,
      ),
    );
  }

  String _getFrequencyText(String frequency) {
    switch (frequency) {
      case 'daily':
        return 'Sekali sehari';
      case 'twice':
        return '2x sehari';
      case 'three_times':
        return '3x sehari';
      default:
        return frequency;
    }
  }
}
