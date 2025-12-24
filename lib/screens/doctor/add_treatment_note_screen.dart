import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/patient_profile.dart';
import '../../models/treatment_note.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../utils/error_handler.dart';

class AddTreatmentNoteScreen extends StatefulWidget {
  final PatientProfile patient;

  const AddTreatmentNoteScreen({
    super.key,
    required this.patient,
  });

  @override
  State<AddTreatmentNoteScreen> createState() => _AddTreatmentNoteScreenState();
}

class _AddTreatmentNoteScreenState extends State<AddTreatmentNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _diagnosisController = TextEditingController();
  final _treatmentController = TextEditingController();
  final _followUpController = TextEditingController();

  final FirestoreService _firestoreService = FirestoreService();
  bool _isLoading = false;
  DateTime? _nextAppointment;

  @override
  void dispose() {
    _diagnosisController.dispose();
    _treatmentController.dispose();
    _followUpController.dispose();
    super.dispose();
  }

  Future<void> _selectAppointmentDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() => _nextAppointment = date);
    }
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final doctor = authProvider.currentUser!;

      final note = TreatmentNote(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        patientId: widget.patient.userId,
        patientName: widget.patient.name,
        doctorId: doctor.uid,
        doctorName: doctor.name,
        date: DateTime.now(),
        diagnosis: _diagnosisController.text.trim(),
        treatment: _treatmentController.text.trim(),
        followUpInstructions: _followUpController.text.trim(),
        nextAppointment: _nextAppointment,
      );

      await _firestoreService.addTreatmentNote(note);

      if (mounted) {
        ErrorHandler.showSuccessSnackBar(
          context,
          'Catatan treatment berhasil ditambahkan',
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ErrorHandler.showErrorSnackBar(
          context,
          'Gagal menambahkan catatan: $e',
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
        title: const Text('Tambah Catatan Treatment'),
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
                'Detail Treatment',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Diagnosis
              TextFormField(
                controller: _diagnosisController,
                decoration: InputDecoration(
                  labelText: 'Diagnosis *',
                  hintText: 'Contoh: Demam tifoid',
                  prefixIcon: const Icon(Icons.medical_information),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Diagnosis harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Treatment
              TextFormField(
                controller: _treatmentController,
                decoration: InputDecoration(
                  labelText: 'Perawatan/Tindakan *',
                  hintText: 'Jelaskan tindakan yang diberikan',
                  prefixIcon: const Icon(Icons.healing),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Perawatan harus diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Follow-up Instructions
              TextFormField(
                controller: _followUpController,
                decoration: InputDecoration(
                  labelText: 'Instruksi Follow-up',
                  hintText: 'Instruksi untuk kontrol selanjutnya',
                  prefixIcon: const Icon(Icons.assignment),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Next Appointment
              Card(
                child: ListTile(
                  leading: Icon(
                    Icons.event,
                    color: Colors.teal.shade700,
                  ),
                  title: const Text('Jadwal Kontrol Berikutnya'),
                  subtitle: Text(
                    _nextAppointment != null
                        ? '${_nextAppointment!.day}/${_nextAppointment!.month}/${_nextAppointment!.year}'
                        : 'Tidak ada jadwal',
                    style: TextStyle(
                      color: _nextAppointment != null
                          ? Colors.teal.shade700
                          : Colors.grey.shade600,
                      fontWeight: _nextAppointment != null
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: _nextAppointment != null
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() => _nextAppointment = null);
                          },
                        )
                      : null,
                  onTap: _selectAppointmentDate,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
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
                        'Catatan ini akan tersimpan dalam rekam medis pasien',
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
                  onPressed: _isLoading ? null : _saveNote,
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
                    _isLoading ? 'Menyimpan...' : 'Simpan Catatan',
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
