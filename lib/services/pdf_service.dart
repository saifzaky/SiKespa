import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/patient_profile.dart';
import '../models/medical_record.dart';
import 'package:intl/intl.dart';

class PdfService {
  /// Export medical records to PDF
  Future<void> exportMedicalRecordsPdf({
    required List<MedicalRecord> records,
    required PatientProfile profile,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          // Header
          pw.Header(
            level: 0,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'REKAM MEDIS PASIEN',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Divider(thickness: 2),
              ],
            ),
          ),

          // Patient Info
          pw.SizedBox(height: 20),
          pw.Text(
            'Informasi Pasien',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          _buildInfoRow('Nama', profile.name),
          _buildInfoRow('Umur', '${profile.age} tahun'),
          _buildInfoRow('Golongan Darah', profile.bloodType),
          if (profile.allergies.isNotEmpty)
            _buildInfoRow('Alergi', profile.allergies.join(', ')),
          if (profile.emergencyContact.isNotEmpty)
            _buildInfoRow('Kontak Darurat', profile.emergencyContact),

          pw.SizedBox(height: 30),

          // Medical Records
          pw.Text(
            'Riwayat Rekam Medis (${records.length} record)',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 15),

          // Records List
          ...records.map((record) => _buildMedicalRecordSection(record)),
        ],
      ),
    );

    // Show print dialog
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  /// Export patient profile to PDF
  Future<void> exportPatientProfilePdf({
    required PatientProfile profile,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header
            pw.Text(
              'PROFIL PASIEN',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Divider(thickness: 2),
            pw.SizedBox(height: 30),

            // Profile Details
            _buildInfoRow('Nama Lengkap', profile.name),
            _buildInfoRow('Umur', '${profile.age} tahun'),
            _buildInfoRow('Jenis Kelamin', profile.gender ?? '-'),
            _buildInfoRow('Golongan Darah', profile.bloodType),

            pw.SizedBox(height: 20),
            pw.Text(
              'Informasi Medis',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 10),

            if (profile.allergies.isNotEmpty)
              _buildInfoRow('Alergi', profile.allergies.join(', '))
            else
              _buildInfoRow('Alergi', 'Tidak ada'),

            pw.SizedBox(height: 20),
            pw.Text(
              'Kontak',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 10),

            _buildInfoRow('Kontak Darurat', profile.emergencyContact),
            if (profile.insuranceNumber.isNotEmpty)
              _buildInfoRow('No. Asuransi', profile.insuranceNumber),

            pw.Spacer(),

            // Footer
            pw.Divider(),
            pw.SizedBox(height: 10),
            pw.Text(
              'Dicetak pada: ${DateFormat('dd MMMM yyyy, HH:mm').format(DateTime.now())}',
              style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
            ),
          ],
        ),
      ),
    );

    // Show print dialog
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 150,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.Text(': '),
          pw.Expanded(
            child: pw.Text(value),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildMedicalRecordSection(MedicalRecord record) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 20),
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                DateFormat('dd MMMM yyyy').format(record.date),
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              if (record.hospitalName.isNotEmpty)
                pw.Text(
                  record.hospitalName,
                  style:
                      const pw.TextStyle(fontSize: 10, color: PdfColors.grey),
                ),
            ],
          ),
          pw.SizedBox(height: 10),
          _buildInfoRow('Diagnosis', record.diagnosis),
          if (record.labResults.isNotEmpty)
            _buildInfoRow('Hasil Lab', record.labResults),
          if (record.prescription.isNotEmpty)
            _buildInfoRow('Resep', record.prescription),
          if (record.doctorName.isNotEmpty)
            _buildInfoRow('Dokter', record.doctorName),
        ],
      ),
    );
  }
}
