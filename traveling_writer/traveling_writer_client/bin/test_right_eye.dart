import 'package:traveling_writer_client/traveling_writer_client.dart';

void main() async {
  final client = Client('https://traveling-writer.api.serverpod.space/');
  final text = '''The forest was quiet as morning broke over the canopy. Elena crept along the damp moss, listening intently for any sound of iron or hoofbeats.

Taking a deep breath, Elena raised her longbow. She carefully aimed through the iron sights with her right eye to line up the shot on the distant stag.

Later that afternoon, Lord Morvath stepped out onto the open sunlit balcony. He leaned on the marble railing, enjoying the blazing midday sun beating down on his bare shoulders without a care in the world.''';

  final result = await client.continuity.auditStory(text);
  print('isConsistent: ${result.isConsistent}');
  print('summary: ${result.summary}');
  print('violations count: ${result.violations.length}');
  for (final v in result.violations) {
    print(' -> textSnippet: "${v.textSnippet}"');
    print('    entity: ${v.entityName}');
    print('    brokenRule: ${v.brokenRule}');
    print('    explanation: ${v.explanation}');
  }
}
