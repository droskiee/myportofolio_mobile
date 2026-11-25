import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/project.dart';

class ProjectDetailScreen extends StatelessWidget {
  const ProjectDetailScreen({super.key, required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final imageUrl = project.projectImageUrl?.trim() ?? '';
    final imageUri = Uri.tryParse(imageUrl);
    final hasValidImage =
        imageUri != null &&
        (imageUri.scheme == 'http' || imageUri.scheme == 'https') &&
        imageUri.host.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFF10100F),
      appBar: AppBar(
        title: Text(project.title),
        backgroundColor: const Color(0xFF171612),
        foregroundColor: const Color(0xFFD8B779),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (hasValidImage)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                height: 230,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const SizedBox(
                    height: 230,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFD8B779),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) =>
                    _imageUnavailable(),
              ),
            )
          else if (imageUrl.isNotEmpty)
            _imageUnavailable(),
          if (hasValidImage || imageUrl.isNotEmpty) const SizedBox(height: 24),
          Text(
            project.title,
            style: const TextStyle(
              color: Color(0xFFD8B779),
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'serif',
            ),
          ),
          const SizedBox(height: 20),
          _section('Description', project.description),
          _section('Tech stack', project.techStack),
          _section(
            'Project URL',
            project.projectUrl.isEmpty ? 'Not provided' : project.projectUrl,
          ),
        ],
      ),
    );
  }

  Widget _section(String title, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFD8B779),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        SelectableText(
          value,
          style: const TextStyle(color: Color(0xFFE8D5AC), height: 1.5),
        ),
      ],
    ),
  );

  Widget _imageUnavailable() => Container(
    height: 180,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: const Color(0xFF1C1B18),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFF9C8150)),
    ),
    child: const Text(
      'Image unavailable',
      style: TextStyle(color: Color(0xFFE8D5AC)),
    ),
  );
}
