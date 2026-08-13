
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
}

class _GamePlaceholderScreenState extends State<GamePlaceholderScreen>
    with TickerProviderStateMixin {
  static const int gridSize = 5;

  late List<ArrowTile> arrows;

  int moves = 0;
  bool levelCompleted = false;

  @override
  void initState() {
    super.initState();
    _createLevel();
  }

  void _createLevel() {
    arrows = [
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
      ArrowTile(row: 1, col: 4, direction: ArrowDirection.down),
      ArrowTile(row: 3, col: 4, direction: ArrowDirection.up),
    ];

    moves = 0;
    levelCompleted = false;
  }

  List<ArrowTile> _activeArrows() {
    return arrows.where((a) => a.visible).toList();
  }

  bool _isBlocked(ArrowTile arrow) {
    for (final other in _activeArrows()) {
      if (identical(other, arrow)) continue;
      if (other.moving) continue;

      switch (arrow.direction) {
        case ArrowDirection.up:
          if (other.col == arrow.col && other.row < arrow.row) {
            return true;
          }
          break;

        case ArrowDirection.down:
          if (other.col == arrow.col && other.row > arrow.row) {
            return true;
          }
          break;

        case ArrowDirection.left:
          if (other.row == arrow.row && other.col < arrow.col) {
            return true;
          }
          break;

        case ArrowDirection.right:
          if (other.row == arrow.row && other.col > arrow.col) {
            return true;
          }
          break;
      }
    }

    return false;
  }

  Future<void> _tapArrow(ArrowTile arrow) async {
    if (!mounted || !arrow.visible || arrow.moving || levelCompleted) {
      return;
    }

    if (_isBlocked(arrow)) {
      setState(() {
        arrow.blocked = true;
      });

      await Future.delayed(const Duration(milliseconds: 100));

      if (!mounted) return;

      setState(() {
        arrow.blocked = false;
      });

      return;
    }

    setState(() {
      arrow.moving = true;
      moves++;
    });

    // Arrow moves outside the board.
    await Future.delayed(const Duration(milliseconds: 420));

    if (!mounted) return;

    setState(() {
      arrow.visible = false;
      arrow.moving = false;
    });

    // Check whether all arrows are gone.
    if (_activeArrows().isEmpty) {
      await Future.delayed(const Duration(milliseconds: 250));

      if (!mounted) return;

      setState(() {
        levelCompleted = true;
      });

      _showLevelComplete();
    }
  }

  void _resetLevel() {
    setState(() {
      _createLevel();
    });
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
            '🎉 LEVEL COMPLETE!',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.celebration_rounded,
                size: 70,
                color: Color(0xFFFFB300),
              ),
              const SizedBox(height: 14),
              const Text(
                'All arrows cleared!',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Moves: $moves',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _resetLevel();
              },
              child: const Text('REPLAY'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
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

  Color _arrowColor(ArrowDirection direction) {
    switch (direction) {
      case ArrowDirection.up:
        return const Color(0xFF7B4DFF);
      case ArrowDirection.down:
        return const Color(0xFF43B02A);
      case ArrowDirection.left:
        return const Color(0xFFE53935);
      case ArrowDirection.right:
        return const Color(0xFFFFA000);
    }
  }

  double _outsideX(ArrowTile arrow) {
    switch (arrow.direction) {
      case ArrowDirection.left:
        return -1.4;
      case ArrowDirection.right:
        return gridSize + 0.4;
      case ArrowDirection.up:
      case ArrowDirection.down:
        return arrow.col.toDouble();
    }
  }

  double _outsideY(ArrowTile arrow) {
    switch (arrow.direction) {
      case ArrowDirection.up:
        return -1.4;
      case ArrowDirection.down:
        return gridSize + 0.4;
      case ArrowDirection.left:
      case ArrowDirection.right:
        return arrow.row.toDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    final remaining = _activeArrows().length;

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
            fontWeight: FontWeight.w900,
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
                  'MOVES',
                  '$moves',
                ),
                const SizedBox(width: 12),
                _infoCard(
                  Icons.keyboard_arrow_up_rounded,
                  'ARROWS',
                  '$remaining',
                ),
              ],
            ),

            const SizedBox(height: 18),

            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final boardSize = constraints.maxWidth;
                        final gap = 7.0;
                        final cellSize =
                            (boardSize - gap * (gridSize - 1)) / gridSize;

                        return Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E2742),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x30000000),
                                blurRadius: 25,
                                offset: Offset(0, 12),
                              ),
                            ],
                          ),
                          child: ClipRect(
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                // Empty board cells.
                                for (int index = 0;
                                    index < gridSize * gridSize;
                                    index++)
                                  Positioned(
                                    left: (index % gridSize) *
                                        (cellSize + gap),
                                    top: (index ~/ gridSize) *
                                        (cellSize + gap),
                                    width: cellSize,
                                    height: cellSize,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF11192D),
                                        borderRadius:
                                            BorderRadius.circular(13),
                                        border: Border.all(
                                          color: const Color(0x182F3B5C),
                                        ),
                                      ),
                                    ),
                                  ),

                                // Arrow tiles.
                                for (final arrow in arrows)
                                  if (arrow.visible)
                                    AnimatedPositioned(
                                      duration: const Duration(
                                        milliseconds: 420,
                                      ),
                                      curve: Curves.easeIn,
                                      left: arrow.moving
                                          ? _outsideX(arrow) *
                                              (cellSize + gap)
                                          : arrow.col *
                                              (cellSize + gap),
                                      top: arrow.moving
                                          ? _outsideY(arrow) *
                                              (cellSize + gap)
                                          : arrow.row *
                                              (cellSize + gap),
                                      width: cellSize,
                                      height: cellSize,
                                      child: GestureDetector(
                                        onTap: () => _tapArrow(arrow),
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 100,
                                          ),
                                          curve: Curves.easeOut,
                                          transform: arrow.blocked
                                              ? (Matrix4.identity()
                                                ..translate(5.0, 0.0))
                                              : Matrix4.identity(),
                                          decoration: BoxDecoration(
                                            color: _arrowColor(
                                              arrow.direction,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            boxShadow: [
                                              BoxShadow(
                                                color: _arrowColor(
                                                  arrow.direction,
                                                ).withOpacity(0.45),
                                                blurRadius:
                                                    arrow.moving ? 18 : 8,
                                                offset:
                                                    const Offset(0, 5),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Icon(
                                              _arrowIcon(arrow.direction),
                                              color: Colors.white,
                                              size: cellSize * 0.48,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                remaining == 0
                    ? 'Puzzle complete!'
                    : 'Tap a free arrow to move it out',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF697087),
                ),
              ),
            ),

            const SizedBox(height: 20),
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
              fontWeight: FontWeight.w900,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
