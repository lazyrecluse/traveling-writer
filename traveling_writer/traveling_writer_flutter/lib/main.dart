import 'package:flutter/material.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:traveling_writer_client/traveling_writer_client.dart';
import 'models/chapter.dart';
import 'models/story.dart';
import 'services/continuity_event_bus.dart';
import 'services/storage_service.dart';
import 'theme/parchment_theme.dart';
import 'views/landing_page_view.dart';
import 'views/story_studio_view.dart';
import 'views/plot_graph_view.dart';
import 'views/world_bible_view.dart';
import 'widgets/animated_indexed_stack.dart';

late final Client client;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure Serverpod Client: point to live Serverpod Cloud API
  const serverUrl = String.fromEnvironment(
    'SERVER_URL',
    defaultValue: 'https://traveling-writer.api.serverpod.space/',
  );
  client = Client(
    serverUrl,
  )..connectivityMonitor = FlutterConnectivityMonitor();

  runApp(const TravelingWriterApp());
}

class TravelingWriterApp extends StatelessWidget {
  const TravelingWriterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Traveling Writer - AI Lore & Continuity Guardian',
      debugShowCheckedModeBanner: false,
      theme: ParchmentTheme.theme,
      home: const TravelingWriterRootScreen(),
    );
  }
}

class TravelingWriterRootScreen extends StatefulWidget {
  const TravelingWriterRootScreen({super.key});

  @override
  State<TravelingWriterRootScreen> createState() =>
      _TravelingWriterRootScreenState();
}

class _TravelingWriterRootScreenState extends State<TravelingWriterRootScreen> {
  UserSession? _currentSession;
  bool _isLoadingSession = true;

  int _currentViewIndex = 0; // 0: Story Studio, 1: Plot Canvas, 2: World Bible
  int _worldBibleInitialTab = 0;
  bool _isAuditing = false;

  List<World> _worlds = [];
  World? _activeWorld;

  late List<Story> _stories;
  late Story _activeStory;
  Chapter? _activeChapter;

  @override
  void initState() {
    super.initState();
    _stories = [_createDefaultSeedStory()];
    _activeStory = _stories.first;
    _loadUserSession();
  }

  Story _createDefaultSeedStory({int? worldId}) {
    final chapter1 = Chapter(
      id: 'ch_1',
      title: 'Chapter 1: The Silverwood Whispers',
      content:
          '''The forest was quiet as morning broke over the canopy. Elena crept along the damp moss, listening intently for any sound of iron or hoofbeats.

Taking a deep breath, Elena raised her longbow. She carefully winked with her left eye through the iron sights to line up the shot on the distant stag.

Later that afternoon, Lord Morvath stepped out onto the open sunlit balcony. He leaned on the marble railing, enjoying the blazing midday sun beating down on his bare shoulders without a care in the world.''',
      auditResult: AuditResult(
        storyText: '',
        totalParagraphs: 3,
        isConsistent: false,
        summary:
            'The chapter contains a direct contradiction regarding Elena\'s physical traits: she lost her left eye in the Great War and wears an eyepatch.',
        violations: [
          ContinuityViolation(
            paragraphIndex: 1,
            textSnippet: 'winking with her left eye',
            entityName: 'Elena the Ranger',
            brokenRule: 'Elena the Ranger CANNOT See or aim with her left eye',
            explanation:
                'Lore dictates Elena lost her left eye in the Great War; she cannot wink or calculate trajectory with it.',
            severity: 'strict',
          ),
        ],
        auditedAt: DateTime.now(),
      ),
      discoveredRules: [
        DiscoveredRule(
          id: 'disc_r_ch_1_1',
          subject: 'Lord Morvath',
          relation: 'IMMUNE TO',
          constraint: 'Sunlight damage while on open balconies',
          contextSnippet:
              'Lord Morvath stepped out onto the open sunlit balcony... enjoying the blazing midday sun beating down on his bare shoulders.',
          explanation:
              'Prose implies Lord Morvath can withstand midday sun unlike common Nightstalkers.',
          chapterId: 'ch_1',
          chapterTitle: 'Chapter 1: The Silverwood Whispers',
        ),
      ],
      discoveredEntities: [
        DiscoveredEntity(
          id: 'disc_e_ch_1_1',
          name: 'Lord Morvath',
          category: 'Character',
          description: 'Noble figure observed on an open balcony',
          traits: ['Unbothered by direct midday sunlight'],
          contextSnippet:
              'Lord Morvath stepped out onto the open sunlit balcony.',
          chapterId: 'ch_1',
          chapterTitle: 'Chapter 1: The Silverwood Whispers',
        ),
      ],
    );

    return Story(
      id: 'story_1',
      worldId: worldId ?? 1,
      title: 'The Silverwood Whispers',
      synopsis:
          'Elena investigates sightings of rogue Nightstalkers venturing beyond their mountain fortress.',
      genre: 'Fantasy / Mystery',
      chapters: [chapter1],
    );
  }

