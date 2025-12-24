import 'package:flutter/material.dart';
import '../../models/patient_profile.dart';
import '../../models/vital_signs.dart';
import '../../models/medical_record.dart';
import '../../models/prescription.dart';
import '../../services/firestore_service.dart';
import 'package:intl/intl.dart';
import 'add_prescription_screen.dart';
import 'add_treatment_note_screen.dart';

class DoctorPatientDetailScreen extends StatefulWidget {
  final PatientProfile patient;

  const DoctorPatientDetailScreen({
    super.key,
    required this.patient,
  });

  @override
  State<DoctorPatientDetailScreen> createState() =>
      _DoctorPatientDetailScreenState();
}

class _DoctorPatientDetailScreenState extends State<DoctorPatientDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(widget.patient.name),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.person), text: 'Overview'),
            Tab(icon: Icon(Icons.show_chart), text: 'Vital Signs'),
            Tab(icon: Icon(Icons.folder), text: 'Records'),
            Tab(icon: Icon(Icons.medication), text: 'Prescriptions'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildVitalSignsTab(),
          _buildRecordsTab(),
          _buildPrescriptionsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showQuickActions(context);
        },
        backgroundColor: Colors.teal.shade700,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.medication, color: Colors.teal.shade700),
              ),
              title: const Text(
                'Tambah Resep',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Berikan resep obat untuk pasien'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPrescriptionScreen(
                      patient: widget.patient,
                    ),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.note_alt, color: Colors.blue.shade700),
              ),
              title: const Text(
                'Tambah Catatan Treatment',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Catat diagnosis dan perawatan'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTreatmentNoteScreen(
                      patient: widget.patient,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ===== OVERVIEW TAB =====
  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Patient Info Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Pasien',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  _buildInfoRow('Umur', '${widget.patient.age} tahun'),
                  _buildInfoRow('Jenis Kelamin', widget.patient.gender),
                  _buildInfoRow('Golongan Darah', widget.patient.bloodType),
                  _buildInfoRow(
                    'Kontak Darurat',
                    widget.patient.emergencyContact,
                  ),
                  if (widget.patient.insuranceNumber.isNotEmpty)
                    _buildInfoRow(
                      'No. Asuransi',
                      widget.patient.insuranceNumber,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Allergies Card
          if (widget.patient.allergies.isNotEmpty)
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning, color: Colors.red.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Alergi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: widget.patient.allergies
                          .map((allergy) => Chip(
                                label: Text(allergy),
                                backgroundColor: Colors.red.shade100,
                                labelStyle: TextStyle(
                                  color: Colors.red.shade900,
                                  fontWeight: FontWeight.w600,
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),

          // Latest Vital Signs
          StreamBuilder<VitalSigns?>(
            stream: _firestoreService
                .streamVitalSigns(widget.patient.userId)
                .map((list) => list.isNotEmpty ? list.first : null),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              }

              final vs = snapshot.data!;
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Vital Signs Terakhir',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: vs.isNormal
                                  ? Colors.green.shade100
                                  : Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              vs.statusText,
                              style: TextStyle(
                                color: vs.isNormal
                                    ? Colors.green.shade900
                                    : Colors.orange.shade900,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        DateFormat('dd MMM yyyy, HH:mm').format(vs.date),
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      const Divider(),
                      Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        children: [
                          _buildVitalChip(
                              'BP', vs.bloodPressure, Icons.favorite),
                          _buildVitalChip(
                              'HR', '${vs.heartRate} bpm', Icons.monitor_heart),
                          _buildVitalChip(
                              'Temp', '${vs.temperature}°C', Icons.thermostat),
                          _buildVitalChip('Weight', '${vs.weight} kg',
                              Icons.monitor_weight),
                          _buildVitalChip('Sugar', '${vs.bloodSugar} mg/dL',
                              Icons.bloodtype),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalChip(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.blue.shade700),
          const SizedBox(width: 6),
          Text(
            '$label: $value',
            style: TextStyle(
              fontSize: 12,
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ===== VITAL SIGNS TAB =====
  Widget _buildVitalSignsTab() {
    return StreamBuilder<List<VitalSigns>>(
      stream: _firestoreService.streamVitalSigns(widget.patient.userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.show_chart, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'Belum ada vital signs',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }

        final vitalSigns = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: vitalSigns.length,
          itemBuilder: (context, index) {
            final vs = vitalSigns[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
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
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('dd MMM yyyy, HH:mm').format(vs.date),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
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
                        _buildVitalChip('BP', vs.bloodPressure, Icons.favorite),
                        _buildVitalChip(
                            'HR', '${vs.heartRate} bpm', Icons.favorite),
                        _buildVitalChip(
                            'Temp', '${vs.temperature}°C', Icons.thermostat),
                        _buildVitalChip(
                            'Weight', '${vs.weight} kg', Icons.monitor_weight),
                        _buildVitalChip(
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
                            Icon(Icons.note,
                                size: 16, color: Colors.grey.shade600),
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
          },
        );
      },
    );
  }

  // ===== RECORDS TAB =====
  Widget _buildRecordsTab() {
    return StreamBuilder<List<MedicalRecord>>(
      stream: _firestoreService.streamMedicalRecords(widget.patient.userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.folder_open, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'Belum ada medical records',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }

        final records = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: records.length,
          itemBuilder: (context, index) {
            final record = records[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.folder, color: Colors.blue.shade700),
                ),
                title: Text(
                  record.diagnosis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd MMM yyyy').format(record.date),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (record.labResults.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        record.labResults,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ],
                ),
                trailing: Icon(
                  Icons.folder,
                  color: Colors.blue.shade700,
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ===== PRESCRIPTIONS TAB =====
  Widget _buildPrescriptionsTab() {
    return StreamBuilder<List<Prescription>>(
      stream:
          _firestoreService.streamPatientPrescriptions(widget.patient.userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.medication, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'Belum ada prescription',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          );
        }

        final prescriptions = snapshot.data!;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: prescriptions.length,
          itemBuilder: (context, index) {
            final prescription = prescriptions[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            prescription.medicationName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                prescription.isActive && !prescription.isExpired
                                    ? Colors.green.shade100
                                    : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            prescription.statusText,
                            style: TextStyle(
                              fontSize: 12,
                              color: prescription.isActive &&
                                      !prescription.isExpired
                                  ? Colors.green.shade900
                                  : Colors.grey.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${prescription.dosage} - ${prescription.frequency}',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Durasi: ${prescription.durationDays} hari',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (prescription.instructions.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          prescription.instructions,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('dd MMM yyyy')
                              .format(prescription.prescribedDate),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Oleh: ${prescription.doctorName}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
