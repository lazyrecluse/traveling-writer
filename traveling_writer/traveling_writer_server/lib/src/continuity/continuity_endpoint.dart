import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'continuity_service.dart';

class ContinuityEndpoint extends Endpoint {
  // In-memory fallback caches in case database is being initialized or running in lightweight mode
  static final List<World> _memWorlds = [];
  static final List<WorldEntity> _memEntities = [];
  static final List<WorldRule> _memRules = [];
  static final List<PlotNode> _memPlotNodes = [];
  static int _idCounter = 1;

  // -------------------------------------------------------------
  // WORLD MANAGEMENT (TENANT ROOT CONTAINER)
  // -------------------------------------------------------------

  /// Lists all registered World universes, optionally filtered by ownerId.
  Future<List<World>> listWorlds(Session session, {String? ownerId}) async {
    try {
      final rows = await World.db.find(
        session,
        where: ownerId != null ? (t) => t.ownerId.equals(ownerId) : null,
        orderBy: (t) => t.id,
      );
      if (rows.isNotEmpty) return rows;
    } catch (e) {
      session.log(
        'Database find failed for World, using in-memory: $e',
        level: LogLevel.warning,
      );
    }
    if (ownerId != null) {
      return _memWorlds.where((w) => w.ownerId == ownerId).toList();
    }
    return List.from(_memWorlds);
  }

  /// Creates a new World universe (tenant container).
  Future<World> createWorld(Session session, World world) async {
    try {
      final inserted = await World.db.insertRow(session, world);
      return inserted;
    } catch (e) {
      session.log(
        'Database insertRow failed for World, using in-memory: $e',
        level: LogLevel.warning,
      );
      final withId = World(
        id: world.id ?? _idCounter++,
        name: world.name,
        genre: world.genre,
        description: world.description,
        ownerId: world.ownerId,
        createdAt: world.createdAt,
      );
      _memWorlds.add(withId);
      return withId;
    }
  }

  /// Deletes a World and all its scoped lore entities, rules, and plot nodes.
  /// Also invalidates the entire tenant cache group.
  Future<bool> deleteWorld(Session session, int worldId) async {
    try {
      // Invalidate tenant cache group
      await session.caches.local.invalidateGroup('tenant:$worldId');

      final row = await World.db.findById(session, worldId);
      if (row != null) {
        await WorldRule.db.deleteWhere(
          session,
          where: (t) => t.worldId.equals(worldId),
        );
        await WorldEntity.db.deleteWhere(
          session,
          where: (t) => t.worldId.equals(worldId),
        );
        await PlotNode.db.deleteWhere(
          session,
          where: (t) => t.worldId.equals(worldId),
        );
        await World.db.deleteRow(session, row);
        return true;
      }
    } catch (e) {
      session.log(
        'Database deleteRow failed for World, using in-memory: $e',
        level: LogLevel.warning,
      );
    }
    _memWorlds.removeWhere((w) => w.id == worldId);
    _memRules.removeWhere((r) => r.worldId == worldId);
    _memEntities.removeWhere((e) => e.worldId == worldId);
    _memPlotNodes.removeWhere((p) => p.worldId == worldId);
    return true;
  }

  // -------------------------------------------------------------
  // CONTINUITY AUDIT & TENANT-BOUND CACHING
  // -------------------------------------------------------------

