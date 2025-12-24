import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/patient_provider.dart';
import '../../services/firestore_service.dart';
import '../../models/schedule.dart';
import '../../widgets/vital_sign_card.dart';
import './profile_screen.dart';
import './medical_records_screen.dart';
import './treatment_history_screen.dart';
import './schedule_screen.dart';
import './vital_signs_history_screen.dart';
import './add_vital_signs_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final authProvider = context.read<AuthProvider>();
    final patientProvider = context.read<PatientProvider>();

    if (authProvider.currentUser != null) {
      await patientProvider.loadPatientData(authProvider.currentUser!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final patientProvider = context.watch<PatientProvider>();
    final profile = patientProvider.currentProfile;
    final vitalSigns = patientProvider.latestVitalSigns;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Dashboard'),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade400,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.lightBlue.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person, size: 14, color: Colors.white),
                  SizedBox(width: 6),
                  Text(
                    'PATIENT',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Profile
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue.shade700, Colors.blue.shade500],
                  ),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          backgroundImage: profile?.photoUrl != null
                              ? NetworkImage(profile!.photoUrl!)
                              : null,
                          child: profile?.photoUrl == null
                              ? Icon(Icons.person,
                                  size: 40, color: Colors.blue.shade700)
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile?.name ??
                                    authProvider.currentUser?.name ??
                                    'Pasien',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                authProvider.currentUser?.email ?? '',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Health Status
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: vitalSigns?.isNormal == true
                            ? Colors.green.shade400
                            : Colors.orange.shade400,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            vitalSigns?.isNormal == true
                                ? Icons.check_circle
                                : Icons.warning,
                            color: Colors.white,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Status Kesehatan',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  vitalSigns?.statusText ?? 'Belum ada data',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Quick Stats
              if (vitalSigns != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Data Vital Terkini',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: VitalSignCard(
                              icon: Icons.favorite,
                              label: 'Tekanan Darah',
                              value: vitalSigns.bloodPressure,
                              color: Colors.red.shade400,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: VitalSignCard(
                              icon: Icons.bloodtype,
                              label: 'Gula Darah',
                              value:
                                  '${vitalSigns.bloodSugar.toStringAsFixed(0)} mg/dL',
                              color: Colors.orange.shade400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: VitalSignCard(
                              icon: Icons.monitor_weight,
                              label: 'Berat Badan',
                              value:
                                  '${vitalSigns.weight.toStringAsFixed(1)} kg',
                              color: Colors.blue.shade400,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(child: SizedBox()),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // View All Button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const VitalSignsHistoryScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.show_chart),
                          label: const Text('Lihat Riwayat \u0026 Grafik'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(12),
                            side: BorderSide(color: Colors.blue.shade700),
                            foregroundColor: Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Upcoming Schedules
              StreamBuilder<List<Schedule>>(
                stream: _firestoreService
                    .streamSchedules(authProvider.currentUser!.uid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox();

                  final upcomingSchedules = snapshot.data!
                      .where((s) => s.isUpcoming)
                      .take(3)
                      .toList();

                  if (upcomingSchedules.isEmpty) return const SizedBox();

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Jadwal Mendatang',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ScheduleScreen(),
                                  ),
                                );
                              },
                              child: const Text('Lihat Semua'),
                            ),
                          ],
                        ),
                        ...upcomingSchedules.map((schedule) => Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      schedule.type == 'consultation'
                                          ? Colors.blue.shade100
                                          : Colors.green.shade100,
                                  child: Icon(
                                    schedule.type == 'consultation'
                                        ? Icons.local_hospital
                                        : Icons.medication,
                                    color: schedule.type == 'consultation'
                                        ? Colors.blue.shade700
                                        : Colors.green.shade700,
                                  ),
                                ),
                                title: Text(schedule.title),
                                subtitle: Text(
                                  '${schedule.date.day}/${schedule.date.month}/${schedule.date.year} - ${schedule.time}',
                                ),
                                trailing: schedule.reminderEnabled
                                    ? const Icon(Icons.notifications_active,
                                        size: 20)
                                    : null,
                              ),
                            )),
                      ],
                    ),
                  );
                },
              ),

              // Quick Actions
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Menu Utama',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        // Responsive column count
                        final isWideScreen = constraints.maxWidth > 600;
                        final crossAxisCount = isWideScreen ? 4 : 2;

                        return GridView.count(
                          crossAxisCount: crossAxisCount,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: isWideScreen ? 1.1 : 1.0,
                          children: [
                            _buildMenuCard(
                              context,
                              'Profil',
                              Icons.person,
                              Colors.blue,
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfileScreen(),
                                ),
                              ),
                            ),
                            _buildMenuCard(
                              context,
                              'Rekam Medis',
                              Icons.medical_services,
                              Colors.red,
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const MedicalRecordsScreen(),
                                ),
                              ),
                            ),
                            _buildMenuCard(
                              context,
                              'Riwayat',
                              Icons.history,
                              Colors.orange,
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const TreatmentHistoryScreen(),
                                ),
                              ),
                            ),
                            _buildMenuCard(
                              context,
                              'Jadwal',
                              Icons.calendar_today,
                              Colors.green,
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ScheduleScreen(),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
