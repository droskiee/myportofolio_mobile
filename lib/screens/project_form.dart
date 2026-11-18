import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _projectName = "";
  String _description = "";
  String _category = "Web Development"; // default
  String _technologies = "";
  String _projectLink = "";

  final List<String> _categories = [
    'Web Development',
    'Mobile Development',
    'Machine Learning',
    'Data Science',
    'Other',
  ];

  // Helper styling dekorasi input bertema Grimoire
  InputDecoration _buildInputDecoration({
    required String labelText,
    String? hintText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(
        color: const Color(0xFFE8D5AC).withValues(alpha: 0.45),
      ),
      labelText: labelText,
      labelStyle: const TextStyle(
        color: Color(0xFFD8B779),
        fontFamily: 'serif',
      ),
      filled: true,
      fillColor: const Color(0xFF171612),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Color(0xFF9C8150)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(
          color: Color(0xFFD8B779),
          width: 2.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Color(0xFFB91C1C)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: Color(0xFFEF4444), width: 2.0),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10100F),
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Add Project Form',
            style: TextStyle(
              fontFamily: 'serif',
              fontWeight: FontWeight.bold,
              color: Color(0xFFE8D5AC),
            ),
          ),
        ),
        backgroundColor: const Color(0xFF171612),
        foregroundColor: const Color(0xFFD8B779),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.2),
          child: Container(
            color: const Color(0xFF9C8150),
            height: 1.2,
          ),
        ),
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // === Project Name ===
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: const TextStyle(color: Color(0xFFE8D5AC)),
                      decoration: _buildInputDecoration(
                        hintText: "Nama Proyek",
                        labelText: "Nama Proyek",
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _projectName = value!;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Nama proyek tidak boleh kosong!";
                        }
                        return null;
                      },
                    ),
                  ),

                  // === Description ===
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      maxLines: 5,
                      style: const TextStyle(color: Color(0xFFE8D5AC)),
                      decoration: _buildInputDecoration(
                        hintText: "Deskripsi Proyek",
                        labelText: "Deskripsi Proyek",
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _description = value!;
                        });
                      },
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Deskripsi proyek tidak boleh kosong!";
                        }
                        return null;
                      },
                    ),
                  ),

                  // === Category ===
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButtonFormField<String>(
                      dropdownColor: const Color(0xFF1C1B18),
                      style: const TextStyle(color: Color(0xFFE8D5AC)),
                      iconEnabledColor: const Color(0xFFD8B779),
                      decoration: _buildInputDecoration(
                        labelText: "Kategori Proyek",
                      ),
                      initialValue: _category,
                      items: _categories
                          .map((category) => DropdownMenuItem(
                                value: category,
                                child: Text(category),
                              ))
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _category = newValue!;
                        });
                      },
                    ),
                  ),

                  // === Technologies ===
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: const TextStyle(color: Color(0xFFE8D5AC)),
                      decoration: _buildInputDecoration(
                        hintText: "Contoh: Flutter, Django, Figma",
                        labelText: "Teknologi yang Digunakan",
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _technologies = value!;
                        });
                      },
                    ),
                  ),

                  // === Project Link ===
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      style: const TextStyle(color: Color(0xFFE8D5AC)),
                      decoration: _buildInputDecoration(
                        hintText: "URL Proyek (opsional)",
                        labelText: "Tautan Proyek",
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          _projectLink = value!;
                        });
                      },
                    ),
                  ),

                  // === Tombol Simpan ===
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            const Color(0xFF183D28),
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
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: const Color(0xFF171612),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    side: const BorderSide(
                                      color: Color(0xFFD8B779),
                                      width: 1.5,
                                    ),
                                  ),
                                  title: const Text(
                                    'Proyek berhasil ditambahkan!',
                                    style: TextStyle(
                                      color: Color(0xFFD8B779),
                                      fontFamily: 'serif',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Nama: $_projectName',
                                          style: const TextStyle(
                                            color: Color(0xFFE8D5AC),
                                          ),
                                        ),
                                        Text(
                                          'Deskripsi: $_description',
                                          style: const TextStyle(
                                            color: Color(0xFFE8D5AC),
                                          ),
                                        ),
                                        Text(
                                          'Kategori: $_category',
                                          style: const TextStyle(
                                            color: Color(0xFFE8D5AC),
                                          ),
                                        ),
                                        Text(
                                          'Teknologi: ${_technologies.isEmpty ? "-" : _technologies}',
                                          style: const TextStyle(
                                            color: Color(0xFFE8D5AC),
                                          ),
                                        ),
                                        Text(
                                          'Tautan: ${_projectLink.isEmpty ? "-" : _projectLink}',
                                          style: const TextStyle(
                                            color: Color(0xFFE8D5AC),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text(
                                        'OK',
                                        style: TextStyle(
                                          color: Color(0xFFD8B779),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _formKey.currentState!.reset();
                                        setState(() {
                                          _projectName = "";
                                          _description = "";
                                          _category = "Web Development";
                                          _technologies = "";
                                          _projectLink = "";
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(
                            color: Color(0xFFE8D5AC),
                            fontFamily: 'serif',
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
    );
  }
}