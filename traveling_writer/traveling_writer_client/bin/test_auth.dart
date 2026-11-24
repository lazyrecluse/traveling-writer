import 'package:traveling_writer_client/traveling_writer_client.dart';

void main() async {
  final client = Client('https://traveling-writer.api.serverpod.space/');
  try {
    print('Testing emailIdp.startRegistration on Serverpod Cloud...');
    final reqId = await client.emailIdp.startRegistration(email: 'test_writer@example.com');
    print('Registration started! Request ID: $reqId');
  } catch (e) {
    print('Registration failed: $e');
  }
}
