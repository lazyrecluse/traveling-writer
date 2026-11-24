import 'dart:io';
import 'package:traveling_writer_server/src/generated/protocol.dart';
import 'package:traveling_writer_server/src/continuity/continuity_service.dart';

void main() async {
  print('--- Testing Traveling Writer Continuity AI Engine ---');

  // Load API key from .env
  final envFile = File('/root/traveling-writer/.env');
  String apiKey = '';
  if (envFile.existsSync()) {
    for (final line in envFile.readAsLinesSync()) {
      if (line.startsWith('GROQ_API_KEY=')) {
        apiKey = line.split('=')[1].trim();
      }
    }
  }

  if (apiKey.isEmpty) {
    print('Error: GROQ_API_KEY not found in .env');
    exit(1);
  }

  print('Using Groq API Key: ${apiKey.substring(0, 10)}...');
  final service = ContinuityService(apiKey: apiKey);

  // Define World Canon Lore
  final entities = [
    WorldEntity(
      name: 'Elena the Ranger',
      category: 'Character',
      description: 'Elven scout who lost her left eye in the Great War.',
      traits: ['One-eyed', 'Mortal'],
      isActive: true,
    ),
    WorldEntity(
      name: 'Lord Morvath',
      category: 'Faction',
      description: 'Ancient Vampire Lord of the Obsidian Keep.',
      traits: ['Vampire', 'Fatal allergy to sunlight'],
      isActive: true,
    ),
  ];

  final rules = [
    WorldRule(
      subject: 'Elena the Ranger',
      relation: 'CANNOT',
      constraint: 'Aim or wink with her left eye',
      explanation: 'Elena lost her left eye during the war and wears an eyepatch over it.',
      severity: 'strict',
      isActive: true,
    ),
    WorldRule(
      subject: 'Lord Morvath',
      relation: 'CANNOT',
      constraint: 'Walk outside in daylight or under direct sunlight',
      explanation: 'Sunlight combusts vampire flesh immediately.',
      severity: 'strict',
      isActive: true,
    ),
  ];

  // Story with 3 paragraphs:
  // Para 0: Consistent
  // Para 1: Violates Elena's eye
  // Para 2: Violates Morvath's sunlight allergy
  final story = '''
The forest was quiet as morning broke over the canopy. Elena crept along the damp moss, listening intently for any sound of iron or hoofbeats.

Taking a deep breath, Elena raised her longbow. She carefully winked with her left eye through the iron sights to line up the shot on the distant stag.

Later that afternoon, Lord Morvath stepped out onto the open sunlit balcony. He leaned on the marble railing, enjoying the blazing midday sun beating down on his bare shoulders without a care in the world.
''';

  print('\nRunning continuity audit on story...');
  final stopwatch = Stopwatch()..start();
  final result = await service.auditStory(
    storyText: story,
    entities: entities,
    rules: rules,
  );
  stopwatch.stop();

  print('\n=============================================');
  print('=== AUDIT RESULTS (in ${stopwatch.elapsedMilliseconds}ms) ===');
  print('Consistent: ${result.isConsistent}');
  print('Summary: ${result.summary}');
  print('Total Violations Found: ${result.violations.length}');
  print('=============================================');

  for (var i = 0; i < result.violations.length; i++) {
    final v = result.violations[i];
    print('\n[ALERT #${i + 1}]');
    print('  Paragraph Index : ${v.paragraphIndex}');
    print('  Entity Involved  : ${v.entityName}');
    print('  Rule Violated    : ${v.brokenRule}');
    print('  Offending Snippet: "${v.textSnippet}"');
    print('  Why it broke lore: ${v.explanation}');
  }
}
