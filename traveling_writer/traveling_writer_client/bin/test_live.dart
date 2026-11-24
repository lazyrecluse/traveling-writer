import 'package:traveling_writer_client/traveling_writer_client.dart';

void main() async {
  print('--- Connecting to Live Serverpod Cloud API ---');
  final client = Client('https://traveling-writer.api.serverpod.space/');

  try {
    print('1. Seeding sample lore into live cloud database...');
    final seedResult = await client.continuity.seedSampleLore();
    print('Seed response: $seedResult');

    print('\n2. Fetching entities from live cloud database...');
    final entities = await client.continuity.listEntities();
    print('Found ${entities.length} entities:');
    for (final e in entities) {
      print(' - ${e.name} (${e.category}): ${e.description}');
    }

    print('\n3. Fetching rules from live cloud database...');
    final rules = await client.continuity.listRules();
    print('Found ${rules.length} rules:');
    for (final r in rules) {
      print(' - [${r.subject}] ${r.relation} ${r.constraint}');
    }

    print('\n4. Testing live AI Story Audit via Serverpod Cloud API...');
    final sampleText = 
      'The morning sun rose brilliantly over the horizon. Elena the Ranger drew her bow, '
      'winking with her left eye as she calculated the trajectory toward the beast.';
    final audit = await client.continuity.auditStory(sampleText);
    print('Is Consistent: ${audit.isConsistent}');
    print('Summary: ${audit.summary}');
    print('Violations detected: ${audit.violations.length}');
    for (final v in audit.violations) {
      print(' -> [${v.severity}] Violating text: "${v.textSnippet}"');
      print('    Entity: ${v.entityName}');
      print('    Broken Rule: ${v.brokenRule}');
      print('    Explanation: ${v.explanation}');
    }

    print('\n✅ SUCCESS: Live Serverpod Cloud Backend is 100% operational!');
  } catch (e, st) {
    print('Error testing live server: $e');
    print(st);
  } finally {
    client.close();
  }
}
