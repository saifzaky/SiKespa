import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../models/vital_signs.dart';
import './add_vital_signs_screen.dart';

class VitalSignsHistoryScreen extends StatelessWidget {
  const VitalSignsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userId = authProvider.currentUser!.uid;
    final FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Vital Signs'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Tambah Data',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddVitalSignsScreen(),
                ),
              );
              // Refresh handled by StreamBuilder
            },
          ),
        ],
      ),
      body: StreamBuilder<List<VitalSigns>>(
        stream: firestoreService.streamVitalSigns(userId),
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

          final vitalSignsList = snapshot.data ?? [];

          if (vitalSignsList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.show_chart, size: 80, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada data vital signs',
                    style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap tombol + untuk menambah data',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddVitalSignsScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Data Pertama'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
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

          return SingleChildScrollView(
            child: Column(
              children: [
                // Charts Section
                if (vitalSignsList.length >= 2) ...[
                  _buildChartSection('Tekanan Darah', vitalSignsList, 'bp'),
                  _buildChartSection(
                      'Detak Jantung', vitalSignsList, 'heartRate'),
                  _buildChartSection(
                      'Suhu Tubuh', vitalSignsList, 'temperature'),
                  _buildChartSection('Berat Badan', vitalSignsList, 'weight'),
                  _buildChartSection(
                      'Gula Darah', vitalSignsList, 'bloodSugar'),
                ],

                // History List
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Riwayat Data',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...vitalSignsList.map((vs) => _buildHistoryCard(vs)),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildChartSection(String title, List<VitalSigns> data, String type) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              _getChartData(data, type),
            ),
          ),
        ],
      ),
    );
  }

  LineChartData _getChartData(List<VitalSigns> data, String type) {
    final spots = <FlSpot>[];
    final reversedData = data.reversed.toList();

    for (int i = 0; i < reversedData.length && i < 10; i++) {
      final vs = reversedData[i];
      double value = 0;

      switch (type) {
        case 'bp':
          final bp = vs.bloodPressure.split('/');
          value = int.tryParse(bp[0])?.toDouble() ?? 0;
          break;
        case 'heartRate':
          value = vs.heartRate.toDouble();
          break;
        case 'temperature':
          value = vs.temperature;
          break;
        case 'weight':
          value = vs.weight;
          break;
        case 'bloodSugar':
          value = vs.bloodSugar;
          break;
      }

      spots.add(FlSpot(i.toDouble(), value));
    }

    return LineChartData(
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: Colors.blue.shade700,
          barWidth: 3,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            color: Colors.blue.shade100.withOpacity(0.3),
          ),
        ),
      ],
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: const TextStyle(fontSize: 10),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= 0 && value.toInt() < spots.length) {
                final date = reversedData[value.toInt()].date;
                return Text(
                  '${date.day}/${date.month}',
                  style: const TextStyle(fontSize: 10),
                );
              }
              return const Text('');
            },
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.shade300,
            strokeWidth: 1,
          );
        },
      ),
      borderData: FlBorderData(show: false),
    );
  }

  Widget _buildHistoryCard(VitalSigns vs) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  vs.isNormal ? Icons.check_circle : Icons.warning,
                  color: vs.isNormal ? Colors.green : Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('dd MMM yyyy, HH:mm').format(vs.date),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: vs.isNormal
                        ? Colors.green.shade50
                        : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    vs.statusText,
                    style: TextStyle(
                      fontSize: 12,
                      color: vs.isNormal
                          ? Colors.green.shade700
                          : Colors.orange.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _buildMetricChip('BP', vs.bloodPressure, Icons.favorite),
                _buildMetricChip('HR', '${vs.heartRate} bpm', Icons.favorite),
                _buildMetricChip(
                    'Temp', '${vs.temperature}°C', Icons.thermostat),
                _buildMetricChip(
                    'Weight', '${vs.weight} kg', Icons.monitor_weight),
                _buildMetricChip(
                    'Sugar', '${vs.bloodSugar} mg/dL', Icons.bloodtype),
              ],
            ),
            if (vs.notes != null && vs.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.note, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        vs.notes!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetricChip(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.blue.shade700),
          const SizedBox(width: 4),
          Text(
            '$label: $value',
            style: TextStyle(
              fontSize: 11,
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
