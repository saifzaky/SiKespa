import 'package:flutter/material.dart';
import '../../models/patient_profile.dart';
import '../../services/firestore_service.dart';
import '../../utils/validator.dart';
import '../../utils/app_constants.dart';
import '../../utils/error_handler.dart';

class EditPatientScreen extends StatefulWidget {
  final PatientProfile patient;

  const EditPatientScreen({
    super.key,
    required this.patient,
  });

  @override
  State<EditPatientScreen> createState() => _EditPatientScreenState();
}

class _EditPatientScreenState extends State<EditPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _emergencyContactController;
  late final TextEditingController _insuranceNumberController;

  late String _selectedBloodType;
  late String _selectedGender;
  late String _allergiesText;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.patient.name);
    _ageController = TextEditingController(text: widget.patient.age.toString());
    _emergencyContactController =
        TextEditingController(text: widget.patient.emergencyContact);
    _insuranceNumberController =
        TextEditingController(text: widget.patient.insuranceNumber);
    _selectedBloodType = widget.patient.bloodType;
    _selectedGender = widget.patient.gender;
    _allergiesText = widget.patient.allergies.join(', ');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emergencyContactController.dispose();
    _insuranceNumberController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final allergies = _allergiesText.isNotEmpty
          ? _allergiesText
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList()
          : <String>[];

      final updatedProfile = PatientProfile(
        id: widget.patient.id,
        userId: widget.patient.userId,
        name: _nameController.text.trim(),
        age: int.parse(_ageController.text),
        gender: _selectedGender,
        bloodType: _selectedBloodType,
        allergies: allergies,
        emergencyContact: _emergencyContactController.text.trim(),
        insuranceNumber: _insuranceNumberController.text.trim(),
        photoUrl: widget.patient.photoUrl,
      );

      final firestoreService = FirestoreService();
      await firestoreService.createOrUpdatePatientProfile(updatedProfile);

      if (!mounted) return;

      ErrorHandler.showSuccessSnackBar(
        context,
        'Data pasien berhasil diperbarui',
      );

      Navigator.pop(context, true); // Return true to indicate success
    } catch (e) {
      if (!mounted) return;
      ErrorHandler.handleError(
        context,
        e,
        customMessage: 'Gagal memperbarui data pasien',
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
        title: const Text('Edit Data Pasien'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Name
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: ' Nama Lengkap',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: Validator.name,
            ),
            const SizedBox(height: 16),

            // Age
            TextFormField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Umur',
                prefixIcon: const Icon(Icons.cake),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: Validator.age,
            ),
            const SizedBox(height: 16),

            // Gender
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: InputDecoration(
                labelText: 'Jenis Kelamin',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Laki-laki',
                  child: Text('Laki-laki'),
                ),
                DropdownMenuItem(
                  value: 'Perempuan',
                  child: Text('Perempuan'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Blood Type
            DropdownButtonFormField<String>(
              value: _selectedBloodType,
              decoration: InputDecoration(
                labelText: 'Golongan Darah',
                prefixIcon: const Icon(Icons.bloodtype),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: AppConstants.bloodTypes
                  .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBloodType = value!;
                });
              },
            ),
            const SizedBox(height: 16),

            // Allergies
            TextFormField(
              initialValue: _allergiesText,
              decoration: InputDecoration(
                labelText: 'Alergi (pisahkan dengan koma)',
                prefixIcon: const Icon(Icons.warning),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                helperText: 'Contoh: Penicillin, Kacang, Seafood',
              ),
              onChanged: (value) {
                _allergiesText = value;
              },
            ),
            const SizedBox(height: 16),

            // Emergency Contact
            TextFormField(
              controller: _emergencyContactController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Kontak Darurat',
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: Validator.phoneNumber,
            ),
            const SizedBox(height: 16),

            // Insurance Number
            TextFormField(
              controller: _insuranceNumberController,
              decoration: InputDecoration(
                labelText: 'Nomor Asuransi',
                prefixIcon: const Icon(Icons.card_membership),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) => Validator.required(value, 'Nomor asuransi'),
            ),
            const SizedBox(height: 32),

            // Save Button
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
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
                        'Simpan Perubahan',
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
