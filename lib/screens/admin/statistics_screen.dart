import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  int _totalPatients = 0;
  Map<String, int> _bloodTypeStats = {};
  int _patientsWithAllergies = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() => _isLoading = true);

    try {
      final patients = await _firestoreService.getAllPatients();

      _totalPatients = patients.length;
      _patientsWithAllergies =
          patients.where((p) => p.allergies.isNotEmpty).length;

      // Count blood types
      _bloodTypeStats = {};
      for (var patient in patients) {
        _bloodTypeStats[patient.bloodType] =
            (_bloodTypeStats[patient.bloodType] ?? 0) + 1;
      }
    } catch (e) {
      print('Error loading statistics: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Statistik Pasien'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadStatistics,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Summary Cards with Gradient
                  Row(
                    children: [
                      Expanded(
                        child: _buildGradientStatCard(
                          'Total Pasien',
                          _totalPatients.toString(),
                          Icons.people_rounded,
                          [Colors.blue.shade400, Colors.blue.shade700],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildGradientStatCard(
                          'Dengan Alergi',
                          _patientsWithAllergies.toString(),
                          Icons.warning_rounded,
                          [Colors.orange.shade400, Colors.orange.shade700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Blood Type Distribution with Legend
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          Colors.red.shade50.withOpacity(0.3)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.red.shade400,
                                    Colors.red.shade700
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.pie_chart_rounded,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Distribusi Golongan Darah',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Persentase berdasarkan total pasien',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        if (_bloodTypeStats.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 60),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.analytics_outlined,
                                      size: 72,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Belum ada data pasien',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Data akan muncul setelah pasien ditambahkan',
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          SizedBox(
                            height: 280,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Pie Chart
                                Expanded(
                                  child: Center(
                                    child: SizedBox(
                                      height: 240,
                                      width: 240,
                                      child: PieChart(
                                        PieChartData(
                                          sections: _bloodTypeStats.entries
                                              .map((entry) {
                                            final colors =
                                                _getBloodTypeColors();
                                            final index = _bloodTypeStats.keys
                                                .toList()
                                                .indexOf(entry.key);
                                            final percentage =
                                                (_totalPatients > 0)
                                                    ? (entry.value /
                                                            _totalPatients *
                                                            100)
                                                        .toStringAsFixed(0)
                                                    : '0';

                                            return PieChartSectionData(
                                              value: entry.value.toDouble(),
                                              title:
                                                  '${entry.key}\n$percentage%',
                                              gradient: LinearGradient(
                                                colors: colors[
                                                    index % colors.length],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                              radius: 90,
                                              titleStyle: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                shadows: [
                                                  Shadow(
                                                    color: Colors.black38,
                                                    blurRadius: 3,
                                                    offset: Offset(1, 1),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }).toList(),
                                          sectionsSpace: 4,
                                          centerSpaceRadius: 50,
                                          centerSpaceColor: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(height: 20),
                        // Legend Below Chart
                        if (_bloodTypeStats.isNotEmpty)
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            alignment: WrapAlignment.center,
                            children: _bloodTypeStats.entries.map((entry) {
                              final colors = _getBloodTypeColors();
                              final index = _bloodTypeStats.keys
                                  .toList()
                                  .indexOf(entry.key);
                              final percentage = (_totalPatients > 0)
                                  ? (entry.value / _totalPatients * 100)
                                      .toStringAsFixed(1)
                                  : '0.0';

                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: colors[index % colors.length][0]
                                        .withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: colors[index % colors.length][0]
                                          .withOpacity(0.15),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 14,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: colors[index % colors.length],
                                        ),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${entry.key}: ${entry.value} ($percentage%)',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Blood Type Detail List (keeping the beautiful cards from before)
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.indigo.shade400,
                                    Colors.indigo.shade600
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.list_alt_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Detail Golongan Darah',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        if (_bloodTypeStats.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.inbox_outlined,
                                    size: 64,
                                    color: Colors.grey.shade300,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Belum ada data pasien',
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ..._bloodTypeStats.entries.map((entry) {
                            final percentage = (_totalPatients > 0)
                                ? (entry.value / _totalPatients * 100)
                                    .toStringAsFixed(1)
                                : '0.0';

                            final colors = _getDetailBloodTypeColors();
                            final index = _bloodTypeStats.keys
                                .toList()
                                .indexOf(entry.key);

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: colors[index % colors.length][1],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: colors[index % colors.length][0]
                                      .withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 60,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          colors[index % colors.length][0],
                                          colors[index % colors.length][0]
                                              .withOpacity(0.8),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: colors[index % colors.length]
                                                  [0]
                                              .withOpacity(0.3),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      entry.key,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${entry.value} pasien',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: colors[index %
                                                        colors.length][0]
                                                    .withOpacity(0.15),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                '$percentage%',
                                                style: TextStyle(
                                                  color: colors[
                                                      index % colors.length][0],
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: LinearProgressIndicator(
                                            value: entry.value / _totalPatients,
                                            minHeight: 8,
                                            backgroundColor:
                                                Colors.grey.shade200,
                                            valueColor: AlwaysStoppedAnimation(
                                              colors[index % colors.length][0],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  List<List<Color>> _getBloodTypeColors() {
    return [
      [Colors.red.shade500, Colors.red.shade700],
      [Colors.blue.shade500, Colors.blue.shade700],
      [Colors.green.shade500, Colors.green.shade700],
      [Colors.orange.shade500, Colors.orange.shade700],
      [Colors.purple.shade500, Colors.purple.shade700],
      [Colors.pink.shade500, Colors.pink.shade700],
      [Colors.teal.shade500, Colors.teal.shade700],
      [Colors.amber.shade600, Colors.amber.shade800],
    ];
  }

  List<List<Color>> _getDetailBloodTypeColors() {
    return [
      [Colors.red.shade400, Colors.red.shade50],
      [Colors.blue.shade400, Colors.blue.shade50],
      [Colors.green.shade400, Colors.green.shade50],
      [Colors.orange.shade400, Colors.orange.shade50],
      [Colors.purple.shade400, Colors.purple.shade50],
      [Colors.pink.shade400, Colors.pink.shade50],
      [Colors.teal.shade400, Colors.teal.shade50],
      [Colors.amber.shade400, Colors.amber.shade50],
    ];
  }

  Widget _buildGradientStatCard(
    String title,
    String value,
    IconData icon,
    List<Color> gradientColors,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors[1].withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Colors.white),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
