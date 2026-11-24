import 'package:traveling_writer_client/traveling_writer_client.dart';

const _uuid = Uuid();

class DiscoveredEntity {
  final String id;
  final String name;
  final String category; // Character, Artifact, Faction, Location
  final String description;
  final List<String> traits;
  final String contextSnippet;
  final String chapterId;
  final String chapterTitle;
  bool isReviewed;

  DiscoveredEntity({
    String? id,
    required this.name,
    required this.category,
    required this.description,
    required this.traits,
    required this.contextSnippet,
    required this.chapterId,
    required this.chapterTitle,
    this.isReviewed = false,
  }) : id = id ?? _uuid.v4();

  String get signature => name.toLowerCase().trim();

  WorldEntity toWorldEntity({int? worldId}) {
    return WorldEntity(
      worldId: worldId,
      name: name,
      category: category,
      description: '$description (Discovered in $chapterTitle)',
      traits: traits,
      isActive: true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'description': description,
        'traits': traits,
        'contextSnippet': contextSnippet,
        'chapterId': chapterId,
        'chapterTitle': chapterTitle,
        'isReviewed': isReviewed,
      };

  factory DiscoveredEntity.fromJson(Map<String, dynamic> json) =>
      DiscoveredEntity(
        id: json['id'] as String? ?? _uuid.v4(),
        name: json['name'] as String? ?? '',
        category: json['category'] as String? ?? 'Character',
        description: json['description'] as String? ?? '',
        traits: (json['traits'] as List<dynamic>?)
                ?.map((t) => t.toString())
                .toList() ??
            [],
        contextSnippet: json['contextSnippet'] as String? ?? '',
        chapterId: json['chapterId'] as String? ?? '',
        chapterTitle: json['chapterTitle'] as String? ?? '',
        isReviewed: json['isReviewed'] as bool? ?? false,
      );
}

class DiscoveredRule {
  final String id;
  final String subject;
  final String relation; // CANNOT, MUST, REQUIRES, IMMUNE TO, etc.
  final String constraint;
  final String contextSnippet;
  final String explanation;
  final String chapterId;
  final String chapterTitle;
  bool isReviewed;

  DiscoveredRule({
    String? id,
    required this.subject,
    required this.relation,
    required this.constraint,
    required this.contextSnippet,
    required this.explanation,
    required this.chapterId,
    required this.chapterTitle,
    this.isReviewed = false,
  }) : id = id ?? _uuid.v4();

  String get signature =>
      '${subject.toLowerCase().trim()}|${constraint.toLowerCase().trim()}';

  WorldRule toWorldRule({int? worldId}) {
    return WorldRule(
      worldId: worldId,
      subject: subject,
      relation: relation,
      constraint: constraint,
      explanation: '$explanation (Discovered from $chapterTitle)',
      severity: 'strict',
      isActive: true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'subject': subject,
        'relation': relation,
        'constraint': constraint,
        'contextSnippet': contextSnippet,
        'explanation': explanation,
        'chapterId': chapterId,
        'chapterTitle': chapterTitle,
        'isReviewed': isReviewed,
      };

  factory DiscoveredRule.fromJson(Map<String, dynamic> json) => DiscoveredRule(
        id: json['id'] as String? ?? _uuid.v4(),
        subject: json['subject'] as String? ?? '',
        relation: json['relation'] as String? ?? 'CANNOT',
        constraint: json['constraint'] as String? ?? '',
        contextSnippet: json['contextSnippet'] as String? ?? '',
        explanation: json['explanation'] as String? ?? '',
        chapterId: json['chapterId'] as String? ?? '',
        chapterTitle: json['chapterTitle'] as String? ?? '',
        isReviewed: json['isReviewed'] as bool? ?? false,
      );
}

class Chapter {
  final String id;
  String title;
  String content;
  AuditResult? auditResult;
  List<DiscoveredRule> discoveredRules;
  List<DiscoveredEntity> discoveredEntities;
  DateTime lastEdited;

  Chapter({
    String? id,
    required this.title,
    required this.content,
    this.auditResult,
    List<DiscoveredRule>? discoveredRules,
    List<DiscoveredEntity>? discoveredEntities,
    DateTime? lastEdited,
  })  : id = id ?? _uuid.v4(),
        discoveredRules = discoveredRules ?? [],
        discoveredEntities = discoveredEntities ?? [],
        lastEdited = lastEdited ?? DateTime.now();

  int get wordCount {
    if (content.trim().isEmpty) return 0;
    return content.trim().split(RegExp(r'\s+')).length;
  }

  bool get isConflicting => auditResult != null && !auditResult!.isConsistent;

  bool get isConsistent => auditResult != null && auditResult!.isConsistent;

