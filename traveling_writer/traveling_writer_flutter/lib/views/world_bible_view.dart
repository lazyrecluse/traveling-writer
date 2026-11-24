import 'dart:async';
import 'package:flutter/material.dart';
import 'package:traveling_writer_client/traveling_writer_client.dart';
import '../models/chapter.dart';
import '../services/continuity_event_bus.dart';
import '../theme/parchment_theme.dart';
import '../widgets/animated_accordion.dart';

class WorldBibleView extends StatefulWidget {
  final Client client;
  final int? activeWorldId;
  final VoidCallback onDataChanged;
  final List<DiscoveredRule> discoveredRules;
  final List<DiscoveredEntity> discoveredEntities;
  final Function(DiscoveredRule) onAcceptDiscoveredRule;
  final Function(DiscoveredRule) onDismissDiscoveredRule;
  final Function(DiscoveredEntity) onAcceptDiscoveredEntity;
  final Function(DiscoveredEntity) onDismissDiscoveredEntity;
  final int initialTabIndex;

  const WorldBibleView({
    super.key,
    required this.client,
    this.activeWorldId,
    required this.onDataChanged,
    required this.discoveredRules,
    required this.discoveredEntities,
    required this.onAcceptDiscoveredRule,
    required this.onDismissDiscoveredRule,
    required this.onAcceptDiscoveredEntity,
    required this.onDismissDiscoveredEntity,
    this.initialTabIndex = 0,
  });

  @override
  State<WorldBibleView> createState() => _WorldBibleViewState();
}

