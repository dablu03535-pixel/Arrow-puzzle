
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      home: const SplashScreen(),
    );
  }
}


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _arrowController;

  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _arrowScale;
  late final Animation<double> _arrowOpacity;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );

    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _logoScale = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutBack,
    );

    _logoOpacity = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOut,
    );

    _arrowScale = CurvedAnimation(
      parent: _arrowController,
      curve: Curves.easeOutBack,
    );

    _arrowOpacity = CurvedAnimation(
      parent: _arrowController,
      curve: Curves.easeOut,
    );

    _startSplash();
  }

  Future<void> _startSplash() async {
    await _arrowController.forward();
    await _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 550));

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionDuration: const Duration(milliseconds: 450),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _arrowController.dispose();
    super.dispose();
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _arrowScale,
                child: FadeTransition(
                  opacity: _arrowOpacity,
                  child: Container(
                    width: 118,
                    height: 118,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x225B6CFF),
                          blurRadius: 30,
                          offset: Offset(0, 14),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_upward_rounded,
                        size: 74,
                        color: Color(0xFF5B6CFF),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              ScaleTransition(
                scale: _logoScale,
                child: FadeTransition(
                  opacity: _logoOpacity,
                  child: const Column(
                    children: [
                      Text(
                        'ARROW',
                        style: TextStyle(
                          fontSize: 42,
                          height: 0.95,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          color: Color(0xFF20263D),
                        ),
                      ),
                      Text(
                        'PUZZLE',
                        style: TextStyle(
                          fontSize: 42,
                          height: 1,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                          color: Color(0xFF5B6CFF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 42),

              SizedBox(
                width: 120,
                child: LinearProgressIndicator(
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(10),
                  backgroundColor: const Color(0x225B6CFF),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF5B6CFF),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              const Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  color: Color(0xFF777E91),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _lastLevel = 1;

  @override
  void initState() {
    super.initState();
    _loadLastLevel();
  }

  Future<void> _loadLastLevel() async {
    final prefs = await SharedPreferences.getInstance();
    final level = prefs.getInt('last_level') ?? 1;

    if (!mounted) return;

    setState(() {
      _lastLevel = level < 1 ? 1 : level;
    });
  }

  Future<void> _startGame(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    // PLAY always starts a completely fresh board.
    await prefs.remove('arrow_progress_level');
    await prefs.remove('arrow_progress_removed');
    await prefs.remove('arrow_progress_moves');
    await prefs.setBool('arrow_progress_exists', false);

    if (!context.mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GamePlaceholderScreen(
          level: _lastLevel,
          resume: false,
        ),
      ),
    );
  }

  void _continueGame(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GamePlaceholderScreen(
          level: _lastLevel,
          resume: true,
        ),
      ),
    );
  }


  Widget _homeIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFF17213F),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            icon,
            color: const Color(0xFFD9DEEF),
            size: 22,
          ),
        ),
      ),
    );
  }

  Widget _resourceChip({
    required IconData icon,
    required Color iconColor,
    required String value,
    String? label,
    bool showPlus = false,
  }) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF17213F),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0x225B6CFF),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 21),
          const SizedBox(width: 6),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (label != null)
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF8F9ABC),
                    fontSize: 7,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
            ],
          ),
          if (showPlus) ...[
            const SizedBox(width: 6),
            Container(
              width: 19,
              height: 19,
              decoration: BoxDecoration(
                color: const Color(0xFF4ACB5A),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _miniArrowTile(
    IconData icon,
    Color color,
    double rotation,
  ) {
    return Transform.rotate(
      angle: rotation,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.20),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: color.withValues(alpha: 0.45),
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.18),
              blurRadius: 18,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color,
          size: 27,
        ),
      ),
    );
  }

  Widget _homeWideButton({
    required IconData icon,
    required Color iconColor,
    required Color background,
    required String title,
    required String subtitle,
    String? badge,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 67,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0x334C5D91),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 43,
                height: 43,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFFB9C2D9),
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE94B61),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                )
              else
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFFAAB4D2),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _homeSmallTile({
    required IconData icon,
    required String title,
    required Color background,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          height: 82,
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 9,
          ),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: const Color(0x334C5D91),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 27,
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featureItem(
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFF8D9CFF),
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF7F8AA7),
              fontSize: 7,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomNavItem(
    IconData icon,
    String label,
    bool selected,
    VoidCallback? onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: selected
                  ? const Color(0xFFFFC83D)
                  : const Color(0xFF7F89A5),
              size: 21,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? const Color(0xFFFFC83D)
                    : const Color(0xFF7F89A5),
                fontSize: 7,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: selected ? 18 : 0,
              height: 2,
              decoration: BoxDecoration(
                color: const Color(0xFFFFC83D),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080D1D),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF141B43),
              Color(0xFF0B1028),
              Color(0xFF070B18),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
                  child: Column(
                    children: [
                      // =====================================================
                      // TOP RESOURCE BAR
                      // =====================================================
                      Row(
                        children: [
                          _homeIconButton(
                            icon: Icons.settings_rounded,
                            onTap: () => _showComingSoon(
                              context,
                              'Settings',
                            ),
                          ),
                          const Spacer(),

                          _resourceChip(
                            icon: Icons.favorite_rounded,
                            iconColor: const Color(0xFFFF536D),
                            value: '5',
                            label: 'FULL',
                          ),
                          const SizedBox(width: 8),

                          _resourceChip(
                            icon: Icons.monetization_on_rounded,
                            iconColor: const Color(0xFFFFC83D),
                            value: '1250',
                            showPlus: true,
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      // =====================================================
                      // GAME LOGO / TITLE
                      // =====================================================
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            left: 8,
                            top: 24,
                            child: _miniArrowTile(
                              Icons.arrow_upward_rounded,
                              const Color(0xFF7A5CFF),
                              -0.08,
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 48,
                            child: _miniArrowTile(
                              Icons.arrow_forward_rounded,
                              const Color(0xFF4C8DFF),
                              0.08,
                            ),
                          ),
                          Column(
                            children: [
                              const Text(
                                'ARROW',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 43,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2.5,
                                  height: 0.95,
                                  shadows: [
                                    Shadow(
                                      color: Color(0x885B6CFF),
                                      blurRadius: 18,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 3),
                              const Text(
                                'PUZZLE',
                                style: TextStyle(
                                  color: Color(0xFFFFC83D),
                                  fontSize: 38,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                  height: 0.95,
                                  shadows: [
                                    Shadow(
                                      color: Color(0x997A4B00),
                                      blurRadius: 10,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 9),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 18,
                                    height: 2,
                                    color: const Color(0x66FFFFFF),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'TAP  •  CLEAR  •  RELAX',
                                    style: TextStyle(
                                      color: Color(0xFFB8C0D9),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 18,
                                    height: 2,
                                    color: const Color(0x66FFFFFF),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 25),

                      // =====================================================
                      // PLAY
                      // =====================================================
                      SizedBox(
                        width: double.infinity,
                        height: 64,
                        child: ElevatedButton(
                          onPressed: () => _startGame(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF55C92C),
                            foregroundColor: Colors.white,
                            elevation: 12,
                            shadowColor: const Color(0x6655C92C),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(19),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.play_arrow_rounded,
                                size: 34,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'PLAY',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 11),

                      // =====================================================
                      // CONTINUE
                      // =====================================================
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: OutlinedButton(
                          onPressed: () => _continueGame(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFF18244A),
                            side: const BorderSide(
                              color: Color(0x665B6CFF),
                              width: 1.4,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF5265E8),
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                child: const Icon(
                                  Icons.play_arrow_rounded,
                                  size: 27,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'CONTINUE',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'RESUME YOUR PUZZLE',
                                      style: TextStyle(
                                        color: Color(0xFF8F9ABC),
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'LEVEL $_lastLevel',
                                style: const TextStyle(
                                  color: Color(0xFFFFC83D),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(width: 7),
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: Color(0xFF8E9AFF),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 17),

                      // =====================================================
                      // DAILY CHALLENGE
                      // =====================================================
                      _homeWideButton(
                        icon: Icons.calendar_month_rounded,
                        iconColor: const Color(0xFFE2A7FF),
                        background: const Color(0xFF4A286F),
                        title: 'DAILY CHALLENGE',
                        subtitle: 'New puzzle every day • Win rewards',
                        badge: 'NEW',
                        onTap: () => _showComingSoon(
                          context,
                          'Daily Challenge',
                        ),
                      ),

                      const SizedBox(height: 10),

                      // =====================================================
                      // LEVELS
                      // =====================================================
                      _homeWideButton(
                        icon: Icons.grid_view_rounded,
                        iconColor: const Color(0xFF7FD5FF),
                        background: const Color(0xFF183E67),
                        title: 'LEVELS',
                        subtitle: 'Explore puzzles and track your progress',
                        onTap: () => _showComingSoon(
                          context,
                          'Levels',
                        ),
                      ),

                      const SizedBox(height: 12),

                      // =====================================================
                      // SHOP / REWARDS / STATS
                      // =====================================================
                      Row(
                        children: [
                          Expanded(
                            child: _homeSmallTile(
                              icon: Icons.storefront_rounded,
                              title: 'SHOP',
                              background: const Color(0xFF70451F),
                              iconColor: const Color(0xFFFFC55A),
                              onTap: () => _showComingSoon(
                                context,
                                'Shop',
                              ),
                            ),
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: _homeSmallTile(
                              icon: Icons.card_giftcard_rounded,
                              title: 'REWARDS',
                              background: const Color(0xFF4C3474),
                              iconColor: const Color(0xFFFFC85A),
                              onTap: () => _showComingSoon(
                                context,
                                'Rewards',
                              ),
                            ),
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: _homeSmallTile(
                              icon: Icons.bar_chart_rounded,
                              title: 'STATS',
                              background: const Color(0xFF195A58),
                              iconColor: const Color(0xFF68E5D8),
                              onTap: () => _showComingSoon(
                                context,
                                'Stats',
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 17),

                      // =====================================================
                      // FEATURE STRIP
                      // =====================================================
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 13,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0x99121B38),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: const Color(0x225B6CFF),
                          ),
                        ),
                        child: Row(
                          children: [
                            _featureItem(
                              Icons.flash_on_rounded,
                              'Simple',
                              'Tap to play',
                            ),
                            _featureItem(
                              Icons.psychology_rounded,
                              'Challenging',
                              'Brain puzzle',
                            ),
                            _featureItem(
                              Icons.lightbulb_rounded,
                              'Hints',
                              'Need help?',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ===========================================================
              // BOTTOM NAVIGATION
              // ===========================================================
              Container(
                padding: const EdgeInsets.fromLTRB(10, 9, 10, 8),
                decoration: const BoxDecoration(
                  color: Color(0xFF0B1127),
                  border: Border(
                    top: BorderSide(
                      color: Color(0x223D4A7A),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _bottomNavItem(
                        Icons.home_rounded,
                        'HOME',
                        true,
                        null,
                      ),
                    ),
                    Expanded(
                      child: _bottomNavItem(
                        Icons.emoji_events_rounded,
                        'TROPHIES',
                        false,
                        () => _showComingSoon(
                          context,
                          'Trophies',
                        ),
                      ),
                    ),
                    Expanded(
                      child: _bottomNavItem(
                        Icons.card_giftcard_rounded,
                        'REWARDS',
                        false,
                        () => _showComingSoon(
                          context,
                          'Rewards',
                        ),
                      ),
                    ),
                    Expanded(
                      child: _bottomNavItem(
                        Icons.storefront_rounded,
                        'SHOP',
                        false,
                        () => _showComingSoon(
                          context,
                          'Shop',
                        ),
                      ),
                    ),
                    Expanded(
                      child: _bottomNavItem(
                        Icons.settings_rounded,
                        'SETTINGS',
                        false,
                        () => _showComingSoon(
                          context,
                          'Settings',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _topPill({
    required IconData icon,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 11,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF151F3A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0x332F3C62),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 20,
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _largeMenuButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFF111A32),
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          height: 67,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: const Color(0x263C4B73),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 29,
                color: iconColor,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF7E88A5),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF6E7895),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _smallMenuButton({
    required IconData icon,
    required String title,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: const Color(0xFF111A32),
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: const Color(0x263C4B73),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
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
      color: const Color(0xFF151F3A),
      elevation: 2,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(11),
          child: Icon(
            icon,
            color: Colors.white,
            size: 22,
          ),
        ),
      ),
    );
  }

  static Widget _bottomItem(
    IconData icon,
    String label, {
    required VoidCallback onTap,
    bool active = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 25,
                color: active
                    ? const Color(0xFF6C7CFF)
                    : const Color(0xFF65708E),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: active
                      ? const Color(0xFF6C7CFF)
                      : const Color(0xFF65708E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _showComingSoon(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFF5B6CFF),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title),
              ),
            ],
          ),
          content: const Text(
            'This feature is coming soon.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class GamePlaceholderScreen extends StatefulWidget {
  const GamePlaceholderScreen({
    super.key,
    this.level = 1,
    this.resume = false,
  });

  final int level;
  final bool resume;

  @override
  State<GamePlaceholderScreen> createState() => _GamePlaceholderScreenState();
}

enum ArrowDirection { up, down, left, right }

class ArrowTile {
  ArrowTile({
    required this.row,
    required this.col,
    required this.direction,
  });

  final int row;
  final int col;
  final ArrowDirection direction;

  bool visible = true;
  bool moving = false;
  bool blocked = false;

  // Visual exit animation progress.
  // 0.0 = inside board, 1.0 = completely outside.
  double exitProgress = 0.0;
}

class _GamePlaceholderScreenState extends State<GamePlaceholderScreen> {
  static const int gridSize = 5;
  static const double boardPadding = 10;
  static const double cellGap = 7;

  late List<ArrowTile> arrows;
  int moves = 0;

  @override
  void initState() {
    super.initState();
    _createLevel();

    if (widget.resume) {
      _restoreProgress();
    }
  }

  void _createLevel() {
    final level = _buildLevel(widget.level);

    // Never allow an unsolvable level to enter the game.
    if (!_isLevelSolvable(level)) {
      throw StateError('Level ${widget.level} is not solvable.');
    }

    arrows = level;
    moves = 0;
  }

  List<ArrowTile> _buildLevel(int levelNumber) {
    // Level 1 — original tested puzzle.
    if (levelNumber == 1) {
      return [
        ArrowTile(row: 0, col: 0, direction: ArrowDirection.right),
        ArrowTile(row: 0, col: 2, direction: ArrowDirection.down),
        ArrowTile(row: 1, col: 2, direction: ArrowDirection.down),
        ArrowTile(row: 2, col: 2, direction: ArrowDirection.left),
        ArrowTile(row: 2, col: 1, direction: ArrowDirection.left),
        ArrowTile(row: 2, col: 0, direction: ArrowDirection.down),
        ArrowTile(row: 4, col: 0, direction: ArrowDirection.right),
        ArrowTile(row: 4, col: 1, direction: ArrowDirection.right),
        ArrowTile(row: 4, col: 3, direction: ArrowDirection.up),
        ArrowTile(row: 3, col: 3, direction: ArrowDirection.up),

        // Important: this arrow points right instead of down.
        // This removes the previous ↓ ↔ ↑ deadlock.
        ArrowTile(row: 1, col: 4, direction: ArrowDirection.right),

        ArrowTile(row: 3, col: 4, direction: ArrowDirection.up),
      ];
    }

    // Until a dedicated puzzle is added, use Level 1 as a safe fallback.
    return _buildLevel(1);
  }

  List<ArrowTile> _remaining(List<ArrowTile> list) {
    return list.where((a) => a.visible).toList();
  }

  bool _isBlockedBy(
    ArrowTile arrow,
    List<ArrowTile> list,
  ) {
    for (final other in _remaining(list)) {
      if (identical(other, arrow)) continue;

      switch (arrow.direction) {
        case ArrowDirection.up:
          if (other.col == arrow.col && other.row < arrow.row) {
            return true;
          }

        case ArrowDirection.down:
          if (other.col == arrow.col && other.row > arrow.row) {
            return true;
          }

        case ArrowDirection.left:
          if (other.row == arrow.row && other.col < arrow.col) {
            return true;
          }

        case ArrowDirection.right:
          if (other.row == arrow.row && other.col > arrow.col) {
            return true;
          }
      }
    }

    return false;
  }

  bool _isLevelSolvable(List<ArrowTile> original) {
    // Work on positions/directions only. This simulates removing
    // only arrows that are currently free.
    final remaining = original
        .map(
          (a) => ArrowTile(
            row: a.row,
            col: a.col,
            direction: a.direction,
          ),
        )
        .toList();

    while (remaining.isNotEmpty) {
      final free = remaining
          .where((arrow) => !_isBlockedBy(arrow, remaining))
          .toList();

      if (free.isEmpty) {
        return false;
      }

      // Remove all currently free arrows from the simulation.
      remaining.removeWhere((arrow) => free.contains(arrow));
    }

    return true;
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();

    final removedIndexes = <String>[];

    for (int i = 0; i < arrows.length; i++) {
      if (!arrows[i].visible) {
        removedIndexes.add(i.toString());
      }
    }

    await prefs.setInt('arrow_progress_level', widget.level);
    await prefs.setStringList(
      'arrow_progress_removed',
      removedIndexes,
    );
    await prefs.setInt('arrow_progress_moves', moves);
    await prefs.setBool('arrow_progress_exists', true);
  }

  Future<void> _restoreProgress() async {
    final prefs = await SharedPreferences.getInstance();

    final hasProgress =
        prefs.getBool('arrow_progress_exists') ?? false;

    if (!hasProgress) return;

    final savedLevel =
        prefs.getInt('arrow_progress_level') ?? widget.level;

    if (savedLevel != widget.level) return;

    final removedIndexes =
        prefs.getStringList('arrow_progress_removed') ?? <String>[];

    final savedMoves =
        prefs.getInt('arrow_progress_moves') ?? 0;

    if (!mounted) return;

    setState(() {
      for (final value in removedIndexes) {
        final index = int.tryParse(value);

        if (index != null &&
            index >= 0 &&
            index < arrows.length) {
          arrows[index].visible = false;
          arrows[index].moving = false;
          arrows[index].exitProgress = 1.0;
        }
      }

      moves = savedMoves;
    });
  }

  Future<void> _tapArrow(ArrowTile arrow) async {
    if (!arrow.visible || arrow.moving) {
      return;
    }

    // The path is checked using the current logical board.
    // Moving/removed arrows are ignored by _isBlockedBy().
    if (_isBlockedBy(arrow, arrows)) {
      setState(() {
        arrow.blocked = true;
      });

      await Future.delayed(const Duration(milliseconds: 160));

      if (!mounted) return;

      setState(() {
        arrow.blocked = false;
      });

      return;
    }

    // Remove this arrow logically immediately.
    // Its visual copy remains on screen during the exit animation.
    setState(() {
      arrow.visible = false;
      arrow.moving = true;
      arrow.exitProgress = 0.0;
      moves++;
    });

    // Save immediately so progress survives leaving the game.
    await _saveProgress();

    // IMPORTANT:
    // There is no global input lock.
    // Other arrows can be tapped immediately.

    await Future.delayed(const Duration(milliseconds: 380));

    if (!mounted) return;

    setState(() {
      arrow.moving = false;
      arrow.exitProgress = 1.0;
    });

    if (arrows.every((a) => !a.visible && !a.moving)) {
      await Future.delayed(const Duration(milliseconds: 120));

      if (mounted) {
        _showLevelComplete();
      }
    }
  }

  void _resetLevel() {
    setState(() {
      _createLevel();
    });
  }

  Future<void> _saveNextLevel() async {
    final prefs = await SharedPreferences.getInstance();

    final nextLevel = widget.level < 1 ? 2 : widget.level + 1;

    await prefs.setInt('last_level', nextLevel);

    // Completed level no longer needs resume data.
    await prefs.remove('arrow_progress_level');
    await prefs.remove('arrow_progress_removed');
    await prefs.remove('arrow_progress_moves');
    await prefs.setBool('arrow_progress_exists', false);
  }

  void _showLevelComplete() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            '🎉 Level Complete!',
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'All arrows cleared!',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 14),
              Text(
                'Moves: $moves',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetLevel();
              },
              child: const Text('REPLAY'),
            ),
            ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(context);

                await _saveNextLevel();
                if (!mounted) return;

                navigator.pop();
                navigator.pop();
              },
              child: const Text('HOME'),
            ),
          ],
        );
      },
    );
  }
  IconData _arrowIcon(ArrowDirection direction) {
    switch (direction) {
      case ArrowDirection.up:
        return Icons.arrow_upward_rounded;
      case ArrowDirection.down:
        return Icons.arrow_downward_rounded;
      case ArrowDirection.left:
        return Icons.arrow_back_rounded;
      case ArrowDirection.right:
        return Icons.arrow_forward_rounded;
    }
  }

  double _leftFor(
    ArrowTile arrow,
    double cellSize,
  ) {
    return boardPadding +
        arrow.col * (cellSize + cellGap);
  }

  double _topFor(
    ArrowTile arrow,
    double cellSize,
  ) {
    return boardPadding +
        arrow.row * (cellSize + cellGap);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F5FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () async {
            final navigator = Navigator.of(context);

            await _saveProgress();

            if (!mounted) return;

            navigator.pop();
          },
        ),
        title: const Text(
          'LEVEL 1',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Reset',
            onPressed: _resetLevel,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _infoCard(
                  Icons.touch_app_rounded,
                  'Moves',
                  '$moves',
                ),
                const SizedBox(width: 12),
                _infoCard(
                  Icons.keyboard_arrow_up_rounded,
                  'Arrows',
                  '${arrows.where((a) => a.visible).length}',
                ),
              ],
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.all(22),
              child: AspectRatio(
                aspectRatio: 1,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final boardSize = constraints.maxWidth;
                    final cellSize =
                        (boardSize -
                                (boardPadding * 2) -
                                (cellGap * (gridSize - 1))) /
                            gridSize;

                    return Container(
                      clipBehavior: Clip.none,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x18000000),
                            blurRadius: 25,
                            offset: Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Fixed 5x5 board.
                          Padding(
                            padding: const EdgeInsets.all(boardPadding),
                            child: GridView.builder(
                              physics:
                                  const NeverScrollableScrollPhysics(),
                              itemCount: gridSize * gridSize,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: gridSize,
                                crossAxisSpacing: cellGap,
                                mainAxisSpacing: cellGap,
                              ),
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F6FC),
                                    borderRadius:
                                        BorderRadius.circular(13),
                                  ),
                                );
                              },
                            ),
                          ),

                          // Every arrow has a permanently fixed board position.
                          // ONLY its visual child moves during exit animation.
                          for (final arrow in arrows)
                            if (arrow.visible || arrow.moving)
                              Positioned(
                                left: _leftFor(arrow, cellSize),
                                top: _topFor(arrow, cellSize),
                                width: cellSize,
                                height: cellSize,
                                child: TweenAnimationBuilder<double>(
                                  key: ValueKey(
                                    '${arrow.visible}-${arrow.moving}-${arrow.exitProgress}',
                                  ),
                                  tween: Tween<double>(
                                    begin: arrow.moving ? 0.0 : 1.0,
                                    end: arrow.moving ? 1.0 : 1.0,
                                  ),
                                  duration:
                                      const Duration(milliseconds: 380),
                                  curve: Curves.easeInCubic,
                                  builder: (context, animationValue, child) {
                                    final progress = arrow.moving
                                        ? animationValue
                                        : arrow.exitProgress;

                                    final left =
                                        boardPadding +
                                        arrow.col * (cellSize + cellGap);

                                    final top =
                                        boardPadding +
                                        arrow.row * (cellSize + cellGap);

                                    // Move the arrow all the way to the
                                    // corresponding 5x5 board boundary.
                                    // Add one extra cell so the complete
                                    // arrow visibly crosses the edge.
                                    final distance = switch (arrow.direction) {
                                      ArrowDirection.up =>
                                        (top + cellSize) + cellSize * 0.35,
                                      ArrowDirection.down =>
                                        (boardSize - top) + cellSize * 0.35,
                                      ArrowDirection.left =>
                                        (left + cellSize) + cellSize * 0.35,
                                      ArrowDirection.right =>
                                        (boardSize - left) + cellSize * 0.35,
                                    };

                                    final offset = switch (arrow.direction) {
                                      ArrowDirection.up =>
                                        Offset(0, -distance * progress),
                                      ArrowDirection.down =>
                                        Offset(0, distance * progress),
                                      ArrowDirection.left =>
                                        Offset(-distance * progress, 0),
                                      ArrowDirection.right =>
                                        Offset(distance * progress, 0),
                                    };

                                    return Transform.translate(
                                      offset: offset,
                                      child: child,
                                    );
                                  },
                                  child: IgnorePointer(
                                    ignoring: arrow.moving,
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () => _tapArrow(arrow),
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 100),
                                        curve: Curves.easeOut,
                                        transform: arrow.blocked
                                            ? (Matrix4.identity()
                                              ..translateByDouble(5.0, 0.0, 0.0, 1.0))
                                            : Matrix4.identity(),
                                        decoration: BoxDecoration(
                                          color: arrow.moving
                                              ? const Color(0xFFBFC7FF)
                                              : const Color(0xFF6575FF),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Color(0x405B6CFF),
                                              blurRadius: 8,
                                              offset: Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Icon(
                                            _arrowIcon(arrow.direction),
                                            color: Colors.white,
                                            size: 31,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            const Spacer(),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Tap an arrow only when its path is clear',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF697087),
                ),
              ),
            ),

            const SizedBox(height: 22),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: const Color(0xFF5B6CFF),
          ),
          const SizedBox(width: 6),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF777E91),
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
