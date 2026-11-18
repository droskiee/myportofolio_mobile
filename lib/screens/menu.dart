import 'package:flutter/material.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:myportofolio_mobile/widgets/project_card.dart';

// BLACK CLOVER COLOR PALETTE
const Color darkBackground = Color(0xFF10100F);
const Color darkSurface = Color(0xFF1C1B18);
const Color gold = Color(0xFFD8B779);
const Color parchment = Color(0xFFE8D5AC);
const Color mutedGold = Color(0xFF9C8150);

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final String npm = "2506623055";
  final String nama = "Piedra Ridwan Azra Pulungan";
  final String kelas = "PBP D";

  final List<ItemHomepage> items = [
    ItemHomepage(
      "Lihat Proyek",
      "Jelajahi proyek-proyek\nyang telah Anda buat",
      Icons.folder_open_rounded,
      const Color(0xFF14283E),
      const Color(0xFF263F5C),
    ),
    ItemHomepage(
      "Tambah Proyek",
      "Tambahkan proyek baru\nke portofolio Anda",
      Icons.add_circle_outline_rounded,
      const Color(0xFF183D28),
      const Color(0xFF28613A),
    ),
    ItemHomepage(
      "Logout",
      "Keluar dari akun Anda",
      Icons.logout_rounded,
      const Color(0xFF481D1B),
      const Color(0xFF762B26),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      drawer: const LeftDrawer(),
      body: Stack(
        children: [
          // Background magic decoration
          Positioned.fill(
            child: CustomPaint(
              painter: MagicBackgroundPainter(),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // HEADER
                  _buildHeader(),

                  // MAIN CONTENT
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 28,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 1250,
                        ),
                        child: Column(
                          children: [
                            // HERO SECTION
                            _buildHero(),
                            const SizedBox(height: 35),

                            // PROFILE INFORMATION
                            _buildInfoSection(context),
                            const SizedBox(height: 38),

                            // SECTION TITLE
                            _buildSectionTitle(),
                            const SizedBox(height: 22),

                            // MENU CARDS
                            _buildMenuSection(context),
                            const SizedBox(height: 45),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // FOOTER
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // HEADER
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 20,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF171612),
        border: Border(
          bottom: BorderSide(
            color: mutedGold,
            width: 1.2,
          ),
        ),
      ),
      child: Row(
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: gold, size: 28),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.filter_vintage,
            color: gold,
            size: 38,
          ),
          const SizedBox(width: 14),
          const Text(
            "MyPortfolio",
            style: TextStyle(
              color: parchment,
              fontSize: 27,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              fontFamily: 'serif',
            ),
          ),
          const Spacer(),
          const Text(
            "GRIMOIRE ARCHIVE",
            style: TextStyle(
              color: mutedGold,
              fontSize: 11,
              letterSpacing: 3,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // HERO SECTION
  Widget _buildHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 35,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF171612),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: mutedGold.withValues(alpha: 0.6),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isSmall = constraints.maxWidth < 650;
          return Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "WELCOME TO YOUR GRIMOIRE",
                      style: TextStyle(
                        color: gold,
                        fontSize: 12,
                        letterSpacing: 3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Selamat datang di",
                      style: TextStyle(
                        color: parchment,
                        fontSize: 25,
                        fontFamily: 'serif',
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "MyPortfolio Mobile!",
                      style: TextStyle(
                        color: gold,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'serif',
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      "Kelola proyek, tambahkan portofolio, "
                      "dan logout dengan mudah.",
                      style: TextStyle(
                        color: parchment.withValues(alpha: 0.8),
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      height: 2,
                      width: 180,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            gold,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isSmall) ...[
                const SizedBox(width: 20),
                Expanded(
                  flex: 1,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.circle_outlined,
                        size: 175,
                        color: gold.withValues(alpha: 0.2),
                      ),
                      Icon(
                        Icons.auto_awesome,
                        size: 100,
                        color: gold.withValues(alpha: 0.8),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Icon(
                          Icons.star,
                          size: 24,
                          color: gold.withValues(alpha: 0.7),
                        ),
                      ),
                      Positioned(
                        bottom: 15,
                        left: 10,
                        child: Icon(
                          Icons.filter_vintage,
                          size: 30,
                          color: mutedGold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  // PROFILE INFORMATION
  Widget _buildInfoSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isSmall = constraints.maxWidth < 650;
        List<Widget> cards = [
          InfoCard(
            title: "NPM",
            content: npm,
            icon: Icons.memory_rounded,
          ),
          InfoCard(
            title: "Name",
            content: nama,
            icon: Icons.person_rounded,
          ),
          InfoCard(
            title: "Class",
            content: kelas,
            icon: Icons.school_rounded,
          ),
        ];

        return Wrap(
          spacing: 15,
          runSpacing: 15,
          children: cards.map((card) {
            return SizedBox(
              width: isSmall
                  ? constraints.maxWidth
                  : (constraints.maxWidth - 30) / 3,
              child: card,
            );
          }).toList(),
        );
      },
    );
  }

  // SECTION TITLE
  Widget _buildSectionTitle() {
    return Row(
      children: [
        Container(
          width: 5,
          height: 35,
          decoration: BoxDecoration(
            color: gold,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(width: 12),
        const Flexible(
          child: Text(
            "Your Portfolio",
            style: TextStyle(
              color: parchment,
              fontSize: 23,
              fontWeight: FontWeight.bold,
              fontFamily: 'serif',
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Container(
            height: 1,
            color: mutedGold.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(width: 12),
        const Icon(
          Icons.filter_vintage,
          color: gold,
          size: 27,
        ),
      ],
    );
  }

  // MENU SECTION
  Widget _buildMenuSection(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = constraints.maxWidth >= 850
            ? 3
            : constraints.maxWidth >= 550
                ? 2
                : 1;
        double spacing = 15;
        double cardWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: items.map((item) {
            return SizedBox(
              width: cardWidth,
              height: 275,
              child: ItemCard(item),
            );
          }).toList(),
        );
      },
    );
  }

  // FOOTER
  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 22,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1915),
        border: Border(
          top: BorderSide(
            color: mutedGold.withValues(alpha: 0.7),
            width: 1,
          ),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite,
            color: gold,
            size: 19,
          ),
          SizedBox(width: 12),
          Flexible(
            child: Text(
              "Terima kasih telah mengunjungi MyPortfolio!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: parchment,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// INFORMATION CARD
class InfoCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;

  const InfoCard({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFEADAB9),
            Color(0xFFD6BD8D),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: gold,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: darkBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: gold,
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: gold,
              size: 27,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF211A11),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'serif',
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  content,
                  style: const TextStyle(
                    color: Color(0xFF211A11),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// BACKGROUND MAGIC CIRCLE
class MagicBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = gold.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Large magic circle
    final Offset center = Offset(
      size.width * 0.85,
      size.height * 0.27,
    );

    canvas.drawCircle(center, 115, paint);
    canvas.drawCircle(center, 135, paint);
    canvas.drawCircle(center, 155, paint);

    // Inner decorative circle
    final Paint innerPaint = Paint()
      ..color = gold.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, 75, innerPaint);

    // Magic circle lines
    for (int i = 0; i < 8; i++) {
      final Offset point = Offset(
        center.dx + 155 * (i % 2 == 0 ? 1 : 0.75) * (i % 4 < 2 ? 1 : -1),
        center.dy + 155 * (i / 4 < 2 ? 0.75 : 1) * (i < 4 ? 1 : -1),
      );
      canvas.drawLine(center, point, paint);
    }

    // Decorative clover symbols
    final TextPainter clover = TextPainter(
      text: TextSpan(
        text: "✦",
        style: TextStyle(
          color: gold.withValues(alpha: 0.08),
          fontSize: 45,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    clover.layout();
    clover.paint(
      canvas,
      Offset(size.width * 0.08, size.height * 0.55),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}