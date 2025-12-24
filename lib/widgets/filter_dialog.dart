import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  final String? initialBloodType;
  final String? initialGender;
  final int? minAge;
  final int? maxAge;

  const FilterDialog({
    super.key,
    this.initialBloodType,
    this.initialGender,
    this.minAge,
    this.maxAge,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String? _bloodType;
  String? _gender;
  int? _minAge;
  int? _maxAge;

  @override
  void initState() {
    super.initState();
    _bloodType = widget.initialBloodType;
    _gender = widget.initialGender;
    _minAge = widget.minAge;
    _maxAge = widget.maxAge;
  }

  void _clearFilters() {
    setState(() {
      _bloodType = null;
      _gender = null;
      _minAge = null;
      _maxAge = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Pasien'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Blood Type
            const Text(
              'Golongan Darah',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-']
                  .map((type) => FilterChip(
                        label: Text(type),
                        selected: _bloodType == type,
                        onSelected: (selected) {
                          setState(() => _bloodType = selected ? type : null);
                        },
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),

            // Gender
            const Text(
              'Jenis Kelamin',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['Laki-laki', 'Perempuan']
                  .map((gender) => FilterChip(
                        label: Text(gender),
                        selected: _gender == gender,
                        onSelected: (selected) {
                          setState(() => _gender = selected ? gender : null);
                        },
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),

            // Age Range
            const Text(
              'Rentang Usia',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Min',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    controller: TextEditingController(
                      text: _minAge?.toString() ?? '',
                    ),
                    onChanged: (value) {
                      _minAge = int.tryParse(value);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                const Text('-'),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Max',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    controller: TextEditingController(
                      text: _maxAge?.toString() ?? '',
                    ),
                    onChanged: (value) {
                      _maxAge = int.tryParse(value);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _clearFilters,
          child: const Text('Reset'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'bloodType': _bloodType,
              'gender': _gender,
              'minAge': _minAge,
              'maxAge': _maxAge,
            });
          },
          child: const Text('Terapkan'),
        ),
      ],
    );
  }
}
