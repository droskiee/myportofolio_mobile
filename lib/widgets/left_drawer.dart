import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/menu.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthState>();
    return Drawer(
      backgroundColor: const Color(0xFF171612),
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF10100F),
              border: Border(
                bottom: BorderSide(color: Color(0xFF9C8150), width: 1.5),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'My Portfolio',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD8B779),
                    fontFamily: 'serif',
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Explore personal projects and experiences!',
                  style: TextStyle(fontSize: 14, color: Color(0xFFE8D5AC)),
                ),
              ],
            ),
          ),

          // HOME
          ListTile(
            leading: const Icon(Icons.home_outlined, color: Color(0xFFD8B779)),
            title: const Text(
              'Home',
              style: TextStyle(color: Color(0xFFE8D5AC), fontFamily: 'serif'),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.folder_open, color: Color(0xFFD8B779)),
            title: const Text(
              'Projects',
              style: TextStyle(color: Color(0xFFE8D5AC), fontFamily: 'serif'),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProjectListScreen()),
              );
            },
          ),

          // ADD PROJECT
          ListTile(
            leading: const Icon(
              Icons.add_circle_outline,
              color: Color(0xFFD8B779),
            ),
            title: const Text(
              'Add Project',
              style: TextStyle(color: Color(0xFFE8D5AC), fontFamily: 'serif'),
            ),
            onTap: () async {
              Navigator.pop(context);
              if (!await ensureLoggedIn(context) || !context.mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProjectFormPage(),
                ),
              );
            },
          ),

          // EDUCATION
          ListTile(
            leading: const Icon(
              Icons.school_outlined,
              color: Color(0xFFD8B779),
            ),
            title: const Text(
              'Education',
              style: TextStyle(color: Color(0xFFE8D5AC), fontFamily: 'serif'),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const EducationFormPage(),
                ),
              );
            },
          ),

          ListTile(
            leading: Icon(
              authState.isLoggedIn ? Icons.logout : Icons.login,
              color: const Color(0xFFD8B779),
            ),
            title: Text(
              authState.isLoggedIn ? 'Logout' : 'Login',
              style: const TextStyle(
                color: Color(0xFFE8D5AC),
                fontFamily: 'serif',
              ),
            ),
            onTap: () async {
              Navigator.pop(context);
              if (!authState.isLoggedIn) {
                await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
                return;
              }
              try {
                await context.read<AuthState>().logout();
              } catch (error) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logout completed locally: $error')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
