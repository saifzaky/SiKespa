import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/patient_profile.dart';
import '../../models/prescription.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../utils/error_handler.dart';

class AddPrescriptionScreen extends StatefulWidget {
  final PatientProfile patient;

  const AddPrescriptionScreen({
    super.key,
    required this.patient,
  });

  @override
  State<AddPrescriptionScreen> createState() => _AddPrescriptionScreenState();
}

class _AddPrescriptionScreenState extends State<AddPrescriptionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _medicationController = TextEditingController();
  final _dosageController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _durationController = TextEditingController();
  final _instructionsController = TextEditingController();

  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = false;

  @override
  void dispose() {
    _medicationController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    _durationController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _savePrescription() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final doctor = authProvider.currentUser!;
      final now = DateTime.now();
      final duration = int.parse(_durationController.text.trim());
      final expiryDate = now.add(Duration(days: duration));

      final prescription = Prescription(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        patientId: widget.patient.userId,
        patientName: widget.patient.name,
        doctorId: doctor.uid,
        doctorName: doctor.name,
        medicationName: _medicationController.text.trim(),
        dosage: _dosageController.text.trim(),
        frequency: _frequencyController.text.trim(),
        durationDays: duration,
        instructions: _instructionsController.text.trim(),
        prescribedDate: now,
        expiryDate: expiryDate,
        isActive: true,
      );

      await _firestoreService.addPrescription(prescription);

      if (mounted) {
        ErrorHandler.showSuccessSnackBar(
          context,
          'Resep berhasil ditambahkan',
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showErrorSnackBar(
          context,
          'Gagal menambahkan resep: $e',
        );
      }
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
        title: const Text('Tambah Resep'),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        '${widget.patient.age} tahun • ${widget.patient.gender}',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Form Fields
              const Text(
                'Detail Resep',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Medication Name
              TextFormField(
                controller: _medicationController,
                decoration: InputDecoration(
                  labelText: 'Nama Obat *',
                  hintText: 'Contoh: Paracetamol',
                  prefixIcon: const Icon(Icons.medication),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama obat harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Dosage
              TextFormField(
                controller: _dosageController,
                decoration: InputDecoration(
                  labelText: 'Dosis *',
                  hintText: 'Contoh: 500mg',
                  prefixIcon: const Icon(Icons.science),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Dosis harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Frequency
              TextFormField(
                controller: _frequencyController,
                decoration: InputDecoration(
                  labelText: 'Frekuensi *',
                  hintText: 'Contoh: 3x sehari setelah makan',
                  prefixIcon: const Icon(Icons.schedule),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Frekuensi harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Duration
              TextFormField(
                controller: _durationController,
                decoration: InputDecoration(
                  labelText: 'Durasi (hari) *',
                  hintText: 'Contoh: 7',
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixText: 'hari',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Durasi harus diisi';
                  }
                  final duration = int.tryParse(value);
                  if (duration == null || duration <= 0) {
                    return 'Durasi harus berupa angka positif';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Instructions
              TextFormField(
                controller: _instructionsController,
                decoration: InputDecoration(
                  labelText: 'Instruksi',
                  hintText: 'Catatan tambahan untuk pasien',
                  prefixIcon: const Icon(Icons.note_alt),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
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
                        'Resep akan aktif segera setelah disimpan',
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
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _isLoading ? null : _savePrescription,
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
                    _isLoading ? 'Menyimpan...' : 'Simpan Resep',
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
      ),
    );
  }
}
