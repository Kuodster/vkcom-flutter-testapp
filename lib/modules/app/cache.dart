import 'package:hive/hive.dart' as hive;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:syazanou/modules/auth/models/access_token_data.dart';

class Cache {
  Cache._();

  static Future<void> initialize() async {
    await Hive.initFlutter();
    hive.Hive.registerAdapter(AccessTokenDataAdapter());
    await openBox<AccessTokenData>();
  }

  static Future<void> openBox<T>() async {
    await Hive.openBox<T>(T.toString());
  }

  static Box box<T>() {
    return Hive.box<T>(T.toString());
  }
}
