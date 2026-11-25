import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class EducationFormPage extends StatefulWidget {
  const EducationFormPage({super.key});

  @override
  State<EducationFormPage> createState() => _EducationFormPageState();
}

class _EducationFormPageState extends State<EducationFormPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _institutionController = TextEditingController();
  final TextEditingController _majorController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  String? _educationLevel = "Bachelor's Degree";

  DateTime? _startDate;
  DateTime? _endDate;

  final List<String> _educationLevels = [
    "High School",
    "Diploma",
    "Bachelor's Degree",
    "Master's Degree",
    "Doctoral Degree",
    "Other",
  ];

  // Format tanggal menjadi dd/mm/yyyy
  String _formatDate(DateTime date) {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');

    return "$day/$month/${date.year}";
  }

  // Menampilkan date picker
  Future<void> _selectDate(
    BuildContext context, {
    required bool isStartDate,
  }) async {
    final DateTime minimumDate = isStartDate
        ? DateTime(1950)
        : _startDate ?? DateTime(1950);

    final DateTime initialDate = isStartDate
        ? _startDate ?? DateTime.now()
        : _endDate ?? _startDate ?? DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: minimumDate,
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFD8B779),
              onPrimary: Color(0xFF10100F),
              surface: Color(0xFF1C1B18),
              onSurface: Color(0xFFE8D5AC),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && mounted) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
          _startDateController.text = _formatDate(pickedDate);

          // Reset End Date if it becomes invalid
          if (_endDate != null && _endDate!.isBefore(pickedDate)) {
            _endDate = null;
            _endDateController.clear();
          }
        } else {
          _endDate = pickedDate;
          _endDateController.text = _formatDate(pickedDate);
        }
      });
    }
  }

  // Styling input
  InputDecoration _buildInputDecoration({
    required String labelText,
    String? hintText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      suffixIcon: suffixIcon,
      hintStyle: TextStyle(
        color: const Color(0xFFE8D5AC).withValues(alpha: 0.45),
      ),
      labelStyle: const TextStyle(
        color: Color(0xFFD8B779),
        fontFamily: 'serif',
      ),
      filled: true,
      fillColor: const Color(0xFF171612),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF9C8150)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFD8B779), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFB91C1C)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  // Menampilkan satu item data di dalam dialog
  Widget _buildDialogItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFD8B779),
              fontWeight: FontWeight.bold,
              fontFamily: 'serif',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(color: Color(0xFFE8D5AC), fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Menampilkan confirmation dialog
  void _showConfirmationDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1C1B18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF9C8150)),
          ),
          title: const Text(
            'Education Saved!',
            style: TextStyle(
              color: Color(0xFFD8B779),
              fontFamily: 'serif',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogItem(
                  'Institution Name',
                  _institutionController.text.trim(),
                ),
                _buildDialogItem('Education Level', _educationLevel ?? '-'),
                _buildDialogItem(
                  'Major / Field of Study',
                  _majorController.text.trim(),
                ),
                _buildDialogItem('Start Date', _startDateController.text),
                _buildDialogItem('End Date', _endDateController.text),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFFD8B779),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _institutionController.dispose();
    _majorController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10100F),
      appBar: AppBar(
        title: const Text(
          'Education Form',
          style: TextStyle(
            fontFamily: 'serif',
            fontWeight: FontWeight.bold,
            color: Color(0xFFE8D5AC),
          ),
        ),
        backgroundColor: const Color(0xFF171612),
        foregroundColor: const Color(0xFFD8B779),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.2),
          child: Container(color: const Color(0xFF9C8150), height: 1.2),
        ),
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        'Add Your Education',
                        style: TextStyle(
                          color: Color(0xFFD8B779),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'serif',
                        ),
                      ),
                    ),

                    // Institution Name
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        controller: _institutionController,
                        style: const TextStyle(color: Color(0xFFE8D5AC)),
                        decoration: _buildInputDecoration(
                          labelText: 'Institution Name',
                          hintText: 'Example: University of Indonesia',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Institution name cannot be empty!';
                          }
                          return null;
                        },
                      ),
                    ),

                    // Education Level
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: DropdownButtonFormField<String>(
                        initialValue: _educationLevel,
                        dropdownColor: const Color(0xFF1C1B18),
                        style: const TextStyle(color: Color(0xFFE8D5AC)),
                        iconEnabledColor: const Color(0xFFD8B779),
                        decoration: _buildInputDecoration(
                          labelText: 'Education Level',
                        ),
                        items: _educationLevels.map((level) {
                          return DropdownMenuItem<String>(
                            value: level,
                            child: Text(level),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _educationLevel = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select your education level!';
                          }
                          return null;
                        },
                      ),
                    ),

                    // Major / Field of Study
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        controller: _majorController,
                        style: const TextStyle(color: Color(0xFFE8D5AC)),
                        decoration: _buildInputDecoration(
                          labelText: 'Major / Field of Study',
                          hintText: 'Example: Computer Science',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Major cannot be empty!';
                          }
                          return null;
                        },
                      ),
                    ),

                    // Start Date
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        controller: _startDateController,
                        readOnly: true,
                        style: const TextStyle(color: Color(0xFFE8D5AC)),
                        decoration: _buildInputDecoration(
                          labelText: 'Start Date',
                          hintText: 'Select start date',
                          suffixIcon: const Icon(
                            Icons.calendar_month,
                            color: Color(0xFFD8B779),
                          ),
                        ),
                        onTap: () {
                          _selectDate(context, isStartDate: true);
                        },
                        validator: (value) {
                          if (_startDate == null) {
                            return 'Please select a start date!';
                          }
                          return null;
                        },
                      ),
                    ),

                    // End Date
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextFormField(
                        controller: _endDateController,
                        readOnly: true,
                        style: const TextStyle(color: Color(0xFFE8D5AC)),
                        decoration: _buildInputDecoration(
                          labelText: 'End Date',
                          hintText: 'Select end date',
                          suffixIcon: const Icon(
                            Icons.calendar_month,
                            color: Color(0xFFD8B779),
                          ),
                        ),
                        onTap: () {
                          _selectDate(context, isStartDate: false);
                        },
                        validator: (value) {
                          if (_endDate == null) {
                            return 'Please select an end date!';
                          }

                          if (_startDate != null &&
                              _endDate!.isBefore(_startDate!)) {
                            return 'End date cannot be before start date!';
                          }

                          return null;
                        },
                      ),
                    ),

                    // Save Button
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                              const Color(0xFF183D28),
                            ),
                            foregroundColor: WidgetStateProperty.all(
                              const Color(0xFFE8D5AC),
                            ),
                            side: WidgetStateProperty.all(
                              const BorderSide(
                                color: Color(0xFFD8B779),
                                width: 1.5,
                              ),
                            ),
                            padding: WidgetStateProperty.all(
                              const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 14,
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _showConfirmationDialog();
                            }
                          },
                          child: const Text(
                            'Simpan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
