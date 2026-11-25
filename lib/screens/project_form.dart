import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ProjectFormPage extends StatefulWidget {
  const ProjectFormPage({super.key});

  @override
  State<ProjectFormPage> createState() => _ProjectFormPageState();
}

class _ProjectFormPageState extends State<ProjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _techStackController = TextEditingController();
  final _projectUrlController = TextEditingController();
  final _imageUrlController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _techStackController.dispose();
    _projectUrlController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting || !_formKey.currentState!.validate()) return;
    if (!await ensureLoggedIn(context) || !mounted) return;

    final token = context.read<AuthState>().token;
    if (token == null || token.isEmpty) return;

    setState(() => _isSubmitting = true);
    try {
      final project = Project(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        techStack: _techStackController.text.trim(),
        projectUrl: _projectUrlController.text.trim(),
        projectImageUrl: _imageUrlController.text.trim().isEmpty
            ? ''
            : _imageUrlController.text.trim(),
      );
      await context.read<ApiClient>().createProject(project, token: token);
      if (!mounted) return;

      _resetForm();
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: const Color(0xFF171612),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: const BorderSide(color: Color(0xFFD8B779), width: 1.5),
          ),
          title: const Text(
            'Project created successfully.',
            style: TextStyle(
              color: Color(0xFFD8B779),
              fontFamily: 'serif',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'The project has been added to your portfolio.',
            style: TextStyle(color: Color(0xFFE8D5AC)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'OK',
                style: TextStyle(color: Color(0xFFD8B779)),
              ),
            ),
          ],
        ),
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      if (error.statusCode == 401) {
        try {
          await context.read<AuthState>().logout();
        } catch (_) {
          // AuthState clears the local token even when the server rejects it.
        }
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your session expired. Please log in again.'),
          ),
        );
        await ensureLoggedIn(context);
      } else {
        final message = error.statusCode == 403
            ? '${error.message} Project creation is restricted to the portfolio superuser.'
            : error.message;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not create the project: $error')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _descriptionController.clear();
    _techStackController.clear();
    _projectUrlController.clear();
    _imageUrlController.clear();
  }

  String? _validateUrl(String? value, {required bool optional}) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return optional ? null : 'Enter the project URL.';
    }
    final uri = Uri.tryParse(trimmed);
    if (uri == null ||
        !(uri.scheme == 'http' || uri.scheme == 'https') ||
        uri.host.isEmpty) {
      return 'Enter a valid URL beginning with http:// or https://.';
    }
    return null;
  }

  InputDecoration _decoration(String label, {String? hint}) => InputDecoration(
    labelText: label,
    hintText: hint,
    hintStyle: TextStyle(
      color: const Color(0xFFE8D5AC).withValues(alpha: 0.45),
    ),
    labelStyle: const TextStyle(color: Color(0xFFD8B779), fontFamily: 'serif'),
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
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10100F),
      appBar: AppBar(
        title: const Text(
          'Add Project Form',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _field(
                    controller: _titleController,
                    label: 'Project title',
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Project title cannot be empty.'
                        : null,
                  ),
                  _field(
                    controller: _descriptionController,
                    label: 'Description',
                    maxLines: 5,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Description cannot be empty.'
                        : null,
                  ),
                  _field(
                    controller: _techStackController,
                    label: 'Tech stack',
                    hint: 'Example: Flutter, Django, Figma',
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Enter the project tech stack.'
                        : null,
                  ),
                  _field(
                    controller: _projectUrlController,
                    label: 'Project URL',
                    hint: 'https://example.com',
                    keyboardType: TextInputType.url,
                    validator: (value) => _validateUrl(value, optional: false),
                  ),
                  _field(
                    controller: _imageUrlController,
                    label: 'Project image URL (optional)',
                    hint: 'https://example.com/image.png',
                    keyboardType: TextInputType.url,
                    validator: (value) => _validateUrl(value, optional: true),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submit,
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
                        child: _isSubmitting
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFFE8D5AC),
                                ),
                              )
                            : const Text(
                                'Save project',
                                style: TextStyle(
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

  Widget _field({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    FormFieldValidator<String>? validator,
  }) => Padding(
    padding: const EdgeInsets.all(8),
    child: TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(color: Color(0xFFE8D5AC)),
      decoration: _decoration(label, hint: hint),
      validator: validator,
    ),
  );
}
