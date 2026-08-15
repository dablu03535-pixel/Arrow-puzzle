
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

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _lastLevel = 1;

  // Step 4C: Home Screen resources.
  // Gameplay/shop logic will be connected in later steps.
  final int _lives = 5;
  final int _coins = 1250;

  // Step 4E: Home entrance + PLAY interaction animation.
  late final AnimationController _homeAnimationController;
  late final Animation<double> _homeFadeAnimation;
  late final Animation<Offset> _homeSlideAnimation;
  bool _playPressed = false;

  @override
  void initState() {
    super.initState();

    _homeAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );

    _homeFadeAnimation = CurvedAnimation(
      parent: _homeAnimationController,
      curve: Curves.easeOutCubic,
    );

    _homeSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.035),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _homeAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _homeAnimationController.forward();
    _loadLastLevel();
  }

  @override
  void dispose() {
    _homeAnimationController.dispose();
    super.dispose();
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

  void _setPlayPressed(bool pressed) {
    if (_playPressed == pressed) return;

    setState(() {
      _playPressed = pressed;
    });
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
              Color(0xFF101A3A),
              Color(0xFF080D1D),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _homeFadeAnimation,
            child: SlideTransition(
              position: _homeSlideAnimation,
              child: Column(
                children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
                  child: Column(
                    children: [
                      // TOP BAR
                      Row(
                        children: [
                          _circleButton(
                            icon: Icons.settings_rounded,
                            onTap: () => _showComingSoon(
                              context,
                              'Settings',
                              Icons.settings_rounded,
                            ),
                          ),
                          const Spacer(),
                          _topPill(
                            icon: Icons.favorite_rounded,
                            value: '$_lives',
                            iconColor: const Color(0xFFFF4F64),
                          ),
                          const SizedBox(width: 8),
                          _topPill(
                            icon: Icons.monetization_on_rounded,
                            value: _coins.toString(),
                            iconColor: const Color(0xFFFFC928),
                          ),
                        ],
                      ),

                      const SizedBox(height: 34),

                      // LOGO
                      const Text(
                        'ARROW',
                        style: TextStyle(
                          fontSize: 45,
                          height: 0.95,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Color(0x665B6CFF),
                              blurRadius: 18,
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        'PUZZLE',
                        style: TextStyle(
                          fontSize: 45,
                          height: 1,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 4,
                          color: Color(0xFF6C7CFF),
                          shadows: [
                            Shadow(
                              color: Color(0x665B6CFF),
                              blurRadius: 18,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 22),

                      // ARROW ICON
                      Container(
                        width: 108,
                        height: 108,
                        decoration: BoxDecoration(
                          color: const Color(0xFF111A35),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: const Color(0x335B6CFF),
                            width: 1.2,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x445B6CFF),
                              blurRadius: 30,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.arrow_upward_rounded,
                            size: 68,
                            color: Color(0xFF6878FF),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // PLAY
                      GestureDetector(
                        onTapDown: (_) => _setPlayPressed(true),
                        onTapUp: (_) => _setPlayPressed(false),
                        onTapCancel: () => _setPlayPressed(false),
                        child: AnimatedScale(
                          scale: _playPressed ? 0.965 : 1.0,
                          duration: const Duration(milliseconds: 90),
                          curve: Curves.easeOut,
                          child: SizedBox(
                            width: double.infinity,
                            height: 62,
                            child: ElevatedButton(
                              onPressed: () => _startGame(context),
                              style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF58C72D),
                            foregroundColor: Colors.white,
                            elevation: 10,
                            shadowColor: const Color(0x6658C72D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.play_arrow_rounded,
                                    size: 31,
                                  ),
                                  SizedBox(width: 7),
                                  Text(
                                    'PLAY',
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // CONTINUE
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: () => _continueGame(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFF151F3D),
                            side: const BorderSide(
                              color: Color(0x665B6CFF),
                              width: 1.3,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.play_circle_outline_rounded,
                                size: 25,
                                color: Color(0xFF7D8BFF),
                              ),
                              SizedBox(width: 9),
                              Text(
                                'CONTINUE',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.7,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'LEVEL $_lastLevel',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF9CA5C0),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // DAILY CHALLENGE
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: () => _showComingSoon(
                            context,
                            'Daily Challenge',
                            Icons.calendar_month_rounded,
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFF171A45),
                            side: const BorderSide(
                              color: Color(0x665B6CFF),
                              width: 1.3,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(17),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_month_rounded,
                                color: Color(0xFF9B6CFF),
                              ),
                              SizedBox(width: 9),
                              Text(
                                'DAILY CHALLENGE',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // LEVELS
                      _largeMenuButton(
                        icon: Icons.grid_view_rounded,
                        title: 'LEVELS',
                        subtitle: 'Choose your next puzzle',
                        iconColor: const Color(0xFF5B8CFF),
                        onTap: () => _openScreen(
                          context,
                          const LevelsScreen(),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // SHOP + REWARDS
                      Row(
                        children: [
                          Expanded(
                            child: _smallMenuButton(
                              icon: Icons.storefront_rounded,
                              title: 'SHOP',
                              iconColor: const Color(0xFFFFC928),
                              onTap: () => _openScreen(
                                context,
                                const ShopScreen(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _smallMenuButton(
                              icon: Icons.card_giftcard_rounded,
                              title: 'REWARDS',
                              iconColor: const Color(0xFFFF6D9B),
                              onTap: () => _openScreen(
                                context,
                                const RewardsScreen(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // BOTTOM NAVIGATION
              Container(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                decoration: const BoxDecoration(
                  color: Color(0xFF0D1429),
                  border: Border(
                    top: BorderSide(
                      color: Color(0x221FFFFF),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _bottomItem(
                        Icons.home_rounded,
                        'HOME',
                        onTap: () {},
                        active: true,
                      ),
                    ),
                    Expanded(
                      child: _bottomItem(
                        Icons.emoji_events_rounded,
                        'TROPHIES',
                        onTap: () => _openScreen(
                          context,
                          const TrophiesScreen(),
                        ),
                      ),
                    ),
                    Expanded(
                      child: _bottomItem(
                        Icons.bar_chart_rounded,
                        'STATS',
                        onTap: () => _openScreen(
                          context,
                          const StatsScreen(),
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
        ),
      ),
    );
  }

  void _openScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => screen,
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


// =========================================================
// STEP 4D — NAVIGATION SCREENS
// =========================================================

class LevelsScreen extends StatelessWidget {
  const LevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureScreen(
      title: 'LEVELS',
      subtitle: 'Choose your next puzzle',
      icon: Icons.grid_view_rounded,
      accent: Color(0xFF5B8CFF),
    );
  }
}

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureScreen(
      title: 'SHOP',
      subtitle: 'Power-ups and game items',
      icon: Icons.storefront_rounded,
      accent: Color(0xFFFFC928),
    );
  }
}

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureScreen(
      title: 'REWARDS',
      subtitle: 'Your rewards and achievements',
      icon: Icons.card_giftcard_rounded,
      accent: Color(0xFFFF6D9B),
    );
  }
}

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureScreen(
      title: 'STATS',
      subtitle: 'Track your puzzle progress',
      icon: Icons.bar_chart_rounded,
      accent: Color(0xFF6C7CFF),
    );
  }
}

class TrophiesScreen extends StatelessWidget {
  const TrophiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _FeatureScreen(
      title: 'TROPHIES',
      subtitle: 'Your trophies and achievements',
      icon: Icons.emoji_events_rounded,
      accent: Color(0xFFFFC928),
    );
  }
}

class _FeatureScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;

  const _FeatureScreen({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080D1D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1429),
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF101A3A),
              Color(0xFF080D1D),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 34,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF111A35),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Color(0x335B6CFF),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x335B6CFF),
                    blurRadius: 28,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 44,
                      color: accent,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF9CA5C0),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        foregroundColor: Colors.white,
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'BACK TO HOME',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.6,
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
