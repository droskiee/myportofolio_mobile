import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/screens/login_screen.dart';
import 'package:myportofolio_mobile/screens/project_list_screen.dart';
import 'package:myportofolio_mobile/screens/project_form.dart';
import 'package:myportofolio_mobile/screens/education_form.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:provider/provider.dart';

// HOMEPAGE ITEM DATA
class ItemHomepage {
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final Color secondaryColor;

  ItemHomepage(
    this.name,
    this.description,
    this.icon,
    this.color,
    this.secondaryColor,
  );
}

// MENU CARD
class ItemCard extends StatelessWidget {
  final ItemHomepage item;

  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    const Color gold = Color(0xFFD8B779);
    const Color parchment = Color(0xFFE8D5AC);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () async {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                backgroundColor: const Color(0xFF29251C),
                behavior: SnackBarBehavior.floating,
                content: Text(
                  "Kamu telah menekan tombol ${item.name}!",
                  style: const TextStyle(color: parchment),
                ),
              ),
            );

          if (item.name == "Lihat Proyek") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProjectListScreen(),
              ),
            );
          } else if (item.name == "Tambah Proyek") {
            if (!await ensureLoggedIn(context) || !context.mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProjectFormPage()),
            );
          } else if (item.name == "Education") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EducationFormPage(),
              ),
            );
          } else if (item.name == "Logout") {
            final authState = context.read<AuthState>();
            if (!authState.isLoggedIn) {
              await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
              return;
            }
            try {
              await authState.logout();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('You have been logged out.')),
              );
            } catch (error) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Logout completed locally: $error')),
              );
            }
          }
        },
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [item.color, item.secondaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: gold, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // DECORATIVE CLOVER
              Positioned(
                top: 12,
                left: 12,
                child: Icon(
                  Icons.filter_vintage,
                  size: 65,
                  color: Colors.white.withValues(alpha: 0.07),
                ),
              ),
              Positioned(
                bottom: 12,
                right: 12,
                child: Icon(
                  Icons.filter_vintage,
                  size: 75,
                  color: Colors.white.withValues(alpha: 0.07),
                ),
              ),

              // CARD CONTENT
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(19),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: gold.withValues(alpha: 0.8),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(item.icon, color: parchment, size: 38),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        item.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: parchment,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'serif',
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        item.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: gold, width: 1.5),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: gold,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
