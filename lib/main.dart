
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
  const GamePlaceholderScreen({
    super.key,
    this.level = 1,
    this.resume = false,
  });

  final int level;
  final bool resume;

  @override
  State<GamePlaceholderScreen> createState() =>
      _GamePlaceholderScreenState();
}

enum ArrowDirection {
  up,
  down,
  left,
  right,
}

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
}

class _GamePlaceholderScreenState extends State<GamePlaceholderScreen> {
  static const int dotGridSize = 9;

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
    arrows = _buildLevel(widget.level);
    moves = 0;
  }

  ArrowTile _a(int row, int col, ArrowDirection direction) {
    return ArrowTile(
      row: row,
      col: col,
      direction: direction,
    );
  }

  List<ArrowTile> _buildLevel(int level) {
    switch (level) {
      case 1:
        return [
          _a(1, 1, ArrowDirection.right),
          _a(1, 4, ArrowDirection.left),
          _a(2, 4, ArrowDirection.down),
          _a(5, 4, ArrowDirection.up),
          _a(5, 2, ArrowDirection.right),
          _a(5, 7, ArrowDirection.left),
          _a(7, 2, ArrowDirection.up),
          _a(3, 2, ArrowDirection.down),
          _a(3, 6, ArrowDirection.left),
          _a(6, 6, ArrowDirection.up),
          _a(7, 7, ArrowDirection.left),
          _a(2, 7, ArrowDirection.down),
        ];

      case 2:
        return [
          _a(1, 1, ArrowDirection.right),
          _a(1, 3, ArrowDirection.right),
          _a(1, 7, ArrowDirection.left),
          _a(3, 2, ArrowDirection.down),
          _a(6, 2, ArrowDirection.up),
          _a(3, 5, ArrowDirection.down),
          _a(7, 5, ArrowDirection.up),
          _a(5, 7, ArrowDirection.left),
          _a(5, 4, ArrowDirection.right),
        ];

      case 3:
        return [
          _a(1, 1, ArrowDirection.down),
          _a(4, 1, ArrowDirection.up),
          _a(2, 3, ArrowDirection.right),
          _a(2, 7, ArrowDirection.left),
          _a(5, 3, ArrowDirection.down),
          _a(7, 3, ArrowDirection.up),
          _a(5, 6, ArrowDirection.right),
          _a(5, 8, ArrowDirection.left),
          _a(7, 7, ArrowDirection.up),
        ];

      case 4:
        return [
          _a(1, 1, ArrowDirection.right),
          _a(1, 5, ArrowDirection.left),
          _a(2, 2, ArrowDirection.down),
          _a(5, 2, ArrowDirection.up),
          _a(2, 6, ArrowDirection.down),
          _a(7, 6, ArrowDirection.up),
          _a(4, 3, ArrowDirection.right),
          _a(4, 7, ArrowDirection.left),
          _a(6, 1, ArrowDirection.right),
          _a(6, 5, ArrowDirection.left),
        ];

      case 5:
        return [
          _a(1, 1, ArrowDirection.down),
          _a(4, 1, ArrowDirection.up),
          _a(1, 4, ArrowDirection.right),
          _a(1, 7, ArrowDirection.left),
          _a(3, 3, ArrowDirection.down),
          _a(7, 3, ArrowDirection.up),
          _a(3, 6, ArrowDirection.down),
          _a(7, 6, ArrowDirection.up),
          _a(5, 2, ArrowDirection.right),
          _a(5, 7, ArrowDirection.left),
        ];

      case 6:
        return [
          _a(1, 1, ArrowDirection.right),
          _a(1, 4, ArrowDirection.right),
          _a(1, 7, ArrowDirection.left),
          _a(3, 2, ArrowDirection.down),
          _a(5, 2, ArrowDirection.up),
          _a(3, 5, ArrowDirection.down),
          _a(7, 5, ArrowDirection.up),
          _a(5, 7, ArrowDirection.left),
          _a(5, 4, ArrowDirection.right),
          _a(7, 7, ArrowDirection.up),
          _a(7, 1, ArrowDirection.right),
        ];

      case 7:
        return [
          _a(1, 2, ArrowDirection.down),
          _a(4, 2, ArrowDirection.up),
          _a(1, 5, ArrowDirection.right),
          _a(1, 7, ArrowDirection.left),
          _a(3, 3, ArrowDirection.down),
          _a(7, 3, ArrowDirection.up),
          _a(3, 6, ArrowDirection.down),
          _a(7, 6, ArrowDirection.up),
          _a(5, 1, ArrowDirection.right),
          _a(5, 5, ArrowDirection.left),
          _a(7, 8, ArrowDirection.left),
          _a(2, 8, ArrowDirection.down),
        ];

      case 8:
        return [
          _a(1, 1, ArrowDirection.right),
          _a(1, 3, ArrowDirection.right),
          _a(1, 7, ArrowDirection.left),
          _a(2, 2, ArrowDirection.down),
          _a(6, 2, ArrowDirection.up),
          _a(2, 5, ArrowDirection.down),
          _a(7, 5, ArrowDirection.up),
          _a(4, 7, ArrowDirection.left),
          _a(4, 4, ArrowDirection.right),
          _a(6, 7, ArrowDirection.up),
          _a(7, 1, ArrowDirection.right),
          _a(7, 4, ArrowDirection.left),
        ];

      case 9:
        return [
          _a(1, 1, ArrowDirection.down),
          _a(3, 1, ArrowDirection.down),
          _a(7, 1, ArrowDirection.up),
          _a(1, 3, ArrowDirection.right),
          _a(1, 7, ArrowDirection.left),
          _a(3, 4, ArrowDirection.down),
          _a(7, 4, ArrowDirection.up),
          _a(5, 7, ArrowDirection.left),
          _a(5, 3, ArrowDirection.right),
          _a(7, 7, ArrowDirection.up),
          _a(4, 5, ArrowDirection.down),
          _a(7, 5, ArrowDirection.up),
        ];

      case 10:
        return [
          _a(1, 1, ArrowDirection.right),
          _a(1, 4, ArrowDirection.right),
          _a(1, 7, ArrowDirection.left),
          _a(2, 2, ArrowDirection.down),
          _a(5, 2, ArrowDirection.up),
          _a(2, 5, ArrowDirection.down),
          _a(7, 5, ArrowDirection.up),
          _a(2, 7, ArrowDirection.down),
          _a(7, 7, ArrowDirection.up),
          _a(5, 1, ArrowDirection.right),
          _a(5, 4, ArrowDirection.right),
          _a(5, 7, ArrowDirection.left),
          _a(7, 1, ArrowDirection.right),
          _a(7, 4, ArrowDirection.left),
        ];

      default:
        return _buildLevel(((level - 1) % 10) + 1);
    }
  }

  bool _isBlockedBy(
    ArrowTile arrow,
    List<ArrowTile> list,
  ) {
    for (final other in list) {
      if (identical(other, arrow)) {
        continue;
      }

      if (!other.visible || other.moving) {
        continue;
      }

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

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();

    final removed = <String>[];

    for (int i = 0; i < arrows.length; i++) {
      if (!arrows[i].visible) {
        removed.add(i.toString());
      }
    }

    await prefs.setInt('arrow_progress_level', widget.level);
    await prefs.setStringList('arrow_progress_removed', removed);
    await prefs.setInt('arrow_progress_moves', moves);
    await prefs.setBool('arrow_progress_exists', true);
  }

  Future<void> _restoreProgress() async {
    final prefs = await SharedPreferences.getInstance();

    if (!(prefs.getBool('arrow_progress_exists') ?? false)) {
      return;
    }

    final savedLevel =
        prefs.getInt('arrow_progress_level') ?? widget.level;

    if (savedLevel != widget.level) {
      return;
    }

    final removed =
        prefs.getStringList('arrow_progress_removed') ?? <String>[];

    final savedMoves =
        prefs.getInt('arrow_progress_moves') ?? 0;

    if (!mounted) return;

    setState(() {
      for (final value in removed) {
        final index = int.tryParse(value);

        if (index != null && index >= 0 && index < arrows.length) {
          arrows[index].visible = false;
          arrows[index].moving = false;
        }
      }

      moves = savedMoves;
    });
  }

  Future<void> _tapArrow(ArrowTile arrow) async {
    if (!arrow.visible || arrow.moving) {
      return;
    }

    if (_isBlockedBy(arrow, arrows)) {
      setState(() {
        arrow.blocked = true;
      });

      await Future.delayed(const Duration(milliseconds: 180));

      if (!mounted) return;

      setState(() {
        arrow.blocked = false;
      });

      return;
    }

    setState(() {
      arrow.visible = false;
      arrow.moving = true;
      moves++;
    });

    await _saveProgress();

    await Future.delayed(const Duration(milliseconds: 420));

    if (!mounted) return;

    setState(() {
      arrow.moving = false;
    });

    if (arrows.every((a) => !a.visible && !a.moving)) {
      await Future.delayed(const Duration(milliseconds: 150));

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

    await prefs.setInt('last_level', widget.level + 1);

    await prefs.remove('arrow_progress_level');
    await prefs.remove('arrow_progress_removed');
    await prefs.remove('arrow_progress_moves');
    await prefs.setBool('arrow_progress_exists', false);
  }

  void _showLevelComplete() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text(
            '🎉 Level Complete!',
            textAlign: TextAlign.center,
          ),
          content: Text(
            'All arrows cleared!\n\nMoves: $moves',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _resetLevel();
              },
              child: const Text('REPLAY'),
            ),
            ElevatedButton(
              onPressed: () async {
                final navigator = Navigator.of(dialogContext);

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

  Color get _backgroundColor {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF080B12)
        : const Color(0xFFF7F7F9);
  }

  Color get _boardColor {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF11151F)
        : Colors.white;
  }

  Color get _dotColor {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF6B7280)
        : const Color(0xFFB9BDC7);
  }

  Color get _arrowColor {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : const Color(0xFF111827);
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: dark ? Colors.white : Colors.black87,
          ),
          onPressed: () async {
            final navigator = Navigator.of(context);

            await _saveProgress();

            if (!mounted) return;

            navigator.pop();
          },
        ),
        title: Text(
          'LEVEL ${widget.level}',
          style: TextStyle(
            color: dark ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Reset',
            onPressed: _resetLevel,
            icon: Icon(
              Icons.refresh_rounded,
              color: dark ? Colors.white : Colors.black87,
            ),
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
                  Icons.arrow_forward_rounded,
                  'Arrows',
                  '${arrows.where((a) => a.visible).length}',
                ),
              ],
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.all(20),
              child: AspectRatio(
                aspectRatio: 1,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final boardSize = constraints.maxWidth;

                    return Container(
                      decoration: BoxDecoration(
                        color: _boardColor,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: dark
                            ? null
                            : const [
                                BoxShadow(
                                  color: Color(0x16000000),
                                  blurRadius: 28,
                                  offset: Offset(0, 12),
                                ),
                              ],
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _DotBoardPainter(
                                gridSize: dotGridSize,
                                dotColor: _dotColor,
                              ),
                            ),
                          ),

                          for (int i = 0; i < arrows.length; i++)
                            if (arrows[i].visible || arrows[i].moving)
                              _buildArrow(
                                arrows[i],
                                i,
                                boardSize,
                              ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Tap an arrow only when its path is clear',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: dark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF697087),
                ),
              ),
            ),

            const SizedBox(height: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildArrow(
    ArrowTile arrow,
    int index,
    double boardSize,
  ) {
    final spacing = boardSize / (dotGridSize - 1);

    final x = arrow.col * spacing;
    final y = arrow.row * spacing;

    const hitSize = 58.0;

    return Positioned(
      left: x - hitSize / 2,
      top: y - hitSize / 2,
      width: hitSize,
      height: hitSize,
      child: TweenAnimationBuilder<double>(
        key: ValueKey('arrow-$index-${arrow.moving}'),
        tween: Tween<double>(
          begin: arrow.moving ? 0 : 1,
          end: 1,
        ),
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInCubic,
        builder: (context, progress, child) {
          final distance = boardSize + hitSize;

          final offset = switch (arrow.direction) {
            ArrowDirection.up => Offset(0, -distance * progress),
            ArrowDirection.down => Offset(0, distance * progress),
            ArrowDirection.left => Offset(-distance * progress, 0),
            ArrowDirection.right => Offset(distance * progress, 0),
          };

          return Transform.translate(
            offset: offset,
            child: child,
          );
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _tapArrow(arrow),
          child: AnimatedScale(
            scale: arrow.blocked ? 0.82 : 1,
            duration: const Duration(milliseconds: 100),
            child: Icon(
              _arrowIcon(arrow.direction),
              color: _arrowColor,
              size: 43,
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoCard(
    IconData icon,
    String title,
    String value,
  ) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF151B29) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: dark
            ? null
            : const [
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
            color: dark ? Colors.white : Colors.black87,
          ),
          const SizedBox(width: 6),
          Text(
            title,
            style: TextStyle(
              color: dark
                  ? const Color(0xFF9CA3AF)
                  : const Color(0xFF777E91),
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            value,
            style: TextStyle(
              color: dark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class _DotBoardPainter extends CustomPainter {
  _DotBoardPainter({
    required this.gridSize,
    required this.dotColor,
  });

  final int gridSize;
  final Color dotColor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    final spacing = size.width / (gridSize - 1);

    for (int row = 0; row < gridSize; row++) {
      for (int col = 0; col < gridSize; col++) {
        canvas.drawCircle(
          Offset(
            col * spacing,
            row * spacing,
          ),
          2.8,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DotBoardPainter oldDelegate) {
    return oldDelegate.gridSize != gridSize ||
        oldDelegate.dotColor != dotColor;
  }
}