  /// Audits a story text against all active world entities and lore rules for a given world.
  /// Implements tenant-bound compound content-hash caching to return 0-token results for unchanged prose.
  Future<AuditResult> auditStory(
    Session session,
    String storyText, {
    int? worldId,
    String? chapterId,
  }) async {
    final tenantWorldId = worldId ?? 1;
    final tenantGroup = 'tenant:$tenantWorldId';

    final entities = await listEntities(session, worldId: worldId);
    final rules = await listRules(session, worldId: worldId);

    final activeEntities = entities.where((e) => e.isActive).toList();
    final activeRules = rules.where((r) => r.isActive).toList();

    // Create deterministic fingerprint of prose + active rules for this tenant
    final rulesSignature = activeRules
        .map((r) => '${r.subject}:${r.relation}:${r.constraint}')
        .join('|');
    final contentBytes = utf8.encode('$storyText||$rulesSignature');
    final hashDigest = sha256.convert(contentBytes).toString();

    // Strict compound tenant cache key
    final chId = chapterId ?? 'ad_hoc';
    final cacheKey = 'tenant:$tenantWorldId:chapter:$chId:hash:$hashDigest';

    // Check L1 cache
    try {
      final cachedResult = await session.caches.local.get<AuditResult>(
        cacheKey,
      );
      if (cachedResult != null) {
        session.log(
          'Cache HIT for $cacheKey - returning 0-token cached result',
          level: LogLevel.info,
        );
        return AuditResult(
          storyText: cachedResult.storyText,
          totalParagraphs: cachedResult.totalParagraphs,
          violations: cachedResult.violations,
          isConsistent: cachedResult.isConsistent,
          summary: '${cachedResult.summary} (⚡ Served from tenant cache)',
          auditedAt: cachedResult.auditedAt,
          cached: true,
        );
      }
    } catch (e) {
      session.log('Cache check failed: $e', level: LogLevel.warning);
    }

    // Cache MISS: Run actual LLM audit
    final service = ContinuityService.fromSession(session);
    final result = await service.auditStory(
      storyText: storyText,
      entities: activeEntities,
      rules: activeRules,
    );

    result.cached = false;

    // Cache result with tenant group for surgical invalidation
    try {
      await session.caches.local.put<AuditResult>(
        cacheKey,
        result,
        lifetime: const Duration(hours: 24),
        group: tenantGroup,
      );
    } catch (e) {
      session.log('Failed to cache audit result: $e', level: LogLevel.warning);
    }

    return result;
  }

  // -------------------------------------------------------------
  // ENTITY MANAGEMENT (SCOPED TO WORLD)
  // -------------------------------------------------------------

  /// Lists all registered World Entities for a specific World universe.
  Future<List<WorldEntity>> listEntities(
    Session session, {
    int? worldId,
  }) async {
    try {
      final rows = await WorldEntity.db.find(
        session,
        where: worldId != null ? (t) => t.worldId.equals(worldId) : null,
        orderBy: (t) => t.id,
      );
      if (rows.isNotEmpty) return rows;
    } catch (e) {
      session.log(
        'Database find failed for WorldEntity, using in-memory: $e',
        level: LogLevel.warning,
      );
    }
    if (worldId != null) {
      return _memEntities.where((e) => e.worldId == worldId).toList();
    }
    return List.from(_memEntities);
  }

  /// Creates a new World Entity scoped to a World universe.
  Future<WorldEntity> createEntity(Session session, WorldEntity entity) async {
    // Invalidate tenant cache
    if (entity.worldId != null) {
      await session.caches.local.invalidateGroup('tenant:${entity.worldId}');
    }
    try {
      final inserted = await WorldEntity.db.insertRow(session, entity);
      return inserted;
    } catch (e) {
      session.log(
        'Database insertRow failed for WorldEntity, using in-memory: $e',
        level: LogLevel.warning,
      );
      final withId = WorldEntity(
        id: entity.id ?? _idCounter++,
        worldId: entity.worldId,
        name: entity.name,
        category: entity.category,
        description: entity.description,
        traits: entity.traits,
        isActive: entity.isActive,
      );
      _memEntities.add(withId);
      return withId;
    }
  }

  /// Deletes a World Entity by ID and invalidates the tenant cache.
  Future<bool> deleteEntity(Session session, int id, {int? worldId}) async {
    if (worldId != null) {
      await session.caches.local.invalidateGroup('tenant:$worldId');
    }
    try {
      final row = await WorldEntity.db.findById(session, id);
      if (row != null) {
        if (row.worldId != null) {
          await session.caches.local.invalidateGroup('tenant:${row.worldId}');
        }
        await WorldEntity.db.deleteRow(session, row);
        return true;
      }
    } catch (e) {
      session.log(
        'Database deleteRow failed for WorldEntity, using in-memory: $e',
        level: LogLevel.warning,
      );
    }
    _memEntities.removeWhere((e) => e.id == id);
    return true;
  }