class _WorldBibleViewState extends State<WorldBibleView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<WorldEntity> _entities = [];
  List<WorldRule> _rules = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';
  StreamSubscription<ContinuityEvent>? _eventSub;

  final List<String> _categories = [
    'All',
    'Character',
    'Magic & Physics',
    'Faction',
    'Artifact'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTabIndex.clamp(0, 2),
    );
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
    _loadData();

    // Listen to real-time events across workspaces
    _eventSub = ContinuityEventBus().stream.listen((event) {
      if (!mounted) return;
      if (event.worldId == null || event.worldId == widget.activeWorldId) {
        if (event.type == ContinuityEventType.loreCreated ||
            event.type == ContinuityEventType.loreDeleted ||
            event.type == ContinuityEventType.loreUpdated ||
            event.type == ContinuityEventType.worldSwitched) {
          _loadData();
        }
      }
    });
  }

  @override
  void didUpdateWidget(covariant WorldBibleView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTabIndex != oldWidget.initialTabIndex) {
      _tabController.animateTo(widget.initialTabIndex.clamp(0, 2));
    }
    if (widget.activeWorldId != oldWidget.activeWorldId) {
      _loadData();
    }
  }

  @override
  void dispose() {
    _eventSub?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final entities = await widget.client.continuity
          .listEntities(worldId: widget.activeWorldId);
      final rules = await widget.client.continuity
          .listRules(worldId: widget.activeWorldId);
      setState(() {
        _entities = entities;
        _rules = rules;
        _isLoading = false;
      });
      widget.onDataChanged();
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: ParchmentTheme.primaryUmber),
      );
    }

    final isMobile = MediaQuery.of(context).size.width < 600;
    final totalDiscovered =
        widget.discoveredRules.length + widget.discoveredEntities.length;

    return Column(
      children: [
        // Sub-tabs: Entities vs Rules vs Discovered
        Container(
          color: ParchmentTheme.cardBg,
          padding: EdgeInsets.symmetric(horizontal: isMobile ? 8 : 16),
          child: Row(
            children: [
              Expanded(
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: ParchmentTheme.primaryUmber,
                  labelColor: ParchmentTheme.primaryUmber,
                  unselectedLabelColor: ParchmentTheme.inkMuted,
                  isScrollable: isMobile,
                  tabAlignment: isMobile ? TabAlignment.start : null,
                  tabs: [
                    Tab(
                      icon: const Icon(Icons.people_outline, size: 18),
                      text: isMobile
                          ? 'Entities (${_entities.length})'
                          : 'Entities & Characters (${_entities.length})',
                    ),
                    Tab(
                      icon: const Icon(Icons.gavel_outlined, size: 18),
                      text: isMobile
                          ? 'Rules (${_rules.length})'
                          : 'Canon Rules & Laws (${_rules.length})',
                    ),
                    Tab(
                      icon: const Icon(Icons.auto_awesome, size: 18),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isMobile ? 'Discovered' : 'Discovered from Prose',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (totalDiscovered > 0) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD97706),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$totalDiscovered',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (_tabController.index != 2) ...[
                if (isMobile)
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: ParchmentTheme.primaryUmber,
                    ),
                    tooltip:
                        _tabController.index == 0 ? 'Add Entity' : 'Add Rule',
                    onPressed: () {
                      if (_tabController.index == 0) {
                        _showAddEntityDialog();
                      } else {
                        _showAddRuleDialog();
                      }
                    },
                    icon: const Icon(Icons.add, color: Colors.white, size: 20),
                  )
                else
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: ParchmentTheme.primaryUmber,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      if (_tabController.index == 0) {
                        _showAddEntityDialog();
                      } else {
                        _showAddRuleDialog();
                      }
                    },
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(
                        _tabController.index == 0 ? 'Add Entity' : 'Add Rule'),
                  ),
              ],
            ],
          ),
        ),

        // Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildEntitiesTab(),
              _buildRulesTab(),
              _buildDiscoveredLoreTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEntitiesTab() {
    final filtered = _selectedCategory == 'All'
        ? _entities
        : _entities.where((e) => e.category == _selectedCategory).toList();

    return Column(
      children: [
        // Category Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(12),
          child: Row(
            children: _categories.map((cat) {
              final isSelected = _selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(cat),
                  selected: isSelected,
                  selectedColor: ParchmentTheme.primaryUmber.withOpacity(0.15),
                  checkmarkColor: ParchmentTheme.primaryUmber,
                  labelStyle: TextStyle(
                    color: isSelected
                        ? ParchmentTheme.primaryUmber
                        : ParchmentTheme.inkDark,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  onSelected: (val) => setState(() => _selectedCategory = cat),
                ),
              );
            }).toList(),
          ),
        ),

        // List of Entities
        Expanded(
          child: filtered.isEmpty
              ? _buildEmptyState('No entities in this category yet.')
              : ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final e = filtered[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: ParchmentTheme.secondaryBronze
                                        .withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    e.category.toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: ParchmentTheme.primaryUmber,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    e.name,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: ParchmentTheme.inkDark,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline,
                                      size: 20, color: Colors.grey),
                                  onPressed: () => _deleteEntity(e.id!),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(e.description),
                            if (e.traits != null && e.traits!.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 6,
                                runSpacing: 6,
                                children: e.traits!.map((t) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: ParchmentTheme.cardBorder),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '• $t',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: ParchmentTheme.inkMuted),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildRulesTab() {
    return _rules.isEmpty
        ? _buildEmptyState('No canon rules defined yet.')
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _rules.length,
            itemBuilder: (context, i) {
              final r = _rules[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ParchmentTheme.primaryUmber.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '#${i + 1}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ParchmentTheme.primaryUmber,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  r.subject,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: ParchmentTheme.inkDark,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.06),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    r.relation,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: ParchmentTheme.primaryUmber,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              r.constraint,
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (r.explanation != null &&
                                r.explanation!.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                r.explanation!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: ParchmentTheme.inkMuted,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline,
                            size: 20, color: Colors.grey),
                        onPressed: () => _deleteRule(r.id!),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  // ==========================================
  // DISCOVERED LORE TAB (ENTITIES + RULES)
  // ==========================================
  Widget _buildDiscoveredLoreTab() {
    final rules = widget.discoveredRules;
    final entities = widget.discoveredEntities;
    final totalItems = rules.length + entities.length;

    if (totalItems == 0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.auto_awesome, size: 52, color: Color(0xFFD97706)),
              SizedBox(height: 16),
              Text(
                'No New Lore Discovered Yet',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: ParchmentTheme.inkDark,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'As you write chapters in Story Studio, our engine extracts newly introduced characters, factions, magical relics, and constraints (e.g. "Lord Morvath", "Sunstone", "cannot touch silver").\n\nThey will appear here for you to confirm which ones were intentional additions to Canon.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.5,
                  color: ParchmentTheme.inkMuted,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Intro Notice
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7E6),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFDE68A)),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline,
                  color: Color(0xFFB45309), size: 20),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Review candidate entities and rules identified from your drafts. Accepting an item adds it to the official World Bible database so all future audits enforce it.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF92400E)),
                ),
              ),
            ],
          ),
        ),

        // Section 1: Discovered Entities (Characters, Artifacts, Factions)
        if (entities.isNotEmpty) ...[
          Row(
            children: [
              const Icon(Icons.person_add_alt,
                  size: 18, color: ParchmentTheme.primaryUmber),
              const SizedBox(width: 8),
              Text(
                'Discovered Entities (${entities.length})',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: 'serif'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...entities.map((e) => _buildDiscoveredEntityCard(e)),
          const SizedBox(height: 20),
        ],

        // Section 2: Discovered Rules & Constraints
        if (rules.isNotEmpty) ...[
          Row(
            children: [
              const Icon(Icons.gavel,
                  size: 18, color: ParchmentTheme.primaryUmber),
              const SizedBox(width: 8),
              Text(
                'Discovered Rules & Constraints (${rules.length})',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    fontFamily: 'serif'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...rules.map((r) => _buildDiscoveredRuleCard(r)),
        ],
      ],
    );
  }

  Widget _buildDiscoveredEntityCard(DiscoveredEntity entity) {
    return AnimatedAccordion(
      initiallyExpanded: true,
      expandedBorderColor: const Color(0xFFFDE68A),
      backgroundColor: Colors.white,
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: ParchmentTheme.primaryUmber.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  entity.category.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: ParchmentTheme.primaryUmber,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                entity.chapterTitle,
                style: const TextStyle(
                  fontSize: 11.5,
                  color: ParchmentTheme.inkMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            entity.name,
            style: const TextStyle(
              fontFamily: 'serif',
              fontSize: 16.5,
              fontWeight: FontWeight.bold,
              color: ParchmentTheme.inkDark,
            ),
          ),
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ParchmentTheme.background,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: ParchmentTheme.cardBorder),
            ),
            child: Text(
              '"${entity.contextSnippet}"',
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 13,
                color: ParchmentTheme.inkDark,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey.shade700,
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                onPressed: () {
                  widget.onDismissDiscoveredEntity(entity);
                  ContinuityEventBus().emitLoreChange(
                    type: ContinuityEventType.loreDeleted,
                    worldId: widget.activeWorldId,
                    message: 'Dismissed entity ${entity.name}',
                  );
                },
                icon: const Icon(Icons.close, size: 16),
                label: const Text('Discard'),
              ),
              const SizedBox(width: 10),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: ParchmentTheme.primaryUmber,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  await widget.client.continuity.createEntity(
                      entity.toWorldEntity(worldId: widget.activeWorldId));
                  widget.onAcceptDiscoveredEntity(entity);
                  ContinuityEventBus().emitLoreChange(
                    type: ContinuityEventType.loreCreated,
                    worldId: widget.activeWorldId,
                    message: 'Accepted entity ${entity.name}',
                    payload: entity,
                  );
                  _loadData();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text('✓ Added "${entity.name}" to Canon Entities!'),
                        backgroundColor: ParchmentTheme.consistentText,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.check, size: 16),
                label: const Text('Add to World Bible'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoveredRuleCard(DiscoveredRule discRule) {
    return AnimatedAccordion(
      initiallyExpanded: true,
      expandedBorderColor: const Color(0xFFFDE68A),
      backgroundColor: Colors.white,
      header: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFD97706).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  discRule.chapterTitle,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB45309),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  discRule.relation,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: ParchmentTheme.primaryUmber,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${discRule.subject} ${discRule.relation} ${discRule.constraint}',
            style: const TextStyle(
              fontFamily: 'serif',
              fontSize: 15.5,
              fontWeight: FontWeight.bold,
              color: ParchmentTheme.inkDark,
            ),
          ),
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: ParchmentTheme.background,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: ParchmentTheme.cardBorder),
            ),
            child: Text(
              '"${discRule.contextSnippet}"',
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 13,
                color: ParchmentTheme.inkDark,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey.shade700,
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                onPressed: () {
                  widget.onDismissDiscoveredRule(discRule);
                  ContinuityEventBus().emitLoreChange(
                    type: ContinuityEventType.loreDeleted,
                    worldId: widget.activeWorldId,
                    message: 'Dismissed rule ${discRule.subject}',
                  );
                },
                icon: const Icon(Icons.close, size: 16),
                label: const Text('Discard / Ignore'),
              ),
              const SizedBox(width: 10),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFD97706),
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  await widget.client.continuity.createRule(
                      discRule.toWorldRule(worldId: widget.activeWorldId));
                  widget.onAcceptDiscoveredRule(discRule);
                  ContinuityEventBus().emitLoreChange(
                    type: ContinuityEventType.loreCreated,
                    worldId: widget.activeWorldId,
                    message: 'Accepted rule ${discRule.subject}',
                    payload: discRule,
                  );
                  _loadData();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            '✓ Added "${discRule.subject} ${discRule.relation} ${discRule.constraint}" to Canon Rules!'),
                        backgroundColor: ParchmentTheme.consistentText,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.check, size: 16),
                label: const Text('Accept & Add to Canon'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.auto_stories_outlined, size: 48, color: Colors.grey),
          const SizedBox(height: 12),
          Text(message, style: const TextStyle(color: ParchmentTheme.inkMuted)),
        ],
      ),
    );
  }

  void _showAddEntityDialog() {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final traitsCtrl = TextEditingController();
    String category = 'Character';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: ParchmentTheme.background,
          title: const Text('Add World Entity'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Entity Name'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: [
                    'Character',
                    'Magic & Physics',
                    'Faction',
                    'Artifact',
                    'Geography'
                  ]
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) => setDialogState(() => category = val!),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: traitsCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Traits (comma-separated)',
                    hintText: 'e.g. One-eyed, Mortal, Photosensitive',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: ParchmentTheme.primaryUmber),
              onPressed: () async {
                if (nameCtrl.text.trim().isEmpty) return;
                final traits = traitsCtrl.text
                    .split(',')
                    .map((s) => s.trim())
                    .where((s) => s.isNotEmpty)
                    .toList();
                final entity = WorldEntity(
                  worldId: widget.activeWorldId,
                  name: nameCtrl.text.trim(),
                  category: category,
                  description: descCtrl.text.trim(),
                  traits: traits,
                  isActive: true,
                );
                await widget.client.continuity.createEntity(entity);
                ContinuityEventBus().emitLoreChange(
                  type: ContinuityEventType.loreCreated,
                  worldId: widget.activeWorldId,
                  message: 'Created entity ${entity.name}',
                  payload: entity,
                );
                Navigator.pop(ctx);
                _loadData();
              },
              child: const Text('Save Entity'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddRuleDialog() {
    final subjectCtrl = TextEditingController();
    final constraintCtrl = TextEditingController();
    final explanationCtrl = TextEditingController();
    String relation = 'CANNOT';
    String severity = 'strict';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: ParchmentTheme.background,
          title: const Text('Add Canon Rule'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: subjectCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Subject',
                    hintText: 'e.g. Elena, Vampires, Teleportation',
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: relation,
                  decoration: const InputDecoration(labelText: 'Relation'),
                  items: [
                    'CANNOT',
                    'MUST',
                    'REQUIRES',
                    'VULNERABLE_TO',
                    'IMMUNE_TO'
                  ]
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (val) => setDialogState(() => relation = val!),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: constraintCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Constraint / Law',
                    hintText: 'e.g. Tolerate direct sunlight',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: explanationCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Lore Explanation / Context',
                    hintText: 'Why does this constraint exist?',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: ParchmentTheme.primaryUmber),
              onPressed: () async {
                if (subjectCtrl.text.trim().isEmpty ||
                    constraintCtrl.text.trim().isEmpty) return;
                final rule = WorldRule(
                  worldId: widget.activeWorldId,
                  subject: subjectCtrl.text.trim(),
                  relation: relation,
                  constraint: constraintCtrl.text.trim(),
                  explanation: explanationCtrl.text.trim(),
                  severity: severity,
                  isActive: true,
                );
                await widget.client.continuity.createRule(rule);
                ContinuityEventBus().emitLoreChange(
                  type: ContinuityEventType.loreCreated,
                  worldId: widget.activeWorldId,
                  message: 'Created rule ${rule.subject}',
                  payload: rule,
                );
                Navigator.pop(ctx);
                _loadData();
              },
              child: const Text('Save Rule'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteEntity(int id) async {
    await widget.client.continuity
        .deleteEntity(id, worldId: widget.activeWorldId);
    ContinuityEventBus().emitLoreChange(
      type: ContinuityEventType.loreDeleted,
      worldId: widget.activeWorldId,
      message: 'Deleted entity #$id',
    );
    _loadData();
  }

  Future<void> _deleteRule(int id) async {
    await widget.client.continuity
        .deleteRule(id, worldId: widget.activeWorldId);
    ContinuityEventBus().emitLoreChange(
      type: ContinuityEventType.loreDeleted,
      worldId: widget.activeWorldId,
      message: 'Deleted rule #$id',
    );
    _loadData();
  }
}
