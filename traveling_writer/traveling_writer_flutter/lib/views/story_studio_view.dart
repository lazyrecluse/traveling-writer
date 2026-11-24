import 'dart:async';
import 'package:flutter/material.dart';
import 'package:traveling_writer_client/traveling_writer_client.dart';
import '../models/chapter.dart';
import '../models/story.dart';
import '../services/continuity_event_bus.dart';
import '../theme/parchment_theme.dart';
import '../widgets/animated_accordion.dart';

class StoryStudioView extends StatefulWidget {
  final Client client;
  final List<Story> stories;
  final Story activeStory;
  final Function(Story) onActiveStoryChanged;
  final Function(String title, String synopsis) onAddStory;
  final Chapter? activeChapter;
  final Function(Chapter?) onActiveChapterChanged;
  final Function(String title) onAddChapter;
  final Function(Chapter) onDeleteChapter;
  final Future<void> Function(Chapter) onAuditRequested;
  final bool isAuditing;
  final VoidCallback onNavigateToWorldBible;
  final VoidCallback? onChapterContentChanged;

  const StoryStudioView({
    super.key,
    required this.client,
    required this.stories,
    required this.activeStory,
    required this.onActiveStoryChanged,
    required this.onAddStory,
    required this.activeChapter,
    required this.onActiveChapterChanged,
    required this.onAddChapter,
    required this.onDeleteChapter,
    required this.onAuditRequested,
    required this.isAuditing,
    required this.onNavigateToWorldBible,
    this.onChapterContentChanged,
  });

  @override
  State<StoryStudioView> createState() => _StoryStudioViewState();
}

class _StoryStudioViewState extends State<StoryStudioView> {
  bool _showAuditedView = false;
  late TextEditingController _editorController;
  bool _hideDiscoveredBanner = false;
  bool _hideAuditBanner = false;
  StreamSubscription<ContinuityEvent>? _eventSub;

  @override
  void initState() {
    super.initState();
    _editorController = TextEditingController(
      text: widget.activeChapter?.content ?? '',
    );
    _eventSub = ContinuityEventBus().stream.listen((event) {
      if (mounted) setState(() {});
    });
  }

  @override
  void didUpdateWidget(covariant StoryStudioView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activeChapter?.id != oldWidget.activeChapter?.id) {
      _editorController.text = widget.activeChapter?.content ?? '';
      _showAuditedView = false;
      _hideDiscoveredBanner = false;
      _hideAuditBanner = false;
    } else if (widget.activeChapter != null &&
        widget.activeChapter!.content != _editorController.text &&
        !_editorController.value.isComposingRangeValid) {
      _editorController.text = widget.activeChapter!.content;
    }