  Future<void> _loadWorlds(UserSession session) async {
    try {
      final backendWorlds = await client.continuity.listWorlds();
      if (backendWorlds.isNotEmpty) {
        _worlds = backendWorlds;
      } else {
        final initialWorld = World(
          name: 'The Shattered Isles',
          genre: 'Dark Fantasy',
          description:
              'A fractured realm where ancient sun-relics hold back the eternal twilight of vampire noble houses.',
          ownerId: session.storageKey,
          createdAt: DateTime.now(),
        );
        final created = await client.continuity.createWorld(initialWorld);
        _worlds = [created];
      }
    } catch (_) {
      _worlds = [
        World(
          id: 1,
          name: 'The Shattered Isles',
          genre: 'Dark Fantasy',
          description:
              'A fractured realm where ancient sun-relics hold back the eternal twilight of vampire noble houses.',
          ownerId: session.storageKey,
          createdAt: DateTime.now(),
        )
      ];
    }

    final savedWorldId =
        await StorageService.getActiveWorldId(session.storageKey);
    if (savedWorldId != null) {
      _activeWorld = _worlds.firstWhere(
        (w) => w.id == savedWorldId,
        orElse: () => _worlds.first,
      );
    } else {
      _activeWorld = _worlds.first;
    }
  }

  Future<void> _switchActiveWorld(World world) async {
    if (_activeWorld?.id == world.id && _stories.isNotEmpty) return;

    setState(() {
      _activeWorld = world;
      _isLoadingSession = true;
    });

    if (_currentSession != null && world.id != null) {
      await StorageService.setActiveWorldId(
          _currentSession!.storageKey, world.id!);

      final savedStories = await StorageService.loadStories(
        _currentSession!.storageKey,
        worldId: world.id,
      );

      if (savedStories != null && savedStories.isNotEmpty) {
        _stories = savedStories;
      } else {
        final defaultStory = _createDefaultSeedStory(worldId: world.id);
        _stories = [defaultStory];
        await StorageService.saveStories(
          _currentSession!.storageKey,
          _stories,
          worldId: world.id,
        );
      }

      _activeStory = _stories.first;
      _activeChapter = null;
    }

    setState(() {
      _isLoadingSession = false;
      _currentViewIndex = 0;
    });

    ContinuityEventBus().emitWorldSwitched(world.id, worldName: world.name);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🌌 Switched to Universe: ${world.name}'),
          backgroundColor: ParchmentTheme.primaryUmber,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _loadUserSession() async {
    try {
      final session = await StorageService.getActiveSession();
      if (session != null) {
        await _loadWorlds(session);

        if (session.isGuest) {
          final defaultStory =
              _createDefaultSeedStory(worldId: _activeWorld?.id);
          _stories = [defaultStory];
          _activeStory = defaultStory;
          _activeChapter = null;
        } else {
          final savedStories = await StorageService.loadStories(
            session.storageKey,
            worldId: _activeWorld?.id,
          );
          if (savedStories != null && savedStories.isNotEmpty) {
            _stories = savedStories;
            _activeStory = _stories.first;
            _activeChapter = null;
          } else {
            final defaultStory =
                _createDefaultSeedStory(worldId: _activeWorld?.id);
            _stories = [defaultStory];
            _activeStory = defaultStory;
            _activeChapter = null;
            await StorageService.saveStories(
              session.storageKey,
              _stories,
              worldId: _activeWorld?.id,
            );
          }
        }

        setState(() {
          _currentSession = session;
          _isLoadingSession = false;
        });
        return;
      }
    } catch (_) {}

    setState(() {
      _isLoadingSession = false;
    });
  }

  Future<void> _onSessionStarted(UserSession session) async {
    setState(() => _isLoadingSession = true);
    await _loadWorlds(session);

    if (session.isGuest) {
      final defaultStory = _createDefaultSeedStory(worldId: _activeWorld?.id);
      _stories = [defaultStory];
      _activeStory = defaultStory;
      _activeChapter = null;
      await StorageService.saveStories(
        session.storageKey,
        _stories,
        worldId: _activeWorld?.id,
      );
    } else {
      final savedStories = await StorageService.loadStories(
        session.storageKey,
        worldId: _activeWorld?.id,
      );
      if (savedStories != null && savedStories.isNotEmpty) {
        _stories = savedStories;
        _activeStory = _stories.first;
        _activeChapter = null;
      } else {
        final defaultStory = _createDefaultSeedStory(worldId: _activeWorld?.id);
        _stories = [defaultStory];
        _activeStory = defaultStory;
        _activeChapter = null;
        await StorageService.saveStories(
          session.storageKey,
          _stories,
          worldId: _activeWorld?.id,
        );
      }
    }

    setState(() {
      _currentSession = session;
      _isLoadingSession = false;
      _currentViewIndex = 0;
    });
  }

  Future<void> _saveCurrentStories() async {
    if (_currentSession == null) return;
    await StorageService.saveStories(
      _currentSession!.storageKey,
      _stories,
      worldId: _activeWorld?.id,
    );
  }

  Future<void> _signOut() async {
    await StorageService.setActiveSession(null);
    setState(() {
      _currentSession = null;
      _activeChapter = null;
      _currentViewIndex = 0;
    });
  }

  int get totalPendingDiscovered =>
      _allPendingDiscoveredRules.length + _allPendingDiscoveredEntities.length;

  List<DiscoveredRule> get _allPendingDiscoveredRules {
    final list = <DiscoveredRule>[];
    for (final ch in _activeStory.chapters) {
      list.addAll(ch.discoveredRules.where((r) => !r.isReviewed));
    }
    return list;
  }

  List<DiscoveredEntity> get _allPendingDiscoveredEntities {
    final list = <DiscoveredEntity>[];
    for (final ch in _activeStory.chapters) {
      list.addAll(ch.discoveredEntities.where((e) => !e.isReviewed));
    }
    return list;
  }

  Future<void> _runContinuityAudit(Chapter chapter) async {
    final text = chapter.content.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write some text to audit.')),
      );
      return;
    }

