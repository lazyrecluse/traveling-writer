import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class ContinuityService {
  static const String _groqEndpoint =
      'https://api.groq.com/openai/v1/chat/completions';
  static const String _defaultModel = 'qwen/qwen3.8-27b';

  final Session? session;
  final String apiKey;
  final String model;

  ContinuityService({
    this.session,
    required this.apiKey,
    String? model,
  }) : model = model ?? _defaultModel;

  factory ContinuityService.fromSession(Session session) {
    final keyFromEnv = Platform.environment['GROQ_API_KEY'];
    final keyFromPasswords = session.passwords['groqApiKey'];
    final key = (keyFromEnv != null && keyFromEnv.isNotEmpty)
        ? keyFromEnv
        : (keyFromPasswords ?? '');
    return ContinuityService(session: session, apiKey: key);
  }

  /// Audits the given story text against the lore rules and entities.
  Future<AuditResult> auditStory({
    required String storyText,
    required List<WorldEntity> entities,
    required List<WorldRule> rules,
  }) async {
    final paragraphs = storyText
        .split(RegExp(r'\n\s*\n|\r\n\s*\r\n'))
        .where((p) => p.trim().isNotEmpty)
        .toList();

    if (paragraphs.isEmpty) {
      return AuditResult(
        storyText: storyText,
        totalParagraphs: 0,
        violations: [],
        isConsistent: true,
        summary: 'Story is empty.',
        auditedAt: DateTime.now(),
      );
    }

    if (rules.isEmpty && entities.isEmpty) {
      return AuditResult(
        storyText: storyText,
        totalParagraphs: paragraphs.length,
        violations: [],
        isConsistent: true,
        summary: 'No world rules or entities defined to check against.',
        auditedAt: DateTime.now(),
      );
    }

    // Format World Lore Graph into prompt context
    final loreBuffer = StringBuffer();
    loreBuffer.writeln('=== WORLD LORE & KNOWLEDGE GRAPH ===');
    if (entities.isNotEmpty) {
      loreBuffer.writeln('ENTITIES:');
      for (final e in entities) {
        final traits = (e.traits != null && e.traits!.isNotEmpty)
            ? ' (Traits: ${e.traits!.join(", ")})'
            : '';
        loreBuffer.writeln(
          '- [${e.category.toUpperCase()}] ${e.name}$traits: ${e.description}',
        );
      }
    }

    if (rules.isNotEmpty) {
      loreBuffer.writeln('\nCANON RULES & CONSTRAINTS:');
      for (var i = 0; i < rules.length; i++) {
        final r = rules[i];
        final expl = r.explanation != null
            ? ' | Context: ${r.explanation}'
            : '';
        loreBuffer.writeln(
          'Rule #${i + 1} [Severity: ${r.severity}]: ${r.subject} ${r.relation} ${r.constraint}$expl',
        );
      }
    }

    // Format Story Paragraphs with 0-based indices
    final storyBuffer = StringBuffer();
    storyBuffer.writeln('=== STORY TEXT (PARAGRAPH-BY-PARAGRAPH) ===');
    for (var i = 0; i < paragraphs.length; i++) {
      storyBuffer.writeln('--- PARAGRAPH $i ---');
      storyBuffer.writeln(paragraphs[i].trim());
    }

    final systemPrompt = '''
You are "Traveling Writer" — an elite fiction continuity auditor and lore guardian.
Your mission: Audit the author's story text strictly against the predefined World Lore and Canon Rules.
Detect any plot holes, physical contradictions, magic system violations, or character trait contradictions.

Rules:
1. ONLY flag contradictions that conflict with the provided World Lore & Canon Rules.
2. For each violation, specify:
   - paragraphIndex: The integer index (0-based) where the violation occurs.
   - textSnippet: The exact phrase or sentence in that paragraph that contradicts the rule.
   - entityName: The entity or subject involved.
   - brokenRule: The specific rule violated.
   - explanation: Clear, actionable explanation of WHY this contradicts the world lore.
   - severity: "strict" or "warning".
3. Return strict JSON matching this structure:
{
  "isConsistent": false,
  "summary": "Brief 1-2 sentence overall continuity evaluation.",
  "violations": [
    {
      "paragraphIndex": 0,
      "textSnippet": "quoted text snippet",
      "entityName": "Name",
      "brokenRule": "Rule description",
      "explanation": "Why it violates lore",
      "severity": "strict"
    }
  ]
}
If no contradictions are found, set "isConsistent": true and "violations": [].
''';

    final userContent =
        '''
$loreBuffer

$storyBuffer

Audit the story above against the world lore rules and output the JSON result.
''';

    try {
      final response = await http.post(
        Uri.parse(_groqEndpoint),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': model,
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': userContent},
          ],
          'response_format': {'type': 'json_object'},
          'temperature': 0.1,
          'max_tokens': 4096,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Groq API error (${response.statusCode}): ${response.body}',
        );
      }

      final body = jsonDecode(utf8.decode(response.bodyBytes));
      final choice = body['choices']?[0]?['message']?['content'] ?? '{}';
      final parsed = jsonDecode(choice) as Map<String, dynamic>;

      final isConsistent = parsed['isConsistent'] as bool? ?? true;
      final summary =
          parsed['summary'] as String? ?? 'Continuity check completed.';
      final rawViolations = (parsed['violations'] as List?) ?? [];

      final violations = <ContinuityViolation>[];
      for (final v in rawViolations) {
        if (v is Map<String, dynamic>) {
          violations.add(
            ContinuityViolation(
              paragraphIndex: (v['paragraphIndex'] as num?)?.toInt() ?? 0,
              textSnippet: v['textSnippet'] as String? ?? '',
              entityName: v['entityName'] as String? ?? 'Unknown',
              brokenRule: v['brokenRule'] as String? ?? '',
              explanation: v['explanation'] as String? ?? '',
              severity: v['severity'] as String? ?? 'warning',
            ),
          );
        }
      }

      return AuditResult(
        storyText: storyText,
        totalParagraphs: paragraphs.length,
        violations: violations,
        isConsistent: isConsistent,
        summary: summary,
        auditedAt: DateTime.now(),
      );
    } catch (e, stack) {
      if (session != null) {
        session!.log(
          'Continuity audit failed: $e',
          level: LogLevel.error,
          stackTrace: stack,
        );
      } else {
        print('Continuity audit failed: $e\n$stack');
      }
      return AuditResult(
        storyText: storyText,
        totalParagraphs: paragraphs.length,
        violations: [],
        isConsistent: false,
        summary:
            'Sorry, an error occurred during the continuity audit. Our guardian team has been notified. Please try again in a moment.',
        auditedAt: DateTime.now(),
      );
    }
  }
}
