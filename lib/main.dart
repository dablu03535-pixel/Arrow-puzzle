
import 'package:flutter/material.dart';

void main() {
  runApp(const ArrowPuzzleApp());
}

class ArrowPuzzleApp extends StatelessWidget {
  const ArrowPuzzleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Arrow Puzzle',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'sans',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _startGame(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const GamePlaceholderScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF7F9FF),
              Color(0xFFE9EEFF),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 18),

                // Top bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _circleButton(
                      icon: Icons.settings_rounded,
                      onTap: () {},
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x18000000),
                            blurRadius: 12,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.monetization_on_rounded,
                            color: Color(0xFFFFB300),
                            size: 22,
                          ),
                          SizedBox(width: 7),
                          Text(
                            '1250',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Logo
                const Text(
                  'ARROW',
                  style: TextStyle(
                    fontSize: 46,
                    height: 0.95,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: Color(0xFF20263D),
                  ),
                ),
                const Text(
                  'PUZZLE',
                  style: TextStyle(
                    fontSize: 46,
                    height: 1,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                    color: Color(0xFF5B6CFF),
                  ),
                ),

                const SizedBox(height: 28),

                // Arrow logo
                Container(
                  width: 112,
                  height: 112,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x225B6CFF),
                        blurRadius: 25,
                        offset: Offset(0, 12),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_upward_rounded,
                      size: 70,
                      color: Color(0xFF5B6CFF),
                    ),
                  ),
                ),

                const SizedBox(height: 38),

                // PLAY button
                SizedBox(
                  width: double.infinity,
                  height: 62,
                  child: ElevatedButton(
                    onPressed: () => _startGame(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5B6CFF),
                      foregroundColor: Colors.white,
                      elevation: 8,
                      shadowColor: const Color(0x445B6CFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow_rounded, size: 30),
                        SizedBox(width: 8),
                        Text(
                          'PLAY',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Daily Challenge
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF30384F),
                      side: const BorderSide(
                        color: Color(0x335B6CFF),
                        width: 1.5,
                      ),
                      backgroundColor: Colors.white.withOpacity(0.65),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_month_rounded),
                        SizedBox(width: 9),
                        Text(
                          'DAILY CHALLENGE',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(),

                // Bottom menu
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _bottomItem(Icons.grid_view_rounded, 'Levels'),
                    _bottomItem(Icons.card_giftcard_rounded, 'Rewards'),
                    _bottomItem(Icons.emoji_events_rounded, 'Stats'),
                  ],
                ),

                const SizedBox(height: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      elevation: 3,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(
            icon,
            color: const Color(0xFF30384F),
            size: 23,
          ),
        ),
      ),
    );
  }

  static Widget _bottomItem(IconData icon, String label) {
    return Column(
      children: [
        Icon(
          icon,
          size: 25,
          color: const Color(0xFF5B6CFF),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF5A6175),
          ),
        ),
      ],
    );
  }
}

class GamePlaceholderScreen extends StatelessWidget {
  const GamePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Level 1'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.extension_rounded,
              size: 80,
              color: Color(0xFF5B6CFF),
            ),
            const SizedBox(height: 20),
            const Text(
              'GAME BOARD',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '5×5 Arrow Puzzle coming next!',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('BACK HOME'),
            ),
          ],
        ),
      ),
    );
  }
}