  // -------------------------------------------------------------
  // CANON RULE MANAGEMENT (SCOPED TO WORLD)
  // -------------------------------------------------------------

  /// Lists all registered Canon Rules for a specific World universe.
  Future<List<WorldRule>> listRules(Session session, {int? worldId}) async {
    try {
      final rows = await WorldRule.db.find(
        session,
        where: worldId != null ? (t) => t.worldId.equals(worldId) : null,
        orderBy: (t) => t.id,
      );
      if (rows.isNotEmpty) return rows;
    } catch (e) {
      session.log(
        'Database find failed for WorldRule, using in-memory: $e',
        level: LogLevel.warning,
      );
    }
    if (worldId != null) {
      return _memRules.where((r) => r.worldId == worldId).toList();
    }
    return List.from(_memRules);
  }

  /// Creates a new Canon Rule scoped to a World universe.
  Future<WorldRule> createRule(Session session, WorldRule rule) async {
    // Invalidate tenant cache
    if (rule.worldId != null) {
      await session.caches.local.invalidateGroup('tenant:${rule.worldId}');
    }
    try {
      final inserted = await WorldRule.db.insertRow(session, rule);
      return inserted;
    } catch (e) {
      session.log(
        'Database insertRow failed for WorldRule, using in-memory: $e',
        level: LogLevel.warning,
      );
      final withId = WorldRule(
        id: rule.id ?? _idCounter++,
        worldId: rule.worldId,
        entityId: rule.entityId,
        subject: rule.subject,
        relation: rule.relation,
        constraint: rule.constraint,
        explanation: rule.explanation,
        severity: rule.severity,
        isActive: rule.isActive,
      );
      _memRules.add(withId);
      return withId;
    }
  }

  /// Deletes a Canon Rule by ID and invalidates the tenant cache.
  Future<bool> deleteRule(Session session, int id, {int? worldId}) async {
    if (worldId != null) {
      await session.caches.local.invalidateGroup('tenant:$worldId');
    }
    try {
      final row = await WorldRule.db.findById(session, id);
      if (row != null) {
        if (row.worldId != null) {
          await session.caches.local.invalidateGroup('tenant:${row.worldId}');
        }
        await WorldRule.db.deleteRow(session, row);
        return true;
      }
    } catch (e) {
      session.log(
        'Database deleteRow failed for WorldRule, using in-memory: $e',
        level: LogLevel.warning,
      );
    }
    _memRules.removeWhere((r) => r.id == id);
    return true;
  }

  // -------------------------------------------------------------
  // PLOT GRAPH NODES (SCOPED TO WORLD)
  // -------------------------------------------------------------

  /// Lists all registered Plot Nodes for a specific World universe.
  Future<List<PlotNode>> listPlotNodes(Session session, {int? worldId}) async {
    try {
      final rows = await PlotNode.db.find(
        session,
        where: worldId != null ? (t) => t.worldId.equals(worldId) : null,
        orderBy: (t) => t.id,
      );
      if (rows.isNotEmpty) return rows;
    } catch (e) {
      session.log(
        'Database find failed for PlotNode, using in-memory: $e',
        level: LogLevel.warning,
      );
    }
    if (worldId != null) {
      return _memPlotNodes.where((n) => n.worldId == worldId).toList();
    }
    return List.from(_memPlotNodes);
  }

