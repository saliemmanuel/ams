import 'package:ams/services/services_auth.dart';
import 'package:get_it/get_it.dart';

import '../auth/firebase_auth.dart';
import '../messaging/messaging.dart';
import '../provider/home_provider.dart';

var locator = GetIt.instance;

class ServiceLocator {
  static initServiceLocator() {
    locator.registerLazySingleton<ServiceAuth>(() => ServiceAuth());
    locator.registerLazySingleton<FirebasesAuth>(() => FirebasesAuth());
    locator.registerLazySingleton<FireMessageging>(() => FireMessageging());
    locator.registerLazySingleton<HomeProvider>(() => HomeProvider());
    
  }
}
