import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/models/project.dart';
import 'package:myportofolio_mobile/screens/project_detail_screen.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:provider/provider.dart';

class ProjectListScreen extends StatefulWidget {
  const ProjectListScreen({super.key});

  @override
  State<ProjectListScreen> createState() => _ProjectListScreenState();
}

class _ProjectListScreenState extends State<ProjectListScreen> {
  late Future<List<Project>> _projectsFuture;

  @override
  void initState() {
    super.initState();
    _projectsFuture = context.read<ApiClient>().getProjects();
  }

  Future<void> _refresh() async {
    final future = context.read<ApiClient>().getProjects();
    setState(() {
      _projectsFuture = future;
    });
    try {
      await future;
    } catch (_) {
      // The FutureBuilder displays the failed request and its retry action.
    }
  }

  void _retry() {
    setState(() {
      _projectsFuture = context.read<ApiClient>().getProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10100F),
      appBar: AppBar(
        title: const Text('Projects'),
        backgroundColor: const Color(0xFF171612),
        foregroundColor: const Color(0xFFD8B779),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: const Color(0xFFD8B779),
        backgroundColor: const Color(0xFF1C1B18),
        child: FutureBuilder<List<Project>>(
          future: _projectsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _scrollableMessage(
                const CircularProgressIndicator(color: Color(0xFFD8B779)),
              );
            }
            if (snapshot.hasError) {
              final error = snapshot.error;
              final message = error is ApiException
                  ? error.message
                  : 'Could not load projects. Check your connection and try again.';
              return _scrollableMessage(
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_off_outlined,
                      color: Color(0xFFD8B779),
                      size: 42,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFFE8D5AC)),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _retry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFD8B779),
                        side: const BorderSide(color: Color(0xFFD8B779)),
                      ),
                    ),
                  ],
                ),
              );
            }

            final projects = snapshot.data ?? const <Project>[];
            if (projects.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 180),
                  Center(
                    child: Text(
                      'No projects found.',
                      style: TextStyle(color: Color(0xFFE8D5AC), fontSize: 16),
                    ),
                  ),
                ],
              );
            }

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return Card(
                  color: const Color(0xFF1C1B18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFF9C8150)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      project.title,
                      style: const TextStyle(
                        color: Color(0xFFD8B779),
                        fontFamily: 'serif',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project.description,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Color(0xFFE8D5AC)),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            project.techStack,
                            style: const TextStyle(color: Color(0xFFB99B62)),
                          ),
                        ],
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Color(0xFFD8B779),
                    ),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ProjectDetailScreen(project: project),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _scrollableMessage(Widget child) => ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    children: [
      SizedBox(height: MediaQuery.sizeOf(context).height * 0.3),
      Center(
        child: Padding(padding: const EdgeInsets.all(24), child: child),
      ),
    ],
  );
}
