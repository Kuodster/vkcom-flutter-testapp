import 'package:syazanou/http/http.dart';
import 'package:syazanou/modules/app/service_locator.dart';

abstract class BaseRepository {
  late final ApiClient client;

  BaseRepository() {
    client = ServiceLocator.get<ApiClient>();
  }
}
