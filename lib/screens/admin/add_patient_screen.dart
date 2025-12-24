import 'package:flutter/material.dart';
import '../../models/patient_profile.dart';
import '../../services/firestore_service.dart';
import '../../utils/validator.dart';
import '../../utils/app_constants.dart';
import '../../utils/error_handler.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({super.key});

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _insuranceNumberController = TextEditingController();

  String _selectedBloodType = 'A+';
  String _selectedGender = 'Laki-laki';
  final List<String> _selectedAllergies = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _emergencyContactController.dispose();
    _insuranceNumberController.dispose();
    super.dispose();
  }

  Future<void> _savePatient() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Create patient profile
      final profile = PatientProfile(
        id: '', // Will be set by Firestore
        userId:
            _emailController.text.trim(), // Temporary, should be actual user ID
        name: _nameController.text.trim(),
        age: int.parse(_ageController.text),
        gender: _selectedGender,
        bloodType: _selectedBloodType,
        allergies: _selectedAllergies,
        emergencyContact: _emergencyContactController.text.trim(),
        insuranceNumber: _insuranceNumberController.text.trim(),
      );

      final firestoreService = FirestoreService();
      await firestoreService.createOrUpdatePatientProfile(profile);

      if (!mounted) return;

      ErrorHandler.showSuccessSnackBar(
        context,
        'Pasien berhasil ditambahkan',
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ErrorHandler.handleError(
        context,
        e,
        customMessage: 'Gagal menambahkan pasien',
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
        title: const Text('Tambah Pasien Baru'),
        backgroundColor: Colors.blue,
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
                labelText: 'Nama Lengkap',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: Validator.name,
            ),
            const SizedBox(height: 16),

            // Email (temporary for user ID)
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: Validator.email,
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
              decoration: InputDecoration(
                labelText: 'Alergi (pisahkan dengan koma)',
                prefixIcon: const Icon(Icons.warning),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                helperText: 'Contoh: Penicillin, Kacang, Seafood',
              ),
              onChanged: (value) {
                setState(() {
                  _selectedAllergies.clear();
                  if (value.isNotEmpty) {
                    _selectedAllergies.addAll(
                      value
                          .split(',')
                          .map((e) => e.trim())
                          .where((e) => e.isNotEmpty),
                    );
                  }
                });
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
                onPressed: _isLoading ? null : _savePatient,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
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
                        'Simpan Pasien',
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
