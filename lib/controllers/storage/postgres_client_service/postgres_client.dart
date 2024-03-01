import 'package:postgres/postgres.dart';

class PostgreSQLClientService {
  static Future<void> connectToPostgresLocalServer() async {
    final conn = await Connection.open(Endpoint(
      host: 'localhost',
      port: 5432,
      database: 'postgres',
      username: 'postgres',
      password: '',
    ));
  }
}
