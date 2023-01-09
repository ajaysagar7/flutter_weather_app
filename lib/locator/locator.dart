import 'package:flutter_weather_app/repository/weather_repo.dart';
import 'package:get_it/get_it.dart';

import '../providers/weather_provider.dart';

final getIt = GetIt.instance;

Future<void> setUpLocator() async {
  //* for repo use registerLazySingleton

  getIt.registerLazySingleton(() => WeatherRepo());

  //* for provider use registerFactory()

  // getIt.registerFactory(() => WeatherProvider(getIt()));

  //* for others use registerLazySingleton
}
