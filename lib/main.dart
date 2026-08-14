
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
                      onTap: () => _showComingSoon(
                        context,
                        'Settings',
                        Icons.settings_rounded,
                      ),
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
                    onPressed: () async {
                        await Future.delayed(
                          const Duration(milliseconds: 120),
                        );
                        if (context.mounted) {
                          _startGame(context);
                        }
                      },
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
                    onPressed: () => _showComingSoon(
                      context,
                      'Daily Challenge',
                      Icons.calendar_month_rounded,
                    ),
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
                    children: [
                      Expanded(
                        child: _bottomItem(
                          Icons.grid_view_rounded,
                          'Levels',
                          onTap: () => _showComingSoon(
                            context,
                            'Levels',
                            Icons.grid_view_rounded,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _bottomItem(
                          Icons.card_giftcard_rounded,
                          'Rewards',
                          onTap: () => _showComingSoon(
                            context,
                            'Rewards',
                            Icons.card_giftcard_rounded,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _bottomItem(
                          Icons.emoji_events_rounded,
                          'Stats',
                          onTap: () => _showComingSoon(
                            context,
                            'Stats',
                            Icons.emoji_events_rounded,
                          ),
                        ),
                      ),
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

  static Widget _bottomItem(
    IconData icon,
    String label, {
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 7,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
            ),
          ),
        ),
      ),
    );
  }
}


class GamePlaceholderScreen extends StatefulWidget {
  const GamePlaceholderScreen({super.key});

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
  }

  void _createLevel() {
    final level = <ArrowTile>[
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

    // Never allow an unsolvable level to enter the game.
    if (!_isLevelSolvable(level)) {
      throw StateError('Level 1 is not solvable.');
    }

    arrows = level;
    moves = 0;
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
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
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

  Offset _exitOffset(
    ArrowTile arrow,
    double cellSize,
    double boardSize,
  ) {
    final left = boardPadding +
        arrow.col * (cellSize + cellGap);

    final top = boardPadding +
        arrow.row * (cellSize + cellGap);

    // Move exactly from the arrow's current cell
    // until the complete arrow crosses the 5x5 board boundary.
    switch (arrow.direction) {
      case ArrowDirection.up:
        return Offset(
          0,
          -(top + cellSize) * arrow.exitProgress,
        );

      case ArrowDirection.down:
        return Offset(
          0,
          (boardSize - top) * arrow.exitProgress,
        );

      case ArrowDirection.left:
        return Offset(
          -(left + cellSize) * arrow.exitProgress,
          0,
        );

      case ArrowDirection.right:
        return Offset(
          (boardSize - left) * arrow.exitProgress,
          0,
        );
    }
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
          onPressed: () => Navigator.pop(context),
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
                                              ..translate(5.0, 0.0))
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
