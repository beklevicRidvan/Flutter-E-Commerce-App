import 'package:get_it/get_it.dart';

import '../repository/database_repository.dart';
import '../service/auth/auth_service.dart';
import '../service/firestore/firestore_service.dart';
import '../service/http/adress_service.dart';

final GetIt locator = GetIt.instance;

setupLocator() {
  locator.registerLazySingleton(() => DatabaseRepository());
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => HttpApiService());
}
