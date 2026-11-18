import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/menu.dart';
import 'package:myportofolio_mobile/project_form.dart';
// TODO: Impor halaman ProjectFormPage jika sudah dibuat

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF171612),
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF10100F),
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFF9C8150),
                  width: 1.5,
                ),
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
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFE8D5AC),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.home_outlined,
              color: Color(0xFFD8B779),
            ),
            title: const Text(
              'Home',
              style: TextStyle(
                color: Color(0xFFE8D5AC),
                fontFamily: 'serif',
              ),
            ),
            // Navigasi ke halaman utama portofolio
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.add_circle_outline,
              color: Color(0xFFD8B779),
            ),
            title: const Text(
              'Add Project',
              style: TextStyle(
                color: Color(0xFFE8D5AC),
                fontFamily: 'serif',
              ),
            ),
            // Navigasi ke halaman tambah proyek
            onTap: () {
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ProjectFormPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}