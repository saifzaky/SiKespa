import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../providers/auth_provider.dart';
import '../../providers/patient_provider.dart';
import '../../services/storage_service.dart';
import '../../models/patient_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final StorageService _storageService = StorageService();
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _bloodTypeController;
  late TextEditingController _allergiesController;
  late TextEditingController _emergencyContactController;
  late TextEditingController _insuranceNumberController;

  bool _isEditing = false;
  bool _isLoading = false;
  String? _newPhotoUrl;

  @override
  void initState() {
    super.initState();
    final patientProvider = context.read<PatientProvider>();
    final profile = patientProvider.currentProfile;

    _nameController = TextEditingController(text: profile?.name ?? '');
    _ageController = TextEditingController(text: profile?.age.toString() ?? '');
    _bloodTypeController =
        TextEditingController(text: profile?.bloodType ?? '');
    _allergiesController = TextEditingController(
      text: profile?.allergies.join(', ') ?? '',
    );
    _emergencyContactController = TextEditingController(
      text: profile?.emergencyContact ?? '',
    );
    _insuranceNumberController = TextEditingController(
      text: profile?.insuranceNumber ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _bloodTypeController.dispose();
    _allergiesController.dispose();
    _emergencyContactController.dispose();
    _insuranceNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() => _isLoading = true);

    final authProvider = context.read<AuthProvider>();
    final photoUrl = await _storageService.uploadProfilePhoto(
      authProvider.currentUser!.uid,
      File(image.path),
    );

    if (photoUrl != null) {
      setState(() {
        _newPhotoUrl = photoUrl;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal upload foto')),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authProvider = context.read<AuthProvider>();
    final patientProvider = context.read<PatientProvider>();
    final currentProfile = patientProvider.currentProfile;

    final profile = PatientProfile(
      id: currentProfile?.id ?? authProvider.currentUser!.uid,
      userId: authProvider.currentUser!.uid,
      name: _nameController.text.trim(),
      age: int.tryParse(_ageController.text.trim()) ?? 0,
      bloodType: _bloodTypeController.text.trim(),
      allergies: _allergiesController.text
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList(),
      emergencyContact: _emergencyContactController.text.trim(),
      insuranceNumber: _insuranceNumberController.text.trim(),
      photoUrl: _newPhotoUrl ?? currentProfile?.photoUrl,
    );

    await patientProvider.updateProfile(profile);

    setState(() {
      _isLoading = false;
      _isEditing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final patientProvider = context.watch<PatientProvider>();
    final profile = patientProvider.currentProfile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pasien'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Photo Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue.shade700, Colors.blue.shade500],
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        backgroundImage: (_newPhotoUrl ?? profile?.photoUrl) !=
                                null
                            ? NetworkImage(_newPhotoUrl ?? profile!.photoUrl!)
                            : null,
                        child: (_newPhotoUrl ?? profile?.photoUrl) == null
                            ? Icon(Icons.person,
                                size: 60, color: Colors.blue.shade700)
                            : null,
                      ),
                      if (_isEditing)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: Colors.blue.shade700,
                            radius: 20,
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt, size: 20),
                              color: Colors.white,
                              onPressed: _isLoading ? null : _pickImage,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    profile?.name ?? 'Nama Belum Diisi',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Profile Form
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoCard(),
                    const SizedBox(height: 16),
                    _buildMedicalInfoCard(),
                    const SizedBox(height: 16),
                    _buildEmergencyContactCard(),
                    if (_isEditing) ...[
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      setState(() => _isEditing = false);
                                    },
                              child: const Text('Batal'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _saveProfile,
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
                                  : const Text('Simpan'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informasi Pribadi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            _buildTextField(
              controller: _nameController,
              label: 'Nama Lengkap',
              icon: Icons.person,
              enabled: _isEditing,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _ageController,
              label: 'Umur',
              icon: Icons.cake,
              keyboardType: TextInputType.number,
              enabled: _isEditing,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informasi Medis',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            _buildTextField(
              controller: _bloodTypeController,
              label: 'Golongan Darah',
              icon: Icons.bloodtype,
              enabled: _isEditing,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _allergiesController,
              label: 'Riwayat Alergi (pisahkan dengan koma)',
              icon: Icons.warning,
              maxLines: 2,
              enabled: _isEditing,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _insuranceNumberController,
              label: 'Nomor Asuransi Kesehatan',
              icon: Icons.card_membership,
              enabled: _isEditing,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyContactCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Kontak Darurat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            _buildTextField(
              controller: _emergencyContactController,
              label: 'Nomor Telepon',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              enabled: _isEditing,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    required bool enabled,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        return null;
      },
    );
  }
}