    if (widget.activeChapter?.auditResult != null &&
        oldWidget.activeChapter?.auditResult !=
            widget.activeChapter?.auditResult) {
      _showAuditedView = true;
      _hideAuditBanner = false;
    }
  }

  @override
  void dispose() {
    _eventSub?.cancel();
    _editorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.activeChapter == null) {
      return _buildChaptersShelfView();
    }
    return _buildChapterEditorView();
  }

  // ==========================================
  // CHAPTERS SHELF (LANDING PREVIEW VIEW)
  // ==========================================
  Widget _buildChaptersShelfView() {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final chapters = widget.activeStory.chapters;
    final totalWords = widget.activeStory.totalWords;
    final conflictChapters = widget.activeStory.conflictCount;

    return Stack(
      children: [
        Container(
          color: ParchmentTheme.background,
          child: CustomScrollView(
            slivers: [
              // Header & Story Switcher
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 32,
                    vertical: isMobile ? 16 : 24,
                  ),
                  decoration: const BoxDecoration(
                    color: ParchmentTheme.cardBg,
                    border: Border(
                        bottom: BorderSide(color: ParchmentTheme.cardBorder)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Story Switcher Bar
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: _showStorySwitcherDialog,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: ParchmentTheme.background,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: ParchmentTheme.primaryUmber
                                          .withOpacity(0.4)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.book,
                                        size: 18,
                                        color: ParchmentTheme.primaryUmber),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        widget.activeStory.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: ParchmentTheme.primaryUmber,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.arrow_drop_down,
                                        color: ParchmentTheme.primaryUmber),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: ParchmentTheme.primaryUmber,
                              side: const BorderSide(
                                  color: ParchmentTheme.primaryUmber),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                            onPressed: _showCreateStoryDialog,
                            icon: const Icon(Icons.add, size: 16),
                            label: Text(isMobile ? 'Story' : '+ New Story'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          const Icon(Icons.library_books,
                              color: ParchmentTheme.primaryUmber, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            'Chapters in "${widget.activeStory.title}"',
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontSize: isMobile ? 18 : 20,
                              fontWeight: FontWeight.bold,
                              color: ParchmentTheme.inkDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Select a chapter preview below to open the drafting editor. All chapters in this story share the parent World Bible.',
                        style: TextStyle(
                          fontSize: isMobile ? 13 : 14,
                          color: ParchmentTheme.inkMuted,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildStatChip(
                            icon: Icons.article_outlined,
                            label: '${chapters.length} Chapters',
                            color: ParchmentTheme.primaryUmber,
                          ),
                          _buildStatChip(
                            icon: Icons.format_quote_outlined,
                            label: '$totalWords Words',
                            color: ParchmentTheme.inkDark,
                          ),
                          if (conflictChapters > 0)
                            _buildStatChip(
                              icon: Icons.warning_amber_rounded,
                              label: '$conflictChapters Chapter with Conflicts',
                              color: ParchmentTheme.alertText,
                              bgColor: ParchmentTheme.alertBg,
                            )
                          else
                            _buildStatChip(
                              icon: Icons.check_circle_outline,
                              label: 'All Audited Chapters Consistent',
                              color: ParchmentTheme.consistentText,
                              bgColor: ParchmentTheme.consistentBg,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Chapters Grid / List
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 14 : 32,
                  vertical: 20,
                ),
                sliver: chapters.isEmpty
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: Column(
                              children: [
                                const Icon(Icons.auto_stories_outlined,
                                    size: 48, color: Colors.grey),
                                const SizedBox(height: 12),
                                const Text(
                                  'No chapters in this story yet.',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Tap the "+" button below to write Chapter 1.',
                                  style:
                                      TextStyle(color: ParchmentTheme.inkMuted),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : (isMobile
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) =>
                                  _buildChapterCard(chapters[index]),
                              childCount: chapters.length,
                            ),
                          )
                        : SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 460,
                              mainAxisExtent: 240,
                              crossAxisSpacing: 18,
                              mainAxisSpacing: 18,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) =>
                                  _buildChapterCard(chapters[index]),
                              childCount: chapters.length,
                            ),
                          )),
              ),

              // Bottom padding
              const SliverToBoxAdapter(
                child: SizedBox(height: 80),
              ),
            ],
          ),
        ),

        // Floating '+' Icon for starting a new chapter (Bottom-Right)
        Positioned(
          bottom: isMobile ? 16 : 24,
          right: isMobile ? 16 : 24,
          child: FloatingActionButton.extended(
            backgroundColor: ParchmentTheme.primaryUmber,
            foregroundColor: Colors.white,
            elevation: 4,
            icon: const Icon(Icons.add, size: 22),
            label: Text(
              isMobile ? 'New Chapter' : 'Start New Chapter',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onPressed: _showCreateChapterDialog,
          ),
        ),
      ],
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required Color color,
    Color? bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterCard(Chapter chapter) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    Color borderColor = ParchmentTheme.cardBorder;
    Color statusBgColor = Colors.grey.shade100;
    Color statusTextColor = ParchmentTheme.inkMuted;
    String statusText = 'Draft (Not Audited)';
    IconData statusIcon = Icons.edit_note;

    if (chapter.isConflicting) {
      borderColor = ParchmentTheme.alertBorder;
      statusBgColor = ParchmentTheme.alertBg;
      statusTextColor = ParchmentTheme.alertText;
      statusText = '${chapter.conflictCount} Lore Conflict(s)';
      statusIcon = Icons.warning_amber_rounded;
    } else if (chapter.isConsistent) {
      borderColor = ParchmentTheme.consistentBorder;
      statusBgColor = ParchmentTheme.consistentBg;
      statusTextColor = ParchmentTheme.consistentText;
      statusText = 'Canon Consistent';
      statusIcon = Icons.check_circle_outline;
    }

    final excerpt = chapter.content.trim().isNotEmpty
        ? chapter.content.trim().replaceAll('\n', ' ')
        : 'Empty chapter draft. Click to start writing your prose...';

    return Container(
      margin: isMobile ? const EdgeInsets.only(bottom: 14) : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: borderColor, width: chapter.isConflicting ? 1.8 : 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => widget.onActiveChapterChanged(chapter),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: ParchmentTheme.background,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: ParchmentTheme.cardBorder),
                    ),
                    child: Text(
                      '${chapter.wordCount} words',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: ParchmentTheme.inkMuted,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ParchmentTheme.background.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: ParchmentTheme.cardBorder.withOpacity(0.5)),
                  ),
                  child: Text(
                    excerpt,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'serif',
                      fontSize: 13,
                      height: 1.5,
                      color: ParchmentTheme.inkDark,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(statusIcon, size: 14, color: statusTextColor),
                        const SizedBox(width: 5),
                        Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: statusTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (widget.activeStory.chapters.length > 1)
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          size: 18, color: Colors.grey),
                      tooltip: 'Delete Chapter',
                      onPressed: () => _confirmDeleteChapter(chapter),
                    ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Open',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: ParchmentTheme.primaryUmber,
                        ),
                      ),
                      Icon(Icons.arrow_forward,
                          size: 14, color: ParchmentTheme.primaryUmber),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // FULL CHAPTER EDITOR VIEW
  // ==========================================
  Widget _buildChapterEditorView() {
    final chapter = widget.activeChapter!;
    final isMobile = MediaQuery.of(context).size.width < 600;
    final unreviewedDiscovered =
        chapter.discoveredRules.where((r) => !r.isReviewed).toList();
    final unreviewedEntities =
        chapter.discoveredEntities.where((e) => !e.isReviewed).toList();
    final totalDiscovered =
        unreviewedDiscovered.length + unreviewedEntities.length;

    return Column(
      children: [
        // Editor Toolbar
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 20,
            vertical: isMobile ? 8 : 10,
          ),
          decoration: const BoxDecoration(
            color: ParchmentTheme.cardBg,
            border:
                Border(bottom: BorderSide(color: ParchmentTheme.cardBorder)),
          ),
          child: Column(
            children: [
              // Back Button & Chapter Title Row
              Row(
                children: [
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: ParchmentTheme.inkDark,
                      side: const BorderSide(color: ParchmentTheme.cardBorder),
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 8 : 12,
                        vertical: isMobile ? 6 : 8,
                      ),
                    ),
                    onPressed: () => widget.onActiveChapterChanged(null),
                    icon: const Icon(Icons.arrow_back, size: 16),
                    label: Text(isMobile ? 'Chapters' : '← Chapters'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () => _showEditTitleDialog(chapter),
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              chapter.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'serif',
                                fontSize: isMobile ? 15 : 17,
                                fontWeight: FontWeight.bold,
                                color: ParchmentTheme.inkDark,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.edit_outlined,
                              size: 15, color: ParchmentTheme.inkMuted),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: ParchmentTheme.background,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: ParchmentTheme.cardBorder),
                    ),
                    child: Text(
                      '${chapter.wordCount} words',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: ParchmentTheme.inkMuted,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Mode Switcher & Audit Button
              isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: SegmentedButton<bool>(
                            segments: const [
                              ButtonSegment(
                                value: false,
                                label: Text('Draft'),
                                icon: Icon(Icons.edit_note, size: 16),
                              ),
                              ButtonSegment(
                                value: true,
                                label: Text('Inspector'),
                                icon: Icon(Icons.verified_outlined, size: 16),
                              ),
                            ],
                            selected: {_showAuditedView},
                            onSelectionChanged: (val) {
                              setState(() => _showAuditedView = val.first);
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: ParchmentTheme.primaryUmber,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: widget.isAuditing
                              ? null
                              : () => widget.onAuditRequested(chapter),
                          icon: widget.isAuditing
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.auto_fix_high, size: 18),
                          label: Text(widget.isAuditing
                              ? 'Auditing Lore...'
                              : 'Audit Continuity'),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        SegmentedButton<bool>(
                          segments: const [
                            ButtonSegment(
                              value: false,
                              label: Text('Drafting Canvas'),
                              icon: Icon(Icons.edit_note, size: 18),
                            ),
                            ButtonSegment(
                              value: true,
                              label: Text('Continuity Inspector'),
                              icon: Icon(Icons.verified_outlined, size: 18),
                            ),
                          ],
                          selected: {_showAuditedView},
                          onSelectionChanged: (val) {
                            setState(() => _showAuditedView = val.first);
                          },
                        ),
                        const Spacer(),
                        FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: ParchmentTheme.primaryUmber,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: widget.isAuditing
                              ? null
                              : () => widget.onAuditRequested(chapter),
                          icon: widget.isAuditing
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.auto_fix_high, size: 18),
                          label: Text(widget.isAuditing
                              ? 'Auditing Lore...'
                              : 'Audit Continuity'),
                        ),
                      ],
                    ),
            ],
          ),
        ),

        // Unintrusive Discovered Lore Banner (with Dismiss button)
        if (totalDiscovered > 0 && !_hideDiscoveredBanner)
          _buildDiscoveredRulesBanner(totalDiscovered),

        // Result Summary Header (if audited) with Dismiss button
        if (chapter.auditResult != null && !_hideAuditBanner)
          _buildAuditBanner(chapter.auditResult!),

        // Main Editor Area
        Expanded(
          child: _showAuditedView
              ? _buildAuditedParagraphs(chapter)
              : _buildDraftingCanvas(chapter),
        ),
      ],
    );
  }

  Widget _buildDiscoveredRulesBanner(int count) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: const Color(0xFFFFF7E6),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: Color(0xFFD97706), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$count potential lore item(s) (rules/entities) discovered in this draft.',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF92400E),
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFB45309),
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            onPressed: widget.onNavigateToWorldBible,
            child: const Text(
              'Review in World Bible →',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16, color: Color(0xFFB45309)),
            tooltip: 'Dismiss badge',
            onPressed: () => setState(() => _hideDiscoveredBanner = true),
          ),
        ],
      ),
    );
  }

  // Dismissable Compliance & Conflict Banner
  Widget _buildAuditBanner(AuditResult res) {
    final isGood = res.isConsistent;
    final hasViolations = res.violations.isNotEmpty;
    final isError = !isGood && !hasViolations;

    final bgColor = isGood
        ? ParchmentTheme.consistentBg
        : (isError ? const Color(0xFFFFFBEB) : ParchmentTheme.alertBg);
    final borderColor = isGood
        ? ParchmentTheme.consistentBorder
        : (isError ? const Color(0xFFFDE68A) : ParchmentTheme.alertBorder);
    final textColor = isGood
        ? ParchmentTheme.consistentText
        : (isError ? const Color(0xFFB45309) : ParchmentTheme.alertText);
    final iconData = isGood
        ? Icons.check_circle_outline
        : (isError ? Icons.info_outline : Icons.warning_amber_rounded);

    final titleText = isGood
        ? '✓ Conflict Resolved: Canon Consistent!'
        : (isError
            ? '⚠️ Audit Inconclusive'
            : '${res.violations.length} Lore Violation(s) Detected');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(
          bottom: BorderSide(
            color: borderColor,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            color: textColor,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  res.summary,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: textColor.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.close,
              size: 18,
              color: textColor,
            ),
            tooltip: 'Dismiss compliance banner',
            onPressed: () => setState(() => _hideAuditBanner = true),
          ),
        ],
      ),
    );
  }

  Widget _buildDraftingCanvas(Chapter chapter) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Container(
      color: ParchmentTheme.background,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: isMobile ? 14 : 24,
      ),
      child: TextField(
        controller: _editorController,
        maxLines: null,
        expands: true,
        onChanged: (text) {
          chapter.content = text;
          chapter.lastEdited = DateTime.now();
          widget.onChapterContentChanged?.call();
        },
        style: TextStyle(
          fontSize: isMobile ? 15 : 17,
          height: 1.8,
          color: ParchmentTheme.inkDark,
          fontFamily: 'serif',
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText:
              'Write or paste your chapter prose here...\n\nClick "Audit Continuity" above to verify that your story does not contradict any world rules or character traits.',
          hintStyle: TextStyle(
            color: ParchmentTheme.inkMuted,
            fontFamily: 'serif',
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildAuditedParagraphs(Chapter chapter) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final story = chapter.content;
    final paragraphs = story
        .split(RegExp(r'\n\s*\n|\r\n\s*\r\n'))
        .where((p) => p.trim().isNotEmpty)
        .toList();

    if (paragraphs.isEmpty) {
      return const Center(
        child: Text(
          'No story text found. Switch back to Drafting Canvas to write.',
          style: TextStyle(color: ParchmentTheme.inkMuted),
        ),
      );
    }

    final violationsByPara = <int, List<ContinuityViolation>>{};
    if (chapter.auditResult != null) {
      for (final v in chapter.auditResult!.violations) {
        violationsByPara.putIfAbsent(v.paragraphIndex, () => []).add(v);
      }
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 32,
        vertical: isMobile ? 14 : 24,
      ),
      itemCount: paragraphs.length,
      itemBuilder: (context, i) {
        final paraText = paragraphs[i];
        final violations = violationsByPara[i] ?? [];
        final hasViolation = violations.isNotEmpty;

        return Card(
          margin: const EdgeInsets.only(bottom: 20),
          color: hasViolation ? ParchmentTheme.alertBg : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: hasViolation
                  ? ParchmentTheme.alertBorder
                  : ParchmentTheme.cardBorder,
              width: hasViolation ? 1.5 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: hasViolation
                            ? ParchmentTheme.alertText.withOpacity(0.12)
                            : Colors.black.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Paragraph ${i + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: hasViolation
                              ? ParchmentTheme.alertText
                              : ParchmentTheme.inkMuted,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (hasViolation) ...[
                      const Icon(Icons.error_outline,
                          size: 16, color: ParchmentTheme.alertText),
                      const SizedBox(width: 4),
                      Text(
                        '${violations.length} Canon Violation(s)',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: ParchmentTheme.alertText,
                        ),
                      ),
                    ] else ...[
                      const Icon(Icons.check,
                          size: 16, color: ParchmentTheme.consistentText),
                      const SizedBox(width: 4),
                      const Text(
                        'Canon Consistent',
                        style: TextStyle(
                          fontSize: 12,
                          color: ParchmentTheme.consistentText,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  paraText,
                  style: const TextStyle(
                    fontSize: 16.5,
                    height: 1.7,
                    fontFamily: 'serif',
                    color: ParchmentTheme.inkDark,
                  ),
                ),
                if (hasViolation) ...[
                  const SizedBox(height: 16),
                  const Divider(color: ParchmentTheme.alertBorder),
                  const SizedBox(height: 8),
                  ...violations.map((v) => _buildViolationDetailCard(v)),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildViolationDetailCard(ContinuityViolation v) {
    return AnimatedAccordion(
      initiallyExpanded: true,
      backgroundColor: Colors.white,
      expandedBorderColor: ParchmentTheme.alertBorder,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      header: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: ParchmentTheme.alertText,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'RULE BROKEN',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              v.brokenRule,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13.5,
                color: ParchmentTheme.inkDark,
              ),
            ),
          ),
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Offending snippet: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: ParchmentTheme.inkMuted,
                  ),
                ),
                TextSpan(
                  text: '"${v.textSnippet}"',
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: ParchmentTheme.alertText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            v.explanation,
            style: const TextStyle(
              fontSize: 13,
              color: ParchmentTheme.inkDark,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  void _showStorySwitcherDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ParchmentTheme.background,
        title: const Text('Switch Active Story'),
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
                    '${story.chapters.length} chapters • ${story.totalWords} words'),
                trailing: story.hasConflict
                    ? const Icon(Icons.warning_amber_rounded,
                        color: ParchmentTheme.alertText, size: 18)
                    : null,
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
          FilledButton.icon(
            style: FilledButton.styleFrom(
                backgroundColor: ParchmentTheme.primaryUmber),
            onPressed: () {
              Navigator.pop(ctx);
              _showCreateStoryDialog();
            },
            icon: const Icon(Icons.add, size: 16),
            label: const Text('New Story'),
          ),
        ],
      ),
    );
  }

  void _showCreateStoryDialog() {
    final titleCtrl = TextEditingController();
    final synopCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ParchmentTheme.background,
        title: const Text('Create New Story Project'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Story Title',
                hintText: 'e.g. The Silverwood Chronicles',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: synopCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Premise / Synopsis',
                hintText: 'A tale of forbidden magic and ancient vows...',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: ParchmentTheme.primaryUmber),
            onPressed: () {
              final title = titleCtrl.text.trim();
              if (title.isNotEmpty) {
                Navigator.pop(ctx);
                widget.onAddStory(title, synopCtrl.text.trim());
              }
            },
            child: const Text('Create Story'),
          ),
        ],
      ),
    );
  }

  void _showCreateChapterDialog() {
    final titleCtrl = TextEditingController(
      text: 'Chapter ${widget.activeStory.chapters.length + 1}: Untitled',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ParchmentTheme.background,
        title: const Text('Start New Chapter'),
        content: TextField(
          controller: titleCtrl,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Chapter Title',
            hintText: 'e.g. Chapter 2: The Moonlit Path',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: ParchmentTheme.primaryUmber,
            ),
            onPressed: () {
              final title = titleCtrl.text.trim();
              if (title.isNotEmpty) {
                Navigator.pop(ctx);
                widget.onAddChapter(title);
              }
            },
            child: const Text('Create & Open'),
          ),
        ],
      ),
    );
  }

  void _showEditTitleDialog(Chapter chapter) {
    final titleCtrl = TextEditingController(text: chapter.title);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ParchmentTheme.background,
        title: const Text('Rename Chapter'),
        content: TextField(
          controller: titleCtrl,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Chapter Title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: ParchmentTheme.primaryUmber,
            ),
            onPressed: () {
              final newTitle = titleCtrl.text.trim();
              if (newTitle.isNotEmpty) {
                setState(() => chapter.title = newTitle);
                widget.onChapterContentChanged?.call();
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteChapter(Chapter chapter) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ParchmentTheme.background,
        title: const Text('Delete Chapter?'),
        content: Text(
            'Are you sure you want to delete "${chapter.title}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(ctx);
              widget.onDeleteChapter(chapter);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