  /// Saves or updates a Plot Node scoped to a World universe.
  Future<PlotNode> savePlotNode(Session session, PlotNode node) async {
    try {
      if (node.id != null) {
        final existing = await PlotNode.db.findById(session, node.id!);
        if (existing != null) {
          final updated = await PlotNode.db.updateRow(session, node);
          return updated;
        }
      }
      final inserted = await PlotNode.db.insertRow(session, node);
      return inserted;
    } catch (e) {
      session.log(
        'Database save failed for PlotNode, using in-memory: $e',
        level: LogLevel.warning,
      );
      _memPlotNodes.removeWhere((n) => n.id == node.id);
      final withId = PlotNode(
        id: node.id ?? _idCounter++,
        worldId: node.worldId,
        title: node.title,
        summary: node.summary,
        content: node.content,
        positionX: node.positionX,
        positionY: node.positionY,
        connectedNodeIds: node.connectedNodeIds,
        entityIds: node.entityIds,
        status: node.status,
      );
      _memPlotNodes.add(withId);
      return withId;
    }
  }

  /// Deletes a Plot Node by ID.
  Future<bool> deletePlotNode(Session session, int id, {int? worldId}) async {
    try {
      final row = await PlotNode.db.findById(session, id);
      if (row != null) {
        await PlotNode.db.deleteRow(session, row);
        return true;
      }
    } catch (e) {
      session.log(
        'Database deleteRow failed for PlotNode, using in-memory: $e',
        level: LogLevel.warning,
      );
    }
    _memPlotNodes.removeWhere((n) => n.id == id);
    return true;
  }

  /// Audits a specific plot node beat against the world lore before writing full prose.
  Future<AuditResult> auditPlotNode(
    Session session,
    int id, {
    int? worldId,
  }) async {
    PlotNode? node;
    try {
      node = await PlotNode.db.findById(session, id);
    } catch (_) {}
    node ??= _memPlotNodes.firstWhere(
      (n) => n.id == id,
      orElse: () => PlotNode(
        worldId: worldId,
        title: 'Untitled Node',
        summary: '',
        positionX: 0,
        positionY: 0,
        status: 'idea',
      ),
    );

    final storyText =
        '${node.title}\n\n${node.summary}\n\n${node.content ?? ""}';
    return await auditStory(
      session,
      storyText,
      worldId: worldId ?? node.worldId,
    );
  }

  // -------------------------------------------------------------
  // SEED SAMPLE LORE (TENANT INITIALIZATION)
  // -------------------------------------------------------------

