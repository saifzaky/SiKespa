import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../../models/vital_signs.dart';
import '../../utils/validator.dart';
import '../../utils/error_handler.dart';

class AddVitalSignsScreen extends StatefulWidget {
  const AddVitalSignsScreen({super.key});

  @override
  State<AddVitalSignsScreen> createState() => _AddVitalSignsScreenState();
}

class _AddVitalSignsScreenState extends State<AddVitalSignsScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirestoreService _firestoreService = FirestoreService();

  // Controllers
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _heartRateController = TextEditingController();
  final _temperatureController = TextEditingController();
  final _weightController = TextEditingController();
  final _bloodSugarController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _heartRateController.dispose();
    _temperatureController.dispose();
    _weightController.dispose();
    _bloodSugarController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveVitalSigns() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final userId = authProvider.currentUser!.uid;

      final vitalSigns = VitalSigns(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        patientId: userId,
        date: DateTime.now(),
        bloodPressure:
            '${_systolicController.text}/${_diastolicController.text}',
        heartRate: int.parse(_heartRateController.text),
        temperature: double.parse(_temperatureController.text),
        weight: double.parse(_weightController.text),
        bloodSugar: double.parse(_bloodSugarController.text),
        notes: _notesController.text.trim(),
      );

      await _firestoreService.addVitalSigns(userId, vitalSigns);

      if (!mounted) return;

      // Show warning if vital signs are abnormal
      final warning = Validator.getVitalSignWarning(
        systolic: int.parse(_systolicController.text),
        diastolic: int.parse(_diastolicController.text),
        heartRate: int.parse(_heartRateController.text),
        temperature: double.parse(_temperatureController.text),
      );

      if (warning != null) {
        ErrorHandler.showWarningSnackBar(context, 'Peringatan! $warning');
      } else {
        ErrorHandler.showSuccessSnackBar(
          context,
          'Data vital signs berhasil disimpan',
        );
      }

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ErrorHandler.handleError(
        context,
        e,
        customMessage: 'Gagal menyimpan data vital signs',
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
        title: const Text('Tambah Data Vital Signs'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info Card
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Masukkan data vital signs Anda. Data akan tersimpan dan dapat dilihat riwayatnya.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Blood Pressure Section
              Text(
                'Tekanan Darah',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _systolicController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Sistolik',
                        hintText: '120',
                        suffixText: 'mmHg',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: Validator.systolicBP,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '/',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _diastolicController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Diastolik',
                        hintText: '80',
                        suffixText: 'mmHg',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: Validator.diastolicBP,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Heart Rate
              Text(
                'Detak Jantung',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _heartRateController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Detak Jantung',
                  hintText: '72',
                  suffixText: 'bpm',
                  prefixIcon: const Icon(Icons.favorite),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: Validator.heartRate,
              ),
              const SizedBox(height: 16),

              // Temperature
              Text(
                'Suhu Tubuh',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _temperatureController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Suhu Tubuh',
                  hintText: '36.5',
                  suffixText: '°C',
                  prefixIcon: const Icon(Icons.thermostat),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: Validator.temperature,
              ),
              const SizedBox(height: 16),

              // Weight
              Text(
                'Berat Badan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _weightController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Berat Badan',
                  hintText: '65.5',
                  suffixText: 'kg',
                  prefixIcon: const Icon(Icons.monitor_weight),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: Validator.weight,
              ),
              const SizedBox(height: 16),

              // Blood Sugar
              Text(
                'Gula Darah',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _bloodSugarController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Gula Darah',
                  hintText: '100',
                  suffixText: 'mg/dL',
                  prefixIcon: const Icon(Icons.bloodtype),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: Validator.bloodSugar,
              ),
              const SizedBox(height: 16),

              // Notes
              Text(
                'Catatan (Opsional)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Catatan',
                  hintText: 'Setelah olahraga, kondisi puasa, dll',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveVitalSigns,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                          'Simpan Data',
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
      ),
    );
  }
}
