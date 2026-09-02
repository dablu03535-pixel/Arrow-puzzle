import 'dart:math' as math;
import 'dart:ui';
import 'package:webview_flutter/webview_flutter.dart';

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

class LevelsScreen extends StatefulWidget {
  const LevelsScreen({super.key});

  @override
  State<LevelsScreen> createState() => _LevelsScreenState();
}

class _LevelsScreenState extends State<LevelsScreen> {
  static const int _totalLevels = 16;

  // Step 5D: Difficulty selection foundation.
  String _selectedDifficulty = 'NORMAL';

  // Step 5A:
  // First five levels are available for the initial progression UI.
  // Gameplay-based unlocking will be connected later.
  // Step 5C: Level progression foundation.
  // Levels 1-5 are currently available.
  // Gameplay completion/unlocking will be connected later.
  final int _unlockedLevel = 5;

  final Map<int, int> _stars = {
    1: 3,
    2: 3,
    3: 2,
    4: 3,
    5: 2,
  };

  int get _completedLevels {
    return _stars.values.where((stars) => stars > 0).length;
  }

  double get _progress {
    return _completedLevels / _totalLevels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080D1D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1429),
        foregroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 18,
        title: const Text(
          'LEVELS',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: PopupMenuButton<String>(
              initialValue: _selectedDifficulty,
              tooltip: 'Difficulty',
              color: const Color(0xFF111A35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              onSelected: _selectDifficulty,
              itemBuilder: (context) => [
                _difficultyMenuItem(
                  'NORMAL',
                  Icons.grid_view_rounded,
                  true,
                ),
                _difficultyMenuItem(
                  'HARD',
                  Icons.local_fire_department_rounded,
                  false,
                ),
                _difficultyMenuItem(
                  'EXPERT',
                  Icons.bolt_rounded,
                  false,
                ),
              ],
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF151F3A),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0x332F3C62),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _difficultyIcon(_selectedDifficulty),
                      size: 17,
                      color: const Color(0xFF5B8CFF),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _selectedDifficulty,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(width: 3),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF8D97B0),
                      size: 17,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedDifficulty,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            _selectedDifficulty == 'NORMAL'
                                ? 'Choose your next puzzle'
                                : 'Difficulty coming soon',
                            style: TextStyle(
                              color: Color(0xFF9CA5C0),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF111A35),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0x335B6CFF),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFF58C72D),
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$_completedLevels / $_totalLevels',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),


              const SizedBox(height: 4),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    const Text(
                      'PROGRESS',
                      style: TextStyle(
                        color: Color(0xFF7F8CFF),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: _progress,
                          minHeight: 7,
                          backgroundColor: const Color(0xFF1B2542),
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(
                            Color(0xFF5B8CFF),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '${(_progress * 100).round()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 24),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.18,
                  ),
                  itemCount: _totalLevels,
                  itemBuilder: (context, index) {
                    final level = index + 1;
                    final unlocked = _isLevelUnlocked(level);
                    final stars = _starsForLevel(level);

                    return _levelCard(
                      context,
                      level: level,
                      unlocked: unlocked,
                      stars: stars,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<String> _difficultyMenuItem(
    String difficulty,
    IconData icon,
    bool available,
  ) {
    return PopupMenuItem<String>(
      value: difficulty,
      enabled: available,
      child: Row(
        children: [
          Icon(
            icon,
            size: 19,
            color: available
                ? const Color(0xFF5B8CFF)
                : const Color(0xFF596177),
          ),
          const SizedBox(width: 10),
          Text(
            difficulty,
            style: TextStyle(
              color: available
                  ? Colors.white
                  : const Color(0xFF596177),
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.6,
            ),
          ),
          const Spacer(),
          if (!available)
            const Icon(
              Icons.lock_rounded,
              size: 15,
              color: Color(0xFF596177),
            ),
        ],
      ),
    );
  }

  IconData _difficultyIcon(String difficulty) {
    switch (difficulty) {
      case 'HARD':
        return Icons.local_fire_department_rounded;
      case 'EXPERT':
        return Icons.bolt_rounded;
      default:
        return Icons.grid_view_rounded;
    }
  }

  void _selectDifficulty(String difficulty) {
    if (difficulty != 'NORMAL') {
      _showDifficultyLocked(difficulty);
      return;
    }

    if (_selectedDifficulty == difficulty) {
      return;
    }

    setState(() {
      _selectedDifficulty = difficulty;
    });
  }

  void _showDifficultyLocked(String difficulty) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF111A35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Row(
            children: [
              Icon(
                difficulty == 'HARD'
                    ? Icons.local_fire_department_rounded
                    : Icons.bolt_rounded,
                color: const Color(0xFF7F8CFF),
              ),
              const SizedBox(width: 10),
              Text(
                difficulty,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          content: const Text(
            'This difficulty will be unlocked in a future update.',
            style: TextStyle(
              color: Color(0xFFB5BDD0),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFF7F8CFF),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool _isLevelUnlocked(int level) {
    return level <= _unlockedLevel;
  }

  int _starsForLevel(int level) {
    return _stars[level] ?? 0;
  }

  String _levelStatus(int level) {
    if (!_isLevelUnlocked(level)) {
      return 'LOCKED';
    }

    final stars = _starsForLevel(level);

    if (stars >= 3) {
      return 'MASTERED';
    }

    if (stars > 0) {
      return 'COMPLETED';
    }

    return 'READY';
  }

  Color _levelStatusColor(int level) {
    if (!_isLevelUnlocked(level)) {
      return const Color(0xFF596177);
    }

    final stars = _starsForLevel(level);

    if (stars >= 3) {
      return const Color(0xFFFFC928);
    }

    if (stars > 0) {
      return const Color(0xFF58C72D);
    }

    return const Color(0xFF7F8CFF);
  }

  Widget _levelCard(
    BuildContext context, {
    required int level,
    required bool unlocked,
    required int stars,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: unlocked
            ? () => _openLevel(context, level)
            : null,
        child: Ink(
          decoration: BoxDecoration(
            color: unlocked
                ? const Color(0xFF111A35)
                : const Color(0xFF0D1328),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: unlocked
                  ? const Color(0x335B6CFF)
                  : const Color(0x221F2A48),
              width: unlocked ? 1.2 : 1,
            ),
            boxShadow: unlocked
                ? const [
                    BoxShadow(
                      color: Color(0x225B6CFF),
                      blurRadius: 18,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Stack(
            children: [
              Positioned(
                top: 12,
                right: 12,
                child: unlocked
                    ? const Icon(
                        Icons.play_circle_fill_rounded,
                        color: Color(0xFF5B8CFF),
                        size: 20,
                      )
                    : const Icon(
                        Icons.lock_rounded,
                        color: Color(0xFF4A536C),
                        size: 20,
                      ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$level',
                      style: TextStyle(
                        color: unlocked
                            ? Colors.white
                            : const Color(0xFF596177),
                        fontSize: 31,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        3,
                        (index) => Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 2),
                          child: Icon(
                            Icons.star_rounded,
                            size: 17,
                            color: index < stars
                                ? const Color(0xFFFFC928)
                                : const Color(0xFF343C55),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      _levelStatus(level),
                      style: TextStyle(
                        color: _levelStatusColor(level),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
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

  void _openLevel(BuildContext context, int level) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GamePlaceholderScreen(
          level: level,
          resume: false,
        ),
      ),
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
  const GamePlaceholderScreen({super.key, this.level = 1, this.resume = false});

  final int level;
  final bool resume;

  @override
  State<GamePlaceholderScreen> createState() => _GamePlaceholderScreenState();
}

class _GamePlaceholderScreenState extends State<GamePlaceholderScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFEEF0F6))
      ..loadFlutterAsset('assets/arrow-dot-game-42.html');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF0F6),
      body: SafeArea(child: WebViewWidget(controller: _controller)),
    );
  }
}

enum ArrowDirection { up, down, left, right }

class GridCell {
  const GridCell(this.row, this.col);

  final int row;
  final int col;
}

class ArrowPath {
  ArrowPath({
    required this.cells,
    required this.direction,
  });

  final List<GridCell> cells;
  ArrowDirection direction;

  bool active = true;
  bool bumping = false;
  bool penalized = false;
  bool hintGlow = false;
  bool hintStay = false;
}

class _GamePlaceholderScreenState extends State<GamePlaceholderScreen>
    with SingleTickerProviderStateMixin {
  static const double _boardSize = 300;
  static const int _maxLevel = 6;

  late List<ArrowPath> paths;
  late AnimationController _animationController;

  int? _animatedIndex;
  bool _exitAnimation = false;
  bool _showGrid = false;
  bool _redFlash = false;
  bool _levelOver = false;
  bool _gameWon = false;
  int _mistakes = 0;
  int _clickedCount = 0;
  int _totalArrows = 0;
  double _bumpDistance = 0;
  String _status = '';
  String _statusClass = 'status';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..addListener(() {
        if (mounted) setState(() {});
      });
    _buildBoard(_safeLevel(widget.level));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  int _safeLevel(int level) {
    if (level < 1) return 1;
    if (level > _maxLevel) return _maxLevel;
    return level;
  }

  int _gridForLevel(int level) {
    return 2 + level;
  }

  String _tierForLevel(int level) {
    if (level <= 2) return 'Easy';
    if (level <= 4) return 'Medium';
    return 'Hard';
  }



  GridCell _cell(int row, int col) => GridCell(row, col);

  ArrowPath _makePath(List<GridCell> cells, ArrowDirection direction) {
    return ArrowPath(cells: cells, direction: direction);
  }

  ArrowDirection _directionFromStep(int dr, int dc) {
    if (dr < 0) return ArrowDirection.up;
    if (dr > 0) return ArrowDirection.down;
    if (dc < 0) return ArrowDirection.left;
    return ArrowDirection.right;
  }

  GridCell _nextCell(GridCell cell, ArrowDirection direction) {
    switch (direction) {
      case ArrowDirection.up:
        return _cell(cell.row - 1, cell.col);
      case ArrowDirection.down:
        return _cell(cell.row + 1, cell.col);
      case ArrowDirection.left:
        return _cell(cell.row, cell.col - 1);
      case ArrowDirection.right:
        return _cell(cell.row, cell.col + 1);
    }
  }

  List<ArrowPath> _generatePaths(int n) {
    final visited = List.generate(n, (_) => List<bool>.filled(n, false));
    final result = <ArrowPath>[];
    final random = math.Random();

    for (int row = 0; row < n; row++) {
      for (int col = 0; col < n; col++) {
        if (visited[row][col]) continue;

        final cells = <GridCell>[_cell(row, col)];
        visited[row][col] = true;
        var currentRow = row;
        var currentCol = col;
        ArrowDirection? lastDirection;
        final maxLength = 2 + random.nextInt(4);

        while (cells.length < maxLength) {
          final dirs = <List<dynamic>>[
            [-1, 0, ArrowDirection.up],
            [1, 0, ArrowDirection.down],
            [0, -1, ArrowDirection.left],
            [0, 1, ArrowDirection.right],
          ];
          dirs.shuffle(random);

          var moved = false;
          for (final entry in dirs) {
            final dr = entry[0] as int;
            final dc = entry[1] as int;
            final direction = entry[2] as ArrowDirection;
            final nr = currentRow + dr;
            final nc = currentCol + dc;

            if (nr >= 0 && nr < n && nc >= 0 && nc < n && !visited[nr][nc]) {
              cells.add(_cell(nr, nc));
              visited[nr][nc] = true;
              currentRow = nr;
              currentCol = nc;
              lastDirection = direction;
              moved = true;
              break;
            }
          }

          if (!moved) break;
        }

        result.add(_makePath(cells, lastDirection ?? ArrowDirection.up));
      }
    }

    var changed = true;
    var guard = 0;
    while (changed && guard < result.length + 5) {
      changed = false;
      guard++;

      for (int i = result.length - 1; i >= 0; i--) {
        if (result[i].cells.length != 1) continue;

        final orphan = result[i].cells.first;
        var merged = false;

        for (int j = 0; j < result.length; j++) {
          if (j == i) continue;
          final target = result[j];
          final first = target.cells.first;
          final last = target.cells.last;

          if (_manhattan(first, orphan) == 1) {
            target.cells.insert(0, orphan);
            merged = true;
          } else if (_manhattan(last, orphan) == 1) {
            target.cells.add(orphan);
            targetDirectionUpdate(target);
            merged = true;
          }

          if (merged) break;
        }

        if (merged) {
          result.removeAt(i);
          changed = true;
        }
      }
    }

    return result;
  }

  void targetDirectionUpdate(ArrowPath target) {
    if (target.cells.length < 2) return;
    final last = target.cells[target.cells.length - 1];
    final previous = target.cells[target.cells.length - 2];
    target.direction = _directionFromStep(
      last.row - previous.row,
      last.col - previous.col,
    );
  }

  int _manhattan(GridCell a, GridCell b) {
    return (a.row - b.row).abs() + (a.col - b.col).abs();
  }

  bool _validatePaths(List<ArrowPath> candidate, int n) {
    final seen = <String>{};

    for (final path in candidate) {
      if (path.cells.isEmpty) return false;

      for (int i = 0; i < path.cells.length; i++) {
        final cell = path.cells[i];
        if (cell.row < 0 || cell.row >= n || cell.col < 0 || cell.col >= n) {
          return false;
        }

        final key = '${cell.row},${cell.col}';
        if (!seen.add(key)) return false;

        if (i > 0 && _manhattan(path.cells[i - 1], cell) != 1) {
          return false;
        }
      }
    }

    return seen.length == n * n;
  }

  Offset _directionVector(ArrowDirection direction) {
    switch (direction) {
      case ArrowDirection.up:
        return const Offset(0, -1);
      case ArrowDirection.down:
        return const Offset(0, 1);
      case ArrowDirection.left:
        return const Offset(-1, 0);
      case ArrowDirection.right:
        return const Offset(1, 0);
    }
  }

  bool _isBlockedFor(
    ArrowPath path,
    List<ArrowPath> allPaths,
    int n,
  ) {
    final head = path.cells.last;
    var current = _nextCell(head, path.direction);

    while (current.row >= 0 && current.row < n && current.col >= 0 && current.col < n) {
      for (final other in allPaths) {
        if (identical(other, path) || !other.active) continue;
        if (other.cells.any((cell) => cell.row == current.row && cell.col == current.col)) {
          return true;
        }
      }
      current = _nextCell(current, path.direction);
    }

    return false;
  }

  bool _isSolvable(List<ArrowPath> original, int n) {
    final simulation = original
        .map(
          (path) => ArrowPath(
            cells: List<GridCell>.from(path.cells),
            direction: path.direction,
          ),
        )
        .toList();

    var remaining = simulation.length;
    var progress = true;

    while (remaining > 0 && progress) {
      progress = false;
      for (final path in simulation) {
        if (!path.active) continue;
        if (!_isBlockedFor(path, simulation, n)) {
          path.active = false;
          remaining--;
          progress = true;
        }
      }
    }

    return remaining == 0;
  }

  List<ArrowPath> _straightColumnsFallback(int n) {
    return List<ArrowPath>.generate(n, (col) {
      final cells = <GridCell>[];
      for (int row = n - 1; row >= 0; row--) {
        cells.add(_cell(row, col));
      }
      return _makePath(cells, ArrowDirection.up);
    });
  }

  List<ArrowPath> _generateSolvableLevel(int n) {
    for (int attempt = 0; attempt < 250; attempt++) {
      final candidate = _generatePaths(n);
      if (_validatePaths(candidate, n) && _isSolvable(candidate, n)) {
        return candidate;
      }
    }
    return _straightColumnsFallback(n);
  }

  void _buildBoard(int level) {
    _animationController.reset();
    _animatedIndex = null;
    _exitAnimation = false;
    _showGrid = false;
    _redFlash = false;
    _levelOver = false;
    _gameWon = false;
    _mistakes = 0;
    _clickedCount = 0;

    final n = _gridForLevel(level);
    paths = _generateSolvableLevel(n);
    _totalArrows = paths.length;
    _status = '$_totalArrows arrows baaki hain';
    _statusClass = 'status';
  }

  double _spacing(int n) => _boardSize / (n + 1);

  double _freeSteps(ArrowPath path, int n) {
    final head = path.cells.last;
    var current = _nextCell(head, path.direction);
    var free = 0;

    while (current.row >= 0 && current.row < n && current.col >= 0 && current.col < n) {
      final occupied = paths.any(
        (other) =>
            other.active &&
            other.cells.any((cell) => cell.row == current.row && cell.col == current.col),
      );
      if (occupied) break;
      free++;
      current = _nextCell(current, path.direction);
    }

    return free.toDouble();
  }

  Future<void> _tapArrow(int index) async {
    if (_animatedIndex != null || _levelOver) return;

    final arrow = paths[index];
    if (!arrow.active || arrow.bumping) return;

    final n = _gridForLevel(_safeLevel(widget.level));

    if (_isBlockedFor(arrow, paths, n)) {
      await _runBump(index, n);
      return;
    }

    arrow.active = false;
    _clickedCount++;
    _status = '${_totalArrows - _clickedCount} arrows baaki hain';
    _statusClass = 'status';
    _exitAnimation = true;
    _showGrid = false;
    _animatedIndex = index;
    _animationController.duration = const Duration(milliseconds: 650);
    _animationController.reset();

    if (mounted) setState(() {});

    await _animationController.forward();

    if (!mounted) return;

    setState(() {
      _animatedIndex = null;
      _exitAnimation = false;
    });

    if (_clickedCount == _totalArrows) {
      _levelOver = true;
      await Future<void>.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;
      setState(() {
        _gameWon = true;
        _status = widget.level < _maxLevel
            ? '🎉 Level ${_safeLevel(widget.level)} Complete!'
            : '🏆 Sabhi Levels Complete!';
        _statusClass = 'win';
      });
    }
  }

  Future<void> _runBump(int index, int n) async {
    final arrow = paths[index];
    final firstPenalty = !arrow.penalized;
    arrow.bumping = true;
    arrow.penalized = true;
    _bumpDistance = _freeSteps(arrow, n) * _spacing(n) + _spacing(n) * 0.4;
    _animatedIndex = index;
    _exitAnimation = false;
    _animationController.duration = const Duration(milliseconds: 400);
    _animationController.reset();

    setState(() {
      _redFlash = true;
      if (firstPenalty) _mistakes++;
    });

    Future<void>.delayed(const Duration(milliseconds: 450)).then((_) {
      if (mounted) setState(() => _redFlash = false);
    });

    if (_mistakes >= 3) {
      _levelOver = true;
    }

    await _animationController.forward();

    if (!mounted) return;

    setState(() {
      arrow.bumping = false;
      _animatedIndex = null;
      _bumpDistance = 0;
    });

    if (_mistakes >= 3) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      _showOutOfLives();
    }
  }

  void _showOutOfLives() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          contentPadding: const EdgeInsets.fromLTRB(30, 28, 30, 24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('❤️', style: TextStyle(fontSize: 46)),
              const SizedBox(height: 8),
              const Text(
                'Out of Lives!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1C23),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    if (!mounted) return;
                    setState(() {
                      _mistakes = 0;
                      _levelOver = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B5BFF),
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Get More Lives'),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    if (!mounted) return;
                    setState(() {
                      _buildBoard(_safeLevel(widget.level));
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFEEF0F6),
                    foregroundColor: const Color(0xFF1A1C23),
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Restart Game'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showHint() {
    final n = _gridForLevel(_safeLevel(widget.level));
    ArrowPath? candidate;
    for (final path in paths) {
      if (path.active && !_isBlockedFor(path, paths, n) && !path.hintStay) {
        candidate = path;
        break;
      }
    }
    if (candidate == null) return;

    setState(() => candidate!.hintGlow = true);
    Future<void>.delayed(const Duration(milliseconds: 1800)).then((_) {
      if (!mounted) return;
      setState(() {
        candidate!.hintGlow = false;
        candidate.hintStay = true;
      });
    });
  }

  void _resetLevel() {
    setState(() => _buildBoard(_safeLevel(widget.level)));
  }

  void _nextLevel() {
    if (widget.level < _maxLevel) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => GamePlaceholderScreen(level: widget.level + 1),
        ),
      );
    } else {
      _resetLevel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final level = _safeLevel(widget.level);
    final n = _gridForLevel(level);
    final tier = _tierForLevel(level);

    return Scaffold(
      backgroundColor: const Color(0xFFEEF0F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF1A1C23),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Arrow Puzzle',
          style: TextStyle(
            color: Color(0xFF1A1C23),
            fontSize: 20,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final boardSize = math.min(
                  _boardSize,
                  math.min(constraints.maxWidth - 36, constraints.maxHeight - 240),
                ).toDouble();
                final safeBoard = math.max(230.0, boardSize).toDouble();

                return Center(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: tier == 'Easy'
                                    ? const Color(0xFFDFF5E6)
                                    : tier == 'Medium'
                                        ? const Color(0xFFFFF3D6)
                                        : const Color(0xFFFFE1E1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                tier.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                  color: tier == 'Easy'
                                      ? const Color(0xFF1A8F5E)
                                      : tier == 'Medium'
                                          ? const Color(0xFFB8860B)
                                          : const Color(0xFFD23838),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEF0F6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'Level $level',
                                style: const TextStyle(
                                  color: Color(0xFF1A1C23),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(3, (i) {
                            return AnimatedOpacity(
                              duration: const Duration(milliseconds: 250),
                              opacity: i < _mistakes ? 0.25 : 1,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3),
                                child: Text(
                                  '❤️',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Jis arrow ke aage koi arrow na ho, usi pe tap karo',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF6B7080),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: safeBoard,
                          height: safeBoard,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x18000000),
                                blurRadius: 22,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTapUp: (details) {
                              if (_animatedIndex != null || _levelOver) return;
                              _selectByPosition(
                                details.localPosition,
                                safeBoard,
                                n,
                              );
                            },
                            child: CustomPaint(
                              painter: _HtmlArrowPainter(
                                paths: paths,
                                gridSize: n,
                                showGrid: _showGrid,
                                animatedIndex: _animatedIndex,
                                exitAnimation: _exitAnimation,
                                progress: _animationController.value,
                                bumpDistance: _bumpDistance,
                              ),
                              size: Size.square(safeBoard),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _roundControl(
                              icon: Icons.lightbulb_outline_rounded,
                              active: false,
                              onTap: _showHint,
                            ),
                            const SizedBox(width: 14),
                            _roundControl(
                              icon: Icons.tag_rounded,
                              active: _showGrid,
                              onTap: () => setState(() => _showGrid = !_showGrid),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 160),
                          child: Text(
                            _status,
                            key: ValueKey(_status),
                            style: TextStyle(
                              color: _statusClass == 'win'
                                  ? const Color(0xFF1A8F5E)
                                  : _statusClass == 'fail'
                                      ? const Color(0xFFD23838)
                                      : const Color(0xFF6B7080),
                              fontSize: _statusClass == 'win' ? 16 : 13,
                              fontWeight: _statusClass == 'win'
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (_gameWon)
                          ElevatedButton(
                            onPressed: _nextLevel,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3B5BFF),
                              foregroundColor: Colors.white,
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
                                vertical: 10,
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              level < _maxLevel
                                  ? '➡️ Next Level'
                                  : '🔁 Restart from Level 1',
                            ),
                          ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          IgnorePointer(
            child: AnimatedOpacity(
              opacity: _redFlash ? 1 : 0,
              duration: const Duration(milliseconds: 40),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Color(0x00D23838),
                      Color(0x8CD23838),
                    ],
                    stops: [0.40, 1.0],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _roundControl({
    required IconData icon,
    required bool active,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: active ? const Color(0xFFEEF1FF) : Colors.white,
            border: Border.all(
              color: active
                  ? const Color(0xFF3B5BFF)
                  : const Color(0xFFD8DBE6),
              width: 1.5,
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color: active
                ? const Color(0xFF3B5BFF)
                : const Color(0xFF6B7080),
          ),
        ),
      ),
    );
  }

  void _selectByPosition(
    Offset localPosition,
    double boardSize,
    int n,
  ) {
    final spacing = boardSize / (n + 1);
    int? selected;
    var bestDistance = double.infinity;

    double distanceToSegment(Offset p, Offset a, Offset b) {
      final ab = b - a;
      final ab2 = ab.dx * ab.dx + ab.dy * ab.dy;
      if (ab2 == 0) return (p - a).distance;
      final ap = p - a;
      final t = ((ap.dx * ab.dx) + (ap.dy * ab.dy)) / ab2;
      final clamped = t.clamp(0.0, 1.0).toDouble();
      final nearest = Offset(
        a.dx + ab.dx * clamped,
        a.dy + ab.dy * clamped,
      );
      return (p - nearest).distance;
    }

    for (int i = 0; i < paths.length; i++) {
      final path = paths[i];
      if (!path.active || path.bumping) continue;

      final points = path.cells.map((cell) => Offset(
            (cell.col + 1) * spacing,
            (cell.row + 1) * spacing,
          )).toList();
      if (points.length == 1) {
        final direction = _directionVector(path.direction);
        points.insert(0, points.first - direction * (spacing * 0.4));
      }

      for (int j = 1; j < points.length; j++) {
        final distance = distanceToSegment(localPosition, points[j - 1], points[j]);
        if (distance < 24 && distance < bestDistance) {
          bestDistance = distance;
          selected = i;
        }
      }
    }

    if (selected != null) {
      _tapArrow(selected);
    }
  }
}

class _HtmlArrowPainter extends CustomPainter {
  _HtmlArrowPainter({
    required this.paths,
    required this.gridSize,
    required this.showGrid,
    required this.animatedIndex,
    required this.exitAnimation,
    required this.progress,
    required this.bumpDistance,
  });

  final List<ArrowPath> paths;
  final int gridSize;
  final bool showGrid;
  final int? animatedIndex;
  final bool exitAnimation;
  final double progress;
  final double bumpDistance;

  Offset _directionVector(ArrowDirection direction) {
    switch (direction) {
      case ArrowDirection.up:
        return const Offset(0, -1);
      case ArrowDirection.down:
        return const Offset(0, 1);
      case ArrowDirection.left:
        return const Offset(-1, 0);
      case ArrowDirection.right:
        return const Offset(1, 0);
    }
  }

  double _rotation(ArrowDirection direction) {
    switch (direction) {
      case ArrowDirection.up:
        return 0;
      case ArrowDirection.down:
        return math.pi;
      case ArrowDirection.left:
        return -math.pi / 2;
      case ArrowDirection.right:
        return math.pi / 2;
    }
  }

  Offset _point(GridCell cell, List<double> positions) {
    return Offset(positions[cell.col], positions[cell.row]);
  }

  void _drawHead(
    Canvas canvas,
    Offset tip,
    ArrowDirection direction,
    double headSize,
    Color color,
  ) {
    canvas.save();
    canvas.translate(tip.dx, tip.dy);
    canvas.rotate(_rotation(direction));

    final head = Path()
      ..moveTo(-headSize, headSize * 0.8)
      ..lineTo(headSize, headSize * 0.8)
      ..lineTo(0, -headSize)
      ..close();

    canvas.drawPath(
      head,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );
    canvas.restore();
  }

  Path _buildPointsPath(List<Offset> points) {
    final path = Path();
    for (int i = 0; i < points.length; i++) {
      if (i == 0) {
        path.moveTo(points[i].dx, points[i].dy);
      } else {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }
    return path;
  }

  double _pathLength(List<Offset> points) {
    var length = 0.0;
    for (int i = 1; i < points.length; i++) {
      length += (points[i] - points[i - 1]).distance;
    }
    return length;
  }

  Offset _pointAtDistance(PathMetric metric, double distance) {
    final tangent = metric.getTangentForOffset(
      distance.clamp(0.0, metric.length).toDouble(),
    );
    return tangent?.position ?? Offset.zero;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final spacing = size.width / (gridSize + 1);
    final positions = List<double>.generate(
      gridSize,
      (i) => spacing * (i + 1),
    );

    final dotSize = math.max(4.0, math.min(6.0, spacing * 0.12)).toDouble();
    final strokeWidth = math.max(3.0, math.min(7.0, spacing * 0.16)).toDouble();
    final headSize = strokeWidth * 1.9;

    final dotPaint = Paint()
      ..color = const Color(0xFFCDD1DD)
      ..style = PaintingStyle.fill;

    for (final x in positions) {
      for (final y in positions) {
        canvas.drawCircle(Offset(x, y), dotSize / 2, dotPaint);
      }
    }

    if (showGrid) {
      final guidePaint = Paint()
        ..color = const Color(0xFFC7D3FF)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;

      for (final path in paths) {
        if (!path.active) continue;
        final head = _point(path.cells.last, positions);
        final direction = _directionVector(path.direction);
        final edge = Offset(
          head.dx + direction.dx * size.width,
          head.dy + direction.dy * size.height,
        );
        canvas.drawLine(head, edge, guidePaint);
      }
    }

    for (int index = 0; index < paths.length; index++) {
      final pathData = paths[index];
      final isAnimated = animatedIndex == index;

      if (!pathData.active && !isAnimated) continue;

      final points = pathData.cells.map((cell) => _point(cell, positions)).toList();
      if (points.length == 1) {
        final direction = _directionVector(pathData.direction);
        final stub = spacing * 0.4;
        points.insert(0, points.first - direction * stub);
      }

      var color = const Color(0xFF141A30);
      if (pathData.penalized) color = const Color(0xFFD23838);
      if (pathData.hintStay || pathData.hintGlow) color = const Color(0xFF3B5BFF);

      if (isAnimated && exitAnimation) {
        final direction = _directionVector(pathData.direction);
        final head = points.last;
        final extPoint = head + direction * 1200;
        final fullPoints = [...points, extPoint];
        final fullPath = _buildPointsPath(fullPoints);
        final metric = fullPath.computeMetrics().first;
        final realLength = _pathLength(points);
        final t = progress.clamp(0.0, 1.0).toDouble();
        final eased = t * t;
        final dashStart = eased * metric.length;
        final leadStart = dashStart.clamp(0.0, metric.length).toDouble();
        final leadEnd = (dashStart + realLength).clamp(0.0, metric.length).toDouble();

        final segment = metric.extractPath(leadStart, leadEnd);
        final alpha = t > 0.7
            ? (1 - (t - 0.7) / 0.3).clamp(0.0, 1.0).toDouble()
            : 1.0;
        final paint = Paint()
          ..color = color.withValues(alpha: alpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;
        canvas.drawPath(segment, paint);

        final tip = _pointAtDistance(metric, leadEnd);
        _drawHead(canvas, tip, pathData.direction, headSize, color.withValues(alpha: alpha));
        continue;
      }

      var translation = Offset.zero;
      if (isAnimated && pathData.bumping) {
        final t = progress.clamp(0.0, 1.0).toDouble();
        final forward = t <= 0.425
            ? (t / 0.425)
            : (1 - (t - 0.425) / 0.575);
        final e = 1 - math.pow(1 - forward.clamp(0.0, 1.0), 2).toDouble();
        translation = _directionVector(pathData.direction) * bumpDistance * e;
      }

      final shifted = points.map((point) => point + translation).toList();
      final pathPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;

      canvas.drawPath(_buildPointsPath(shifted), pathPaint);

      final tip = shifted.last;
      _drawHead(canvas, tip, pathData.direction, headSize, color);
    }
  }

  @override
  bool shouldRepaint(covariant _HtmlArrowPainter oldDelegate) => true;
}