  /// Seeds a sample fantasy lore canon scoped to a World universe.
  Future<bool> seedSampleLore(Session session, {int? worldId}) async {
    int targetWorldId = worldId ?? 1;

    // Ensure a default World exists
    final worlds = await listWorlds(session);
    if (worlds.isEmpty) {
      final defaultWorld = await createWorld(
        session,
        World(
          name: 'The Shattered Isles',
          genre: 'Dark Fantasy',
          description:
              'A fractured realm where ancient sun-relics hold back the eternal twilight of vampire noble houses.',
          ownerId: 'default',
          createdAt: DateTime.now(),
        ),
      );
      targetWorldId = defaultWorld.id ?? 1;
    } else if (worldId == null) {
      targetWorldId = worlds.first.id ?? 1;
    }

    final existingRules = await listRules(session, worldId: targetWorldId);
    if (existingRules.isNotEmpty) return false;

    // Seed Entities scoped to targetWorldId
    final elena = await createEntity(
      session,
      WorldEntity(
        worldId: targetWorldId,
        name: 'Elena the Ranger',
        category: 'Character',
        description: 'Elite elven archer and scout from the Silverwood.',
        traits: [
          'Lost left eye in the Great War',
          'Mortal',
          'Fears deep water',
        ],
        isActive: true,
      ),
    );

    final sunstone = await createEntity(
      session,
      WorldEntity(
        worldId: targetWorldId,
        name: 'The Sunstone of Aethel',
        category: 'Artifact',
        description: 'An ancient crystal relic capable of banishing shadows.',
        traits: ['Solar-charged', 'Inactive in rain or heavy overcast'],
        isActive: true,
      ),
    );

    final vampires = await createEntity(
      session,
      WorldEntity(
        worldId: targetWorldId,
        name: 'Nightstalkers (Vampires)',
        category: 'Faction',
        description: 'Aristocratic bloodlines cursed with undeath.',
        traits: ['Undead', 'Photosensitive', 'Superhuman speed'],
        isActive: true,
      ),
    );

    // Seed Rules scoped to targetWorldId
    await createRule(
      session,
      WorldRule(
        worldId: targetWorldId,
        entityId: elena.id,
        subject: 'Elena the Ranger',
        relation: 'CANNOT',
        constraint: 'See or aim with her left eye',
        explanation:
            'Lost her left eye during the Siege of Silverwood; she wears an eyepatch.',
        severity: 'strict',
        isActive: true,
      ),
    );

    await createRule(
      session,
      WorldRule(
        worldId: targetWorldId,
        entityId: vampires.id,
        subject: 'Nightstalkers (Vampires)',
        relation: 'CANNOT',
        constraint: 'Tolerate direct sunlight or touch running water',
        explanation:
            'Direct sunlight burns vampire flesh to ash within seconds.',
        severity: 'strict',
        isActive: true,
      ),
    );

    await createRule(
      session,
      WorldRule(
        worldId: targetWorldId,
        entityId: sunstone.id,
        subject: 'The Sunstone of Aethel',
        relation: 'REQUIRES',
        constraint: 'Direct sunlight to activate its radiant pulse',
        explanation:
            'The artifact has zero radiant power at night or inside caves unless pre-charged.',
        severity: 'strict',
        isActive: true,
      ),
    );

    await createRule(
      session,
      WorldRule(
        worldId: targetWorldId,
        subject: 'Teleportation Magic',
        relation: 'MUST',
        constraint:
            'Leave a distinct ozone scent and requires 10 seconds of uninterrupted chanting',
        explanation:
            'Instant teleportation without cast time violates universal magical physics.',
        severity: 'strict',
        isActive: true,
      ),
    );

    // Seed Sample Plot Graph Nodes scoped to targetWorldId
    final node1 = await savePlotNode(
      session,
      PlotNode(
        worldId: targetWorldId,
        title: 'Act 1: The Silverwood Ambush',
        summary:
            'Elena tracks Nightstalker scouts through the ancient pine woods.',
        content:
            'Elena slipped through the trees, her senses alert to every snapping twig.',
        positionX: 120,
        positionY: 180,
        connectedNodeIds: [],
        entityIds: [elena.id ?? 1],
        status: 'completed',
      ),
    );

    final node2 = await savePlotNode(
      session,
      PlotNode(
        worldId: targetWorldId,
        title: 'Act 2: The Obsidian Balcony',
        summary: 'Infiltration of Lord Morvath\'s fortress.',
        content:
            'The castle walls were dark and slick with rain as shadows stretched across the parapet.',
        positionX: 420,
        positionY: 120,
        connectedNodeIds: [node1.id ?? 1],
        entityIds: [vampires.id ?? 2],
        status: 'in_progress',
      ),
    );

    final node3 = await savePlotNode(
      session,
      PlotNode(
        worldId: targetWorldId,
        title: 'Branch: Charging the Sunstone',
        summary:
            'Side quest to charge the relic atop Mount Solis before storm clouds roll in.',
        content: null,
        positionX: 420,
        positionY: 340,
        connectedNodeIds: [node1.id ?? 1],
        entityIds: [sunstone.id ?? 3],
        status: 'idea',
      ),
    );

    await savePlotNode(
      session,
      PlotNode(
        worldId: targetWorldId,
        title: 'Act 3: The Final Confrontation',
        summary: 'Elena confronts Morvath at the ancient temple.',
        content: null,
        positionX: 740,
        positionY: 220,
        connectedNodeIds: [node2.id ?? 2, node3.id ?? 3],
        entityIds: [elena.id ?? 1, vampires.id ?? 2, sunstone.id ?? 3],
        status: 'idea',
      ),
    );

    return true;
  }
}
