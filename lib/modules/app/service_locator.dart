import 'package:get_it/get_it.dart';
import 'package:syazanou/http/http.dart';
import 'package:syazanou/modules/vk/repository.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  ServiceLocator._();

  static Future<void> initialize() async {
    getIt.registerSingleton<ApiClient>(ApiClient.instance());
    getIt.registerSingleton<VkRepository>(VkRepository());
  }

  static void dispose() {}

  static bool isRegistered<T extends Object>() {
    return getIt.isRegistered<T>();
  }

  static void unregister<T extends Object>() {
    if (getIt.isRegistered<T>()) {
      getIt.unregister<T>();
    }
  }

  static void registerSingleton<T extends Object>(T service) {
    if (!isRegistered<T>()) getIt.registerSingleton<T>(service);
  }

  static T get<T extends Object>() {
    return getIt<T>();
  }
}
