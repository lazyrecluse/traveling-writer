import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:traveling_writer_client/traveling_writer_client.dart';
import '../models/chapter.dart';
import '../models/story.dart';
import '../services/continuity_event_bus.dart';
import '../theme/parchment_theme.dart';

class PlotGraphView extends StatefulWidget {
  final Client client;
  final List<Story> stories;
  final Story activeStory;
  final Function(Story) onActiveStoryChanged;
  final Function(Chapter) onSelectChapter;
  final VoidCallback onDataChanged;
  final int? activeWorldId;

  const PlotGraphView({
    super.key,
    required this.client,
    required this.stories,
    required this.activeStory,
    required this.onActiveStoryChanged,
    required this.onSelectChapter,
    required this.onDataChanged,
    this.activeWorldId,
  });

  @override
  State<PlotGraphView> createState() => _PlotGraphViewState();
}

class _PlotGraphViewState extends State<PlotGraphView>
    with SingleTickerProviderStateMixin {
  // View mode: 'graph' (2D interactive canvas) or 'timeline' (linear feed)
  bool _isGraphMode = true;

  // Animation controller for pulsing radar warning rings on conflicting chapters
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Local map of node positions for draggable canvas
  final Map<String, Offset> _nodePositions = {};

  // Currently selected node for quick inspector panel
  Chapter? _inspectedChapter;

  // Event bus subscription for cross-tab reactivity
  StreamSubscription<ContinuityEvent>? _eventSub;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.28).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _initNodePositions();

    // Listen to real-time continuity events across tabs
    _eventSub = ContinuityEventBus().stream.listen((event) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void didUpdateWidget(covariant PlotGraphView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activeStory.id != oldWidget.activeStory.id ||
        widget.activeStory.chapters.length !=
            oldWidget.activeStory.chapters.length) {
      _initNodePositions();
    }
  }

  @override
  void dispose() {
    _eventSub?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _initNodePositions() {
    final chapters = widget.activeStory.chapters;
    for (var i = 0; i < chapters.length; i++) {
      final ch = chapters[i];
      if (!_nodePositions.containsKey(ch.id)) {
        // Arrange sequentially along an S-curve across the 2D plane
        final col = i % 3;
        final row = i ~/ 3;
        final x = 120.0 + (col * 320.0) + (row.isOdd ? 80.0 : 0.0);
        final y = 140.0 + (row * 240.0);
        _nodePositions[ch.id] = Offset(x, y);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final chapters = widget.activeStory.chapters;
    final conflicting = chapters.where((c) => c.isConflicting).toList();
    final consistent = chapters.where((c) => c.isConsistent).toList();
    final drafts = chapters.where((c) => c.isDraft).toList();
    final accentColor =
        ParchmentTheme.getAccentColorForGenre(widget.activeStory.genre);

    return Container(
      color: ParchmentTheme.background,
      child: Column(
        children: [
          // Dynamic Header & Controls
          _buildHeaderBar(conflicting, consistent, drafts, accentColor),

          // Main View Body: 2D Interactive Draggable Graph OR Linear Timeline
          Expanded(
            child: _isGraphMode
                ? _buildInteractiveCanvas(chapters, accentColor)
                : _buildLinearTimeline(chapters),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderBar(
    List<Chapter> conflicting,
    List<Chapter> consistent,
    List<Chapter> drafts,
    Color accentColor,
  ) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 24,
        vertical: 12,
      ),
      decoration: const BoxDecoration(
        color: ParchmentTheme.cardBg,
        border: Border(bottom: BorderSide(color: ParchmentTheme.cardBorder)),
      ),
      child: Row(
        children: [
          // Story Switcher
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: _showStorySwitcherDialog,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: accentColor.withOpacity(0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.book, size: 16, color: accentColor),
                  const SizedBox(width: 8),
                  Text(
                    widget.activeStory.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_drop_down, size: 18, color: accentColor),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Health Summary Badges
          if (!isMobile) ...[
            _buildMiniBadge(
              label: '${widget.activeStory.chapters.length} Chapters',
              color: ParchmentTheme.inkDark,
              bgColor: Colors.white,
            ),
            const SizedBox(width: 8),
            _buildMiniBadge(
              label: '${conflicting.length} Conflicts',
              color: ParchmentTheme.alertText,
              bgColor: ParchmentTheme.alertBg,
              isAlert: conflicting.isNotEmpty,
            ),
            const SizedBox(width: 8),
            _buildMiniBadge(
              label: '${consistent.length} Verified',
              color: ParchmentTheme.consistentText,
              bgColor: ParchmentTheme.consistentBg,
            ),
          ],

          const Spacer(),

          // Graph / Timeline View Mode Switcher
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: ParchmentTheme.cardBorder),
            ),
            padding: const EdgeInsets.all(2),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildModeTabButton(
                  icon: Icons.hub,
                  label: 'Spatial Graph',
                  isSelected: _isGraphMode,
                  onTap: () => setState(() => _isGraphMode = true),
                  accentColor: accentColor,
                ),
                _buildModeTabButton(
                  icon: Icons.view_timeline,
                  label: 'Timeline',
                  isSelected: !_isGraphMode,
                  onTap: () => setState(() => _isGraphMode = false),
                  accentColor: accentColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeTabButton({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color accentColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? accentColor : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.white : ParchmentTheme.inkMuted,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : ParchmentTheme.inkMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniBadge({
    required String label,
    required Color color,
    required Color bgColor,
    bool isAlert = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: isAlert ? 1.5 : 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: isAlert ? FontWeight.bold : FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // INTERACTIVE 2D DRAGGABLE SPATIAL CANVAS
  // ---------------------------------------------------------------------------

  Widget _buildInteractiveCanvas(List<Chapter> chapters, Color accentColor) {
    if (chapters.isEmpty) {
      return const Center(
        child: Text(
          'No chapters drafted yet. Open Story Studio to begin your first chronicle.',
          style: TextStyle(fontFamily: 'serif', color: ParchmentTheme.inkMuted),
        ),
      );
    }

    return Stack(
      children: [
        // Pan & Zoom Canvas
        InteractiveViewer(
          boundaryMargin: const EdgeInsets.all(1200),
          minScale: 0.4,
          maxScale: 2.2,
          constrained: false,
          child: SizedBox(
            width: 2200,
            height: 1600,
            child: Stack(
              children: [
                // Glowing Curved Connection Links between sequential chapters
                CustomPaint(
                  size: const Size(2200, 1600),
                  painter: _GraphConnectionsPainter(
                    chapters: chapters,
                    nodePositions: _nodePositions,
                    accentColor: accentColor,
                  ),
                ),

                // Draggable Nodes
                ...chapters.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final chapter = entry.value;
                  final pos = _nodePositions[chapter.id] ??
                      Offset(120.0 + idx * 260.0, 140.0);

                  return Positioned(
                    left: pos.dx,
                    top: pos.dy,
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        setState(() {
                          _nodePositions[chapter.id] = Offset(
                            pos.dx + details.delta.dx,
                            pos.dy + details.delta.dy,
                          );
                        });
                      },
                      onTap: () {
                        setState(() {
                          _inspectedChapter = chapter;
                        });
                      },
                      child: _buildDraggableNodeCard(
                        chapter,
                        idx + 1,
                        chapter.id == _inspectedChapter?.id,
                        accentColor,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),

        // Quick Node Inspector Card (Overlaid when a node is tapped)
        if (_inspectedChapter != null)
          Positioned(
            right: 20,
            bottom: 20,
            child: _buildInspectedNodeOverlay(_inspectedChapter!, accentColor),
          ),
      ],
    );
  }

  Widget _buildDraggableNodeCard(
    Chapter chapter,
    int sequence,
    bool isSelected,
    Color accentColor,
  ) {
    final isConflicting = chapter.isConflicting;
    final isConsistent = chapter.isConsistent;

    Color nodeBg = isConflicting
        ? ParchmentTheme.alertBg
        : (isConsistent ? ParchmentTheme.consistentBg : Colors.white);
    Color borderColor = isConflicting
        ? ParchmentTheme.alertBorder
        : (isConsistent
            ? ParchmentTheme.consistentBorder
            : ParchmentTheme.cardBorder);

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        // Pulsing radar glow for conflicting nodes
        final pulseScale = isConflicting ? _pulseAnimation.value : 1.0;

        return Transform.scale(
          scale: isSelected ? 1.04 : 1.0,
          child: Container(
            width: 240,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: nodeBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: borderColor,
                width: isConflicting ? 2.4 : (isSelected ? 2.0 : 1.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: isConflicting
                      ? Colors.red.withOpacity(0.24 * pulseScale)
                      : Colors.black.withOpacity(0.06),
                  blurRadius: isConflicting ? 16 * pulseScale : 8,
                  spreadRadius: isConflicting ? 3 * (pulseScale - 1.0) : 0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Act $sequence',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              ),
              const Spacer(),
              if (chapter.isConflicting)
                const Icon(Icons.warning_amber_rounded,
                    size: 16, color: ParchmentTheme.alertText)
              else if (chapter.isConsistent)
                const Icon(Icons.check_circle,
                    size: 16, color: ParchmentTheme.consistentText)
              else
                const Icon(Icons.edit_note,
                    size: 16, color: ParchmentTheme.inkMuted),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            chapter.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'serif',
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: ParchmentTheme.inkDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            chapter.content.isNotEmpty
                ? chapter.content.trim().replaceAll('\n', ' ')
                : 'Empty chapter...',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              color: ParchmentTheme.inkMuted,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '${chapter.wordCount} words',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: ParchmentTheme.inkMuted,
                ),
              ),
              const Spacer(),
              const Icon(Icons.open_with, size: 12, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInspectedNodeOverlay(Chapter chapter, Color accentColor) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ParchmentTheme.cardBorder, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  chapter.title,
                  style: const TextStyle(
                    fontFamily: 'serif',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: ParchmentTheme.inkDark,
                  ),
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.close, size: 18),
                onPressed: () => setState(() => _inspectedChapter = null),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: chapter.isConflicting
                  ? ParchmentTheme.alertBg
                  : (chapter.isConsistent
                      ? ParchmentTheme.consistentBg
                      : ParchmentTheme.cardBg),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              chapter.isConflicting
                  ? '⚠️ Lore Conflict Flagged'
                  : (chapter.isConsistent
                      ? '✓ Canon Consistent'
                      : 'Drafting Phase'),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: chapter.isConflicting
                    ? ParchmentTheme.alertText
                    : (chapter.isConsistent
                        ? ParchmentTheme.consistentText
                        : ParchmentTheme.inkMuted),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            chapter.content.isNotEmpty
                ? chapter.content.trim()
                : 'No prose drafted yet.',
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: ParchmentTheme.inkDark),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: chapter.isConflicting
                    ? ParchmentTheme.alertText
                    : accentColor,
              ),
              onPressed: () {
                widget.onSelectChapter(chapter);
              },
              icon: const Icon(Icons.edit_note, size: 16),
              label: const Text('Open in Story Studio →'),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LINEAR TIMELINE FEED
  // ---------------------------------------------------------------------------

  Widget _buildLinearTimeline(List<Chapter> chapters) {
    if (chapters.isEmpty) {
      return const Center(
        child: Text('No chapters in this timeline.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      itemCount: chapters.length,
      itemBuilder: (context, i) {
        final chapter = chapters[i];
        final isLast = i == chapters.length - 1;

        return Column(
          children: [
            _buildTimelineCard(chapter, i + 1),
            if (!isLast) _buildTimelineConnector(),
          ],
        );
      },
    );
  }

  Widget _buildTimelineCard(Chapter chapter, int seq) {
    final isConflicting = chapter.isConflicting;
    final isConsistent = chapter.isConsistent;

    Color cardBorder = isConflicting
        ? ParchmentTheme.alertBorder
        : (isConsistent
            ? ParchmentTheme.consistentBorder
            : ParchmentTheme.cardBorder);
    Color cardBg = isConflicting
        ? ParchmentTheme.alertBg
        : (isConsistent ? ParchmentTheme.consistentBg : Colors.white);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 820),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: cardBorder,
          width: isConflicting ? 2.2 : 1.2,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Act $seq: ${chapter.title}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const Spacer(),
              Text('${chapter.wordCount} words',
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
              chapter.content.isNotEmpty ? chapter.content.trim() : 'Draft...'),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: () => widget.onSelectChapter(chapter),
              icon: const Icon(Icons.edit_note, size: 16),
              label: const Text('Edit Chapter'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineConnector() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        children: [
          Container(
              width: 2,
              height: 16,
              color: ParchmentTheme.primaryUmber.withOpacity(0.3)),
          Icon(Icons.keyboard_arrow_down,
              size: 18, color: ParchmentTheme.primaryUmber.withOpacity(0.5)),
          Container(
              width: 2,
              height: 16,
              color: ParchmentTheme.primaryUmber.withOpacity(0.3)),
        ],
      ),
    );
  }

  void _showStorySwitcherDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ParchmentTheme.cardBg,
        title: const Text('Switch Story Timeline'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.stories.map((story) {
              final isSelected = story.id == widget.activeStory.id;
              return ListTile(
                leading: Icon(
                  isSelected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: ParchmentTheme.primaryUmber,
                ),
                title: Text(
                  story.title,
                  style: TextStyle(
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: ParchmentTheme.inkDark,
                  ),
                ),
                subtitle: Text(
                    '${story.chapters.length} chapters • ${story.conflictCount} conflicts'),
                onTap: () {
                  Navigator.pop(ctx);
                  widget.onActiveStoryChanged(story);
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// GLOWING BEZIER CONNECTIONS PAINTER
// -----------------------------------------------------------------------------

class _GraphConnectionsPainter extends CustomPainter {
  final List<Chapter> chapters;
  final Map<String, Offset> nodePositions;
  final Color accentColor;

  _GraphConnectionsPainter({
    required this.chapters,
    required this.nodePositions,
    required this.accentColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (chapters.length < 2) return;

    for (var i = 0; i < chapters.length - 1; i++) {
      final fromCh = chapters[i];
      final toCh = chapters[i + 1];

      final fromPos = nodePositions[fromCh.id];
      final toPos = nodePositions[toCh.id];
      if (fromPos == null || toPos == null) continue;

      // Center of right edge of start card -> Center of left edge of target card
      final start = Offset(fromPos.dx + 240, fromPos.dy + 55);
      final end = Offset(toPos.dx, toPos.dy + 55);

      final path = Path();
      path.moveTo(start.dx, start.dy);

      final dx = (end.dx - start.dx).abs();
      final controlPoint1 = Offset(start.dx + math.max(60, dx * 0.4), start.dy);
      final controlPoint2 = Offset(end.dx - math.max(60, dx * 0.4), end.dy);

      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        end.dx,
        end.dy,
      );

      final isContradiction = fromCh.isConflicting || toCh.isConflicting;
      final connectionColor = isContradiction
          ? ParchmentTheme.alertBorder
          : accentColor.withOpacity(0.4);

      // Glow backdrop
      final glowPaint = Paint()
        ..color = isContradiction
            ? Colors.red.withOpacity(0.18)
            : accentColor.withOpacity(0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6.0;
      canvas.drawPath(path, glowPaint);

      // Core bezier line
      final linePaint = Paint()
        ..color = connectionColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4;
      canvas.drawPath(path, linePaint);

      // Draw directional midpoint arrow
      final midPoint = Offset((start.dx + end.dx) / 2, (start.dy + end.dy) / 2);
      final arrowPaint = Paint()
        ..color = isContradiction ? ParchmentTheme.alertText : accentColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(midPoint, 4, arrowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _GraphConnectionsPainter oldDelegate) => true;
}