  bool get isDraft => auditResult == null;

  int get conflictCount =>
      auditResult != null ? auditResult!.violations.length : 0;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'auditResult':
            auditResult != null ? _auditResultToJson(auditResult!) : null,
        'discoveredRules': discoveredRules.map((r) => r.toJson()).toList(),
        'discoveredEntities':
            discoveredEntities.map((e) => e.toJson()).toList(),
        'lastEdited': lastEdited.toIso8601String(),
      };

  factory Chapter.fromJson(Map<String, dynamic> json) {
    AuditResult? audit;
    if (json['auditResult'] != null) {
      try {
        audit = _auditResultFromJson(
            Map<String, dynamic>.from(json['auditResult'] as Map));
      } catch (_) {}
    }
    return Chapter(
      id: json['id'] as String? ?? _uuid.v4(),
      title: json['title'] as String? ?? 'Untitled Chapter',
      content: json['content'] as String? ?? '',
      auditResult: audit,
      discoveredRules: (json['discoveredRules'] as List<dynamic>?)
              ?.map((r) =>
                  DiscoveredRule.fromJson(Map<String, dynamic>.from(r as Map)))
              .toList() ??
          [],
      discoveredEntities: (json['discoveredEntities'] as List<dynamic>?)
              ?.map((e) => DiscoveredEntity.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList() ??
          [],
      lastEdited: json['lastEdited'] != null
          ? DateTime.tryParse(json['lastEdited'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  static Map<String, dynamic> _auditResultToJson(AuditResult audit) {
    return {
      'storyText': audit.storyText,
      'totalParagraphs': audit.totalParagraphs,
      'isConsistent': audit.isConsistent,
      'summary': audit.summary,
      'auditedAt': audit.auditedAt.toIso8601String(),
      'violations': audit.violations
          .map((v) => {
                'paragraphIndex': v.paragraphIndex,
                'textSnippet': v.textSnippet,
                'entityName': v.entityName,
                'brokenRule': v.brokenRule,
                'explanation': v.explanation,
                'severity': v.severity,
              })
          .toList(),
    };
  }

  static AuditResult _auditResultFromJson(Map<String, dynamic> json) {
    final violationsRaw = (json['violations'] as List<dynamic>?) ?? [];
    final violations = violationsRaw.map((v) {
      final map = Map<String, dynamic>.from(v as Map);
      return ContinuityViolation(
        paragraphIndex: map['paragraphIndex'] as int? ?? 0,
        textSnippet: map['textSnippet'] as String? ?? '',
        entityName: map['entityName'] as String? ?? '',
        brokenRule: map['brokenRule'] as String? ?? '',
        explanation: map['explanation'] as String? ?? '',
        severity: map['severity'] as String? ?? 'strict',
      );
    }).toList();

    return AuditResult(
      storyText: json['storyText'] as String? ?? '',
      totalParagraphs: json['totalParagraphs'] as int? ?? 0,
      violations: violations,
      isConsistent: json['isConsistent'] as bool? ?? true,
      summary: json['summary'] as String? ?? '',
      auditedAt: json['auditedAt'] != null
          ? DateTime.tryParse(json['auditedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}

class DiscoveredLoreResult {
  final List<DiscoveredRule> rules;
  final List<DiscoveredEntity> entities;

  DiscoveredLoreResult({required this.rules, required this.entities});
}

/// Discovers candidate lore rules and entities mentioned in narrative prose
DiscoveredLoreResult extractPotentialLoreFromText({
  required String text,
  required String chapterId,
  required String chapterTitle,
  required List<WorldRule> existingRules,
  required List<WorldEntity> existingEntities,
  Set<String>? dismissedSignatures,
}) {
  final rules = <DiscoveredRule>[];
  final entities = <DiscoveredEntity>[];
  if (text.trim().isEmpty) {
    return DiscoveredLoreResult(rules: rules, entities: entities);
  }

  final dismissed = dismissedSignatures ?? <String>{};

  // Split into sentences
  final sentences = text
      .replaceAll(RegExp(r'\n+'), ' ')
      .split(RegExp(r'(?<=[.!?])\s+'))
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toList();

  // 1. EXTRACT POTENTIAL RULES
  final rulePatterns = [
    {
      'regex': RegExp(
          r'\b([A-Z][a-zA-Z0-9\s]{2,25}?)\s+(cannot|can never|is unable to|could not)\s+([^.,;!?]{4,80})',
          caseSensitive: false),
      'relation': 'CANNOT',
    },
    {
      'regex': RegExp(
          r'\b([A-Z][a-zA-Z0-9\s]{2,25}?)\s+(must always|must|is required to|shall always)\s+([^.,;!?]{4,80})',
          caseSensitive: false),
      'relation': 'MUST',
    },
    {
      'regex': RegExp(
          r'\b([A-Z][a-zA-Z0-9\s]{2,25}?)\s+(is immune to|are immune to|is impervious to)\s+([^.,;!?]{4,80})',
          caseSensitive: false),
      'relation': 'IMMUNE TO',
    },
    {
      'regex': RegExp(
          r'\b([A-Z][a-zA-Z0-9\s]{2,25}?)\s+(requires|require|needs)\s+([^.,;!?]{4,80})',
          caseSensitive: false),
      'relation': 'REQUIRES',
    },
    {
      'regex': RegExp(
          r'\b([A-Z][a-zA-Z0-9\s]{2,25}?)\s+(is vulnerable to|burns in|cannot tolerate)\s+([^.,;!?]{4,80})',
          caseSensitive: false),
      'relation': 'CANNOT',
    },
  ];

  for (final sentence in sentences) {
    for (final pat in rulePatterns) {
      final reg = pat['regex'] as RegExp;
      final match = reg.firstMatch(sentence);
      if (match != null) {
        var rawSubject = match.group(1)?.trim() ?? '';
        final rawConstraint = match.group(3)?.trim() ?? '';
        final relation = pat['relation'] as String;

        if (rawSubject.toLowerCase().startsWith('the ')) {
          rawSubject = rawSubject.substring(4);
        }

        if (rawSubject.length < 3 || rawConstraint.length < 4) continue;

        final sig =
            '${rawSubject.toLowerCase()}|${rawConstraint.toLowerCase()}';
        if (dismissed.contains(sig)) continue;

        final alreadyExists = existingRules.any((r) =>
            r.subject.toLowerCase() == rawSubject.toLowerCase() &&
            r.relation.toLowerCase() == relation.toLowerCase());

        if (!alreadyExists &&
            !rules.any((r) =>
                r.subject.toLowerCase() == rawSubject.toLowerCase() &&
                r.constraint.toLowerCase() == rawConstraint.toLowerCase())) {
          rules.add(
            DiscoveredRule(
              id: 'rule_${_uuid.v4()}',
              subject: rawSubject,
              relation: relation,
              constraint: rawConstraint,
              contextSnippet: sentence,
              explanation:
                  'Observed in prose: "$rawSubject $relation $rawConstraint"',
              chapterId: chapterId,
              chapterTitle: chapterTitle,
            ),
          );
        }
      }
    }
  }

  // 2. EXTRACT POTENTIAL ENTITIES (Characters, Artifacts, Factions)
  final entityPatterns = [
    {
      'regex': RegExp(
          r'\b((?:Lord|Lady|Sir|Archmage|Captain|Queen|King|Prince|Princess|Master|Elder)\s+[A-Z][a-z]+(?:\s+[A-Z][a-z]+)?)\b'),
      'category': 'Character',
    },
    {
      'regex': RegExp(
          r'\b([A-Z][a-z]+(?:\s+of\s+[A-Z][a-z]+|\s+(?:Blade|Sword|Bow|Amulet|Stone|Staff|Crystal|Tome|Shield|Relic|Dagger|Scepter)))\b'),
      'category': 'Artifact',
    },
    {
      'regex': RegExp(
          r'\b([A-Z][a-z]+(?:\s+(?:Clan|Order|Guild|Scouts|Legion|Bloodline|Brotherhood|Coven)))\b'),
      'category': 'Faction',
    },
  ];

  for (final sentence in sentences) {
    for (final pat in entityPatterns) {
      final reg = pat['regex'] as RegExp;
      final matches = reg.allMatches(sentence);
      for (final match in matches) {
        final name = match.group(1)?.trim() ?? '';
        final category = pat['category'] as String;

        if (name.length < 3) continue;

        final sig = name.toLowerCase();
        if (dismissed.contains(sig)) continue;

        final alreadyExists = existingEntities.any((e) =>
            e.name.toLowerCase() == name.toLowerCase() ||
            name.toLowerCase().contains(e.name.toLowerCase()));

        if (!alreadyExists &&
            !entities.any((e) => e.name.toLowerCase() == name.toLowerCase())) {
          entities.add(
            DiscoveredEntity(
              id: 'entity_${_uuid.v4()}',
              name: name,
              category: category,
              description: 'Appears in "$chapterTitle"',
              traits: ['Identified from narrative draft'],
              contextSnippet: sentence,
              chapterId: chapterId,
              chapterTitle: chapterTitle,
            ),
          );
        }
      }
    }
  }

  return DiscoveredLoreResult(rules: rules, entities: entities);
}
