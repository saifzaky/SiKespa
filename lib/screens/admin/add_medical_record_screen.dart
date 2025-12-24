import 'package:flutter/material.dart';
import '../../models/medical_record.dart';
import '../../models/patient_profile.dart';
import '../../services/firestore_service.dart';
import '../../utils/validator.dart';

class AddMedicalRecordScreen extends StatefulWidget {
  final PatientProfile? selectedPatient;

  const AddMedicalRecordScreen({
    super.key,
    this.selectedPatient,
  });

  @override
  State<AddMedicalRecordScreen> createState() => _AddMedicalRecordScreenState();
}

class _AddMedicalRecordScreenState extends State<AddMedicalRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _diagnosisController = TextEditingController();
  final _labResultsController = TextEditingController();
  final _prescriptionController = TextEditingController();
  final _doctorNameController = TextEditingController();
  final _hospitalNameController = TextEditingController();

  PatientProfile? _selectedPatient;
  bool _isLoading = false;
  List<PatientProfile> _patients = [];

  @override
  void initState() {
    super.initState();
    _selectedPatient = widget.selectedPatient;
    _loadPatients();
  }

  @override
  void dispose() {
    _diagnosisController.dispose();
    _labResultsController.dispose();
    _prescriptionController.dispose();
    _doctorNameController.dispose();
    _hospitalNameController.dispose();
    super.dispose();
  }

  Future<void> _loadPatients() async {
    final firestoreService = FirestoreService();
    final patients = await firestoreService.getAllPatients();
    setState(() {
      _patients = patients;
    });
  }

  Future<void> _saveMedicalRecord() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedPatient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih pasien terlebih dahulu'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final record = MedicalRecord(
        id: '', // Will be set by Firestore
        patientId: _selectedPatient!.userId,
        date: DateTime.now(),
        diagnosis: _diagnosisController.text.trim(),
        labResults: _labResultsController.text.trim(),
        prescription: _prescriptionController.text.trim(),
        doctorName: _doctorNameController.text.trim(),
        hospitalName: _hospitalNameController.text.trim(),
        documents: [], // File upload can be added later
      );

      final firestoreService = FirestoreService();
      await firestoreService.addMedicalRecord(record);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Rekam medis berhasil ditambahkan'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menambahkan rekam medis: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Rekam Medis'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Patient Selection
            if (widget.selectedPatient == null)
              DropdownButtonFormField<PatientProfile>(
                value: _selectedPatient,
                decoration: InputDecoration(
                  labelText: 'Pilih Pasien',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _patients.map((patient) {
                  return DropdownMenuItem(
                    value: patient,
                    child: Text('${patient.name} - ${patient.age} tahun'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPatient = value;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Pilih pasien terlebih dahulu';
                  }
                  return null;
                },
              )
            else
              Card(
                color: Colors.blue.shade50,
                child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.blue),
                  title: Text(
                    _selectedPatient!.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${_selectedPatient!.age} tahun • ${_selectedPatient!.bloodType}',
                  ),
                ),
              ),
            const SizedBox(height: 16),

            // Diagnosis
            TextFormField(
              controller: _diagnosisController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Diagnosis',
                prefixIcon: const Icon(Icons.medical_information),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                helperText: 'Diagnosis penyakit pasien',
              ),
              validator: (value) => Validator.required(value, 'Diagnosis'),
            ),
            const SizedBox(height: 16),

            // Lab Results
            TextFormField(
              controller: _labResultsController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Hasil Lab',
                prefixIcon: const Icon(Icons.science),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                helperText: 'Hasil pemeriksaan laboratorium',
              ),
            ),
            const SizedBox(height: 16),

            // Prescription
            TextFormField(
              controller: _prescriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Resep Obat',
                prefixIcon: const Icon(Icons.medication),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                helperText: 'Daftar obat yang diresepkan',
              ),
              validator: (value) => Validator.required(value, 'Resep obat'),
            ),
            const SizedBox(height: 16),

            // Doctor Name
            TextFormField(
              controller: _doctorNameController,
              decoration: InputDecoration(
                labelText: 'Nama Dokter',
                prefixIcon: const Icon(Icons.badge),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: Validator.name,
            ),
            const SizedBox(height: 16),

            // Hospital Name
            TextFormField(
              controller: _hospitalNameController,
              decoration: InputDecoration(
                labelText: 'Nama Rumah Sakit',
                prefixIcon: const Icon(Icons.local_hospital),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) =>
                  Validator.required(value, 'Nama rumah sakit'),
            ),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveMedicalRecord,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Simpan Rekam Medis',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
