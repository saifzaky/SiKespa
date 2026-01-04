import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/medical_record.dart';
import '../../models/patient_profile.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../utils/validator.dart';
import '../../utils/error_handler.dart';

class AddMedicalRecordScreen extends StatefulWidget {
  final PatientProfile patient;

  const AddMedicalRecordScreen({
    super.key,
    required this.patient,
  });

  @override
  State<AddMedicalRecordScreen> createState() => _AddMedicalRecordScreenState();
}

class _AddMedicalRecordScreenState extends State<AddMedicalRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _diagnosisController = TextEditingController();
  final _labResultsController = TextEditingController();
  final _prescriptionController = TextEditingController();
  final _hospitalNameController = TextEditingController();

  final firestoreService = FirestoreService();
  bool _isLoading = false;

  @override
  void dispose() {
    _diagnosisController.dispose();
    _labResultsController.dispose();
    _prescriptionController.dispose();
    _hospitalNameController.dispose();
    super.dispose();
  }

  Future<void> _saveMedicalRecord() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final doctor = authProvider.currentUser!;

      final record = MedicalRecord(
        id: '', // Will be set by Firestore
        patientId: widget.patient.userId,
        date: DateTime.now(),
        diagnosis: _diagnosisController.text.trim(),
        labResults: _labResultsController.text.trim(),
        prescription: _prescriptionController.text.trim(),
        doctorName: doctor.name,
        hospitalName: _hospitalNameController.text.trim(),
        documents: [], // File upload can be added later
      );

      await firestoreService.addMedicalRecord(record);

      if (!mounted) return;

      ErrorHandler.showSuccessSnackBar(
        context,
        'Rekam medis berhasil ditambahkan',
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ErrorHandler.showErrorSnackBar(
        context,
        'Gagal menambahkan rekam medis: $e',
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
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Patient Info Card
            Card(
              color: Colors.teal.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person, color: Colors.teal.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Pasien',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.patient.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${widget.patient.age} tahun • ${widget.patient.gender} • ${widget.patient.bloodType}',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                    if (widget.patient.allergies.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.warning_amber,
                              size: 16, color: Colors.orange.shade700),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Alergi: ${widget.patient.allergies.join(", ")}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Form Title
            const Text(
              'Detail Rekam Medis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Diagnosis
            TextFormField(
              controller: _diagnosisController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Diagnosis *',
                hintText: 'Contoh: Demam tifoid, ISPA, dll',
                prefixIcon: const Icon(Icons.medical_information),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                helperText: 'Diagnosis utama penyakit pasien',
              ),
              validator: (value) => Validator.required(value, 'Diagnosis'),
            ),
            const SizedBox(height: 16),

            // Lab Results
            TextFormField(
              controller: _labResultsController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Hasil Laboratorium',
                hintText: 'Hasil pemeriksaan lab, tes darah, dll',
                prefixIcon: const Icon(Icons.science),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),

            // Prescription
            TextFormField(
              controller: _prescriptionController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Resep Obat *',
                hintText: 'Daftar obat yang diresepkan',
                prefixIcon: const Icon(Icons.medication),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                alignLabelWithHint: true,
              ),
              validator: (value) => Validator.required(value, 'Resep obat'),
            ),
            const SizedBox(height: 16),

            // Hospital Name
            TextFormField(
              controller: _hospitalNameController,
              decoration: InputDecoration(
                labelText: 'Nama Rumah Sakit/Klinik *',
                hintText: 'Contoh: RS Fatmawati',
                prefixIcon: const Icon(Icons.local_hospital),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) =>
                  Validator.required(value, 'Nama rumah sakit'),
            ),
            const SizedBox(height: 24),

            // Info Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Rekam medis akan tersimpan dan dapat diakses oleh pasien',
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Save Button
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _saveMedicalRecord,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.save),
                label: Text(
                  _isLoading ? 'Menyimpan...' : 'Simpan Rekam Medis',
                  style: const TextStyle(
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