    setState(() => _isAuditing = true);
    try {
      final result = await client.continuity.auditStory(
        text,
        worldId: _activeWorld?.id,
        chapterId: chapter.id,
      );
      final existingRules =
          await client.continuity.listRules(worldId: _activeWorld?.id);
      final existingEntities =
          await client.continuity.listEntities(worldId: _activeWorld?.id);

      // Retrieve dismissed signatures for this user in active world
      final dismissed = _currentSession != null
          ? await StorageService.loadDismissedLore(
              _currentSession!.storageKey,
              worldId: _activeWorld?.id,
            )
          : <String>{};

      // Extract candidate rules AND entities from prose
      final loreResult = extractPotentialLoreFromText(
        text: text,
        chapterId: chapter.id,
        chapterTitle: chapter.title,
        existingRules: existingRules,
        existingEntities: existingEntities,
        dismissedSignatures: dismissed,
      );

      // Merge newly extracted rules
      for (final rule in loreResult.rules) {
        if (!dismissed.contains(rule.signature) &&
            !chapter.discoveredRules.any((r) =>
                r.subject.toLowerCase() == rule.subject.toLowerCase() &&
                r.constraint.toLowerCase() == rule.constraint.toLowerCase())) {
          chapter.discoveredRules.add(rule);
        }
      }

      // Merge newly extracted entities
      for (final entity in loreResult.entities) {
        if (!dismissed.contains(entity.signature) &&
            !chapter.discoveredEntities.any(
                (e) => e.name.toLowerCase() == entity.name.toLowerCase())) {
          chapter.discoveredEntities.add(entity);
        }
      }

      chapter.auditResult = result;
      await _saveCurrentStories();

      ContinuityEventBus().emitChapterAudited(
        worldId: _activeWorld?.id,
        chapterId: chapter.id,
        payload: result,
      );

      setState(() {
        _isAuditing = false;
      });

      if (mounted) {
        final isCached = result.cached == true;
        final cacheBadge = isCached ? '⚡ [0-Token Cache Hit] ' : '';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.isConsistent
                ? '$cacheBadge✓ Canon consistent in ${_activeWorld?.name ?? "World"}!'
                : '$cacheBadge⚠️ ${result.violations.length} lore conflict(s) detected.'),
            backgroundColor: result.isConsistent
                ? ParchmentTheme.consistentText
                : ParchmentTheme.alertText,
          ),
        );
      }
    } catch (e) {
      setState(() => _isAuditing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Audit error: $e'),
            backgroundColor: ParchmentTheme.alertText,
          ),
        );
      }
    }
  }

  void _handleAddStory(String title, String synopsis) {
    final newStory = Story(
      id: 'story_${const Uuid().v4()}',
      worldId: _activeWorld?.id ?? 1,
      title: title,
      synopsis: synopsis,
      chapters: [],
    );
    setState(() {
      _stories.add(newStory);
      _activeStory = newStory;
      _activeChapter = null;
    });
    _saveCurrentStories();
  }

  void _handleAddChapter(String title) {
    final newChapter = Chapter(
      id: 'ch_${const Uuid().v4()}',
      title: title,
      content: '',
    );
    setState(() {
      _activeStory.chapters.add(newChapter);
      _activeChapter = newChapter;
      _currentViewIndex = 0;
    });
    _saveCurrentStories();
  }

  void _handleDeleteChapter(Chapter chapter) {
    setState(() {
      _activeStory.chapters.removeWhere((c) => c.id == chapter.id);
      if (_activeChapter?.id == chapter.id) {
        _activeChapter = null;
      }
    });
    _saveCurrentStories();
  }

  void _handleSelectChapterFromPlotCanvas(Chapter chapter) {
    setState(() {
      _activeChapter = chapter;
      _currentViewIndex = 0; // Jump to Story Studio
    });
  }

  void _handleNavigateToWorldBibleDiscovered() {
    setState(() {
      _worldBibleInitialTab = 2; // Jump to Discovered tab
      _currentViewIndex = 2; // Jump to World Bible
    });
  }

  Future<void> _handleAcceptDiscoveredRule(DiscoveredRule rule) async {
    setState(() {
      rule.isReviewed = true;
    });
    if (_currentSession != null) {
      await StorageService.addDismissedLore(
        _currentSession!.storageKey,
        rule.signature,
        worldId: _activeWorld?.id,
      );
      await StorageService.addDismissedLore(
        _currentSession!.storageKey,
        rule.id,
        worldId: _activeWorld?.id,
      );
    }
    await _saveCurrentStories();
    ContinuityEventBus().emitLoreChange(
      type: ContinuityEventType.loreCreated,
      worldId: _activeWorld?.id,
      message: 'Accepted discovered rule: ${rule.subject}',
      payload: rule,
    );
  }

  Future<void> _handleDismissDiscoveredRule(DiscoveredRule rule) async {
    setState(() {
      rule.isReviewed = true;
      for (final ch in _activeStory.chapters) {
        ch.discoveredRules.removeWhere((r) => r.id == rule.id);
      }
    });
    if (_currentSession != null) {
      await StorageService.addDismissedLore(
        _currentSession!.storageKey,
        rule.signature,
        worldId: _activeWorld?.id,
      );
      await StorageService.addDismissedLore(
        _currentSession!.storageKey,
        rule.id,
        worldId: _activeWorld?.id,
      );
    }
    await _saveCurrentStories();
    ContinuityEventBus().emitLoreChange(
      type: ContinuityEventType.loreDeleted,
      worldId: _activeWorld?.id,
      message: 'Dismissed discovered rule: ${rule.subject}',
      payload: rule,
    );
  }

  Future<void> _handleAcceptDiscoveredEntity(DiscoveredEntity entity) async {
    setState(() {
      entity.isReviewed = true;
    });
    if (_currentSession != null) {
      await StorageService.addDismissedLore(
        _currentSession!.storageKey,
        entity.signature,
        worldId: _activeWorld?.id,
      );
      await StorageService.addDismissedLore(
        _currentSession!.storageKey,
        entity.id,
        worldId: _activeWorld?.id,
      );
    }
    await _saveCurrentStories();
    ContinuityEventBus().emitLoreChange(
      type: ContinuityEventType.loreCreated,
      worldId: _activeWorld?.id,
      message: 'Accepted discovered entity: ${entity.name}',
      payload: entity,
    );
  }

  Future<void> _handleDismissDiscoveredEntity(DiscoveredEntity entity) async {
    setState(() {
      entity.isReviewed = true;
      for (final ch in _activeStory.chapters) {
        ch.discoveredEntities.removeWhere((e) => e.id == entity.id);
      }
    });
    if (_currentSession != null) {
      await StorageService.addDismissedLore(
        _currentSession!.storageKey,
        entity.signature,
        worldId: _activeWorld?.id,
      );
      await StorageService.addDismissedLore(
        _currentSession!.storageKey,
        entity.id,
        worldId: _activeWorld?.id,
      );
    }
    await _saveCurrentStories();
    ContinuityEventBus().emitLoreChange(
      type: ContinuityEventType.loreDeleted,
      worldId: _activeWorld?.id,
      message: 'Dismissed discovered entity: ${entity.name}',
      payload: entity,
    );
  }

  Future<void> _seedSampleLore() async {
    try {
      final seeded =
          await client.continuity.seedSampleLore(worldId: _activeWorld?.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(seeded
                ? 'Sample lore loaded for ${_activeWorld?.name ?? "World"}!'
                : 'Lore already exists for this universe.'),
            backgroundColor: ParchmentTheme.consistentText,
          ),
        );
      }
      ContinuityEventBus().emitLoreChange(
        type: ContinuityEventType.loreCreated,
        worldId: _activeWorld?.id,
        message: 'Seeded sample lore',
      );
      setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error seeding lore: $e')),
        );
      }
    }
  }

  void _showWorldSelectorDialog() {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return AlertDialog(
            backgroundColor: ParchmentTheme.cardBg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: ParchmentTheme.cardBorder),
            ),
            title: const Row(
              children: [
                Icon(Icons.public, color: ParchmentTheme.primaryUmber),
                SizedBox(width: 8),
                Text(
                  'Story Universes (Tenants)',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: ParchmentTheme.inkDark,
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: 480,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Each universe is a strictly isolated canon container. Lore rules, entities, and audits never leak across universes.',
                    style:
                        TextStyle(fontSize: 12, color: ParchmentTheme.inkMuted),
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: _worlds.length,
                      separatorBuilder: (_, __) => const Divider(
                          height: 1, color: ParchmentTheme.cardBorder),
                      itemBuilder: (context, i) {
                        final w = _worlds[i];
                        final isSelected = w.id == _activeWorld?.id;
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          leading: CircleAvatar(
                            backgroundColor: isSelected
                                ? ParchmentTheme.primaryUmber
                                : ParchmentTheme.cardBorder.withOpacity(0.5),
                            child: Icon(
                              Icons.auto_stories,
                              size: 18,
                              color: isSelected
                                  ? Colors.white
                                  : ParchmentTheme.inkMuted,
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                w.name,
                                style: TextStyle(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: ParchmentTheme.inkDark,
                                ),
                              ),
                              if (w.genre != null && w.genre!.isNotEmpty) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: ParchmentTheme.primaryUmber
                                        .withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    w.genre!,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: ParchmentTheme.primaryUmber,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          subtitle: Text(
                            w.description ?? 'No premise specified.',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 11, color: ParchmentTheme.inkMuted),
                          ),
                          trailing: isSelected
                              ? const Icon(Icons.check_circle,
                                  color: ParchmentTheme.consistentText,
                                  size: 20)
                              : null,
                          onTap: () {
                            Navigator.pop(ctx);
                            _switchActiveWorld(w);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  _showCreateWorldDialog();
                },
                icon: const Icon(Icons.add,
                    size: 16, color: ParchmentTheme.primaryUmber),
                label: const Text('Create New Universe',
                    style: TextStyle(color: ParchmentTheme.primaryUmber)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Close',
                    style: TextStyle(color: ParchmentTheme.inkMuted)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showCreateWorldDialog() {
    final nameCtrl = TextEditingController();
    final genreCtrl = TextEditingController(text: 'Science Fiction');
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: ParchmentTheme.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: ParchmentTheme.cardBorder),
        ),
        title: const Text(
          'Create Story Universe',
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ParchmentTheme.inkDark,
          ),
        ),
        content: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Universe Name *',
                  hintText: 'e.g. Sector 9: Deep Shift, Solar Empire...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: genreCtrl,
                decoration: const InputDecoration(
                  labelText: 'Genre / Subgenre',
                  hintText: 'e.g. Cyberpunk, Space Opera, Urban Fantasy...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Premise & Core Laws',
                  hintText:
                      'Brief summary of the universe laws and constraints...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: ParchmentTheme.inkMuted)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: ParchmentTheme.primaryUmber,
            ),
            onPressed: () async {
              final name = nameCtrl.text.trim();
              if (name.isEmpty) return;

              final newWorld = World(
                name: name,
                genre: genreCtrl.text.trim(),
                description: descCtrl.text.trim(),
                ownerId: _currentSession?.storageKey,
                createdAt: DateTime.now(),
              );

              try {
                final created = await client.continuity.createWorld(newWorld);
                setState(() {
                  _worlds.add(created);
                });
                Navigator.pop(ctx);
                await _switchActiveWorld(created);
              } catch (e) {
                final fallbackId = (_worlds
                        .map((w) => w.id ?? 0)
                        .fold(0, (a, b) => a > b ? a : b)) +
                    1;
                final fallbackWorld = World(
                  id: fallbackId,
                  name: name,
                  genre: genreCtrl.text.trim(),
                  description: descCtrl.text.trim(),
                  ownerId: _currentSession?.storageKey,
                  createdAt: DateTime.now(),
                );
                setState(() {
                  _worlds.add(fallbackWorld);
                });
                Navigator.pop(ctx);
                await _switchActiveWorld(fallbackWorld);
              }
            },
            child: const Text('Create Universe'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingSession) {
      return const Scaffold(
        backgroundColor: ParchmentTheme.background,
        body: Center(
          child: CircularProgressIndicator(color: ParchmentTheme.primaryUmber),
        ),
      );
    }

    // If no active session, show the redesigned modern Landing & Auth Page!
    if (_currentSession == null) {
      return LandingPageView(
        onSessionStarted: _onSessionStarted,
      );
    }

    final isMobile = MediaQuery.of(context).size.width < 768;
    final genreAccent =
        ParchmentTheme.getAccentColorForGenre(_activeStory.genre);

    return Scaffold(
      backgroundColor: ParchmentTheme.background,
      appBar: AppBar(
        backgroundColor: ParchmentTheme.cardBg,
        elevation: 0,
        centerTitle: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: genreAccent.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.auto_stories,
                color: genreAccent,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Traveling Writer',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'serif',
                    color: ParchmentTheme.inkDark,
                  ),
                ),
                if (!isMobile)
                  const Text(
                    'Write boundless worlds. Never break canon.',
                    style: TextStyle(
                      fontSize: 11,
                      color: ParchmentTheme.inkMuted,
                      letterSpacing: 0.2,
                    ),
                  ),
              ],
            ),
          ],
        ),
        actions: [
          // Story Universe (Tenant Container) Switcher
          InkWell(
            onTap: _showWorldSelectorDialog,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: genreAccent.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: genreAccent.withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.public,
                    size: 15,
                    color: genreAccent,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _activeWorld?.name ?? 'The Shattered Isles',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: genreAccent,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Icon(
                    Icons.arrow_drop_down,
                    size: 16,
                    color: genreAccent,
                  ),
                ],
              ),
            ),
          ),

          // Author Pen Name Badge & Session Sign Out
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: ParchmentTheme.cardBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _currentSession!.isGuest
                      ? Icons.person_outline
                      : Icons.edit_note,
                  size: 15,
                  color: ParchmentTheme.primaryUmber,
                ),
                const SizedBox(width: 5),
                Text(
                  _currentSession!.penName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: ParchmentTheme.inkDark,
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.logout, size: 15, color: Colors.grey),
                  tooltip: 'Sign Out',
                  onPressed: _signOut,
                ),
              ],
            ),
          ),

          // Seed Demo Lore
          if (isMobile)
            IconButton(
              tooltip: 'Seed Sample Lore',
              icon: const Icon(Icons.download_outlined,
                  color: ParchmentTheme.primaryUmber, size: 20),
              onPressed: _seedSampleLore,
            )
          else
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: ParchmentTheme.primaryUmber,
              ),
              onPressed: _seedSampleLore,
              icon: const Icon(Icons.download_outlined, size: 16),
              label: const Text('Seed Lore', style: TextStyle(fontSize: 12)),
            ),

          const SizedBox(width: 8),
        ],
        bottom: isMobile
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(
                          color: ParchmentTheme.cardBorder, width: 0.8),
                      bottom: BorderSide(
                          color: ParchmentTheme.cardBorder, width: 0.8),
                    ),
                  ),
                  child: Row(
                    children: [
                      _buildNavTab(
                        index: 0,
                        icon: Icons.edit_note,
                        label: 'Story Studio',
                        activeColor: genreAccent,
                      ),
                      _buildNavTab(
                        index: 1,
                        icon: Icons.hub_outlined,
                        label: 'Plot Canvas',
                        activeColor: genreAccent,
                      ),
                      _buildNavTab(
                        index: 2,
                        icon: Icons.menu_book,
                        label: 'World Bible (Canon)',
                        badgeCount: totalPendingDiscovered,
                        activeColor: genreAccent,
                      ),
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: isMobile
          ? NavigationBar(
              selectedIndex: _currentViewIndex,
              onDestinationSelected: (idx) {
                setState(() {
                  _currentViewIndex = idx;
                  if (idx == 2) _worldBibleInitialTab = 0;
                });
              },
              backgroundColor: ParchmentTheme.cardBg,
              indicatorColor: ParchmentTheme.primaryUmber.withOpacity(0.18),
              destinations: [
                const NavigationDestination(
                  icon: Icon(Icons.edit_note_outlined),
                  selectedIcon:
                      Icon(Icons.edit_note, color: ParchmentTheme.primaryUmber),
                  label: 'Studio',
                ),
                const NavigationDestination(
                  icon: Icon(Icons.hub_outlined),
                  selectedIcon:
                      Icon(Icons.hub, color: ParchmentTheme.primaryUmber),
                  label: 'Plot Canvas',
                ),
                NavigationDestination(
                  icon: totalPendingDiscovered > 0
                      ? Badge(
                          label: Text('$totalPendingDiscovered'),
                          child: const Icon(Icons.menu_book_outlined),
                        )
                      : const Icon(Icons.menu_book_outlined),
                  selectedIcon: totalPendingDiscovered > 0
                      ? Badge(
                          label: Text('$totalPendingDiscovered'),
                          child: const Icon(Icons.menu_book,
                              color: ParchmentTheme.primaryUmber),
                        )
                      : const Icon(Icons.menu_book,
                          color: ParchmentTheme.primaryUmber),
                  label: 'World Bible',
                ),
              ],
            )
          : null,
      body: AnimatedIndexedStack(
        index: _currentViewIndex,
        children: [
          StoryStudioView(
            client: client,
            stories: _stories,
            activeStory: _activeStory,
            onActiveStoryChanged: (story) {
              setState(() {
                _activeStory = story;
                _activeChapter = null;
              });
            },
            onAddStory: _handleAddStory,
            activeChapter: _activeChapter,
            onActiveChapterChanged: (chapter) {
              setState(() => _activeChapter = chapter);
            },
            onAddChapter: _handleAddChapter,
            onDeleteChapter: _handleDeleteChapter,
            onAuditRequested: _runContinuityAudit,
            isAuditing: _isAuditing,
            onNavigateToWorldBible: _handleNavigateToWorldBibleDiscovered,
            onChapterContentChanged: _saveCurrentStories,
          ),
          PlotGraphView(
            client: client,
            stories: _stories,
            activeStory: _activeStory,
            activeWorldId: _activeWorld?.id,
            onActiveStoryChanged: (story) {
              setState(() => _activeStory = story);
            },
            onSelectChapter: _handleSelectChapterFromPlotCanvas,
            onDataChanged: () => setState(() {}),
          ),
          WorldBibleView(
            client: client,
            activeWorldId: _activeWorld?.id,
            onDataChanged: () => setState(() {}),
            discoveredRules: _allPendingDiscoveredRules,
            discoveredEntities: _allPendingDiscoveredEntities,
            onAcceptDiscoveredRule: _handleAcceptDiscoveredRule,
            onDismissDiscoveredRule: _handleDismissDiscoveredRule,
            onAcceptDiscoveredEntity: _handleAcceptDiscoveredEntity,
            onDismissDiscoveredEntity: _handleDismissDiscoveredEntity,
            initialTabIndex: _worldBibleInitialTab,
          ),
        ],
      ),
    );
  }

  Widget _buildNavTab({
    required int index,
    required IconData icon,
    required String label,
    int badgeCount = 0,
    Color? activeColor,
  }) {
    final isSelected = _currentViewIndex == index;
    final effectiveColor = activeColor ?? ParchmentTheme.primaryUmber;

    return InkWell(
      onTap: () {
        setState(() {
          _currentViewIndex = index;
          if (index == 2) _worldBibleInitialTab = 0;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? effectiveColor : Colors.transparent,
              width: 3,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? effectiveColor : ParchmentTheme.inkMuted,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? effectiveColor : ParchmentTheme.inkMuted,
              ),
            ),
            if (badgeCount > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFD97706),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$badgeCount new',
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
    );
  }
}
