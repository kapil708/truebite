import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/services/gemini_service.dart';
import '../core/utils/network_info.dart';
import '../data/repositories/gemini_repository.dart';
import '../data/sources/local/preferences_provider.dart';
import '../presentation/app/viewmodel/app_bloc.dart';
import '../presentation/features/food_detail/viewmodel/food_detail_cubit.dart';
import '../presentation/features/home/viewmodel/home_cubit.dart';
import '../presentation/features/splash/viewmodel/splash_cubit.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // Features
  locator.registerFactory(() => SplashCubit());
  locator.registerFactory(() => HomeCubit());
  locator.registerFactory(() => FoodDetailCubit(geminiRepository: locator<GeminiRepository>()));
  locator.registerLazySingleton(() => AppBloc());

  // Repositories
  locator.registerLazySingleton(() => GeminiRepository(geminiService: locator<GeminiService>(), networkInfo: locator<NetworkInfo>()));

  // Sources
  locator.registerLazySingleton(() => PreferencesProvider(prefs: locator<SharedPreferences>()));

  // Core
  locator.registerLazySingleton(() => GeminiService());
  locator.registerLazySingleton(() => NetworkInfo(internetConnection: locator<InternetConnection>()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => sharedPreferences);
  locator.registerLazySingleton(() => InternetConnection());
}

Future<void> setUp() async {
  // Features
  // locator.registerFactory(() => LoginBloc(loginUseCase: locator(), localDataSource: locator()));
  // locator.registerFactory(() => PacketFoodCubit());
  // locator.registerFactory(() => FoodDetailCubit(aiUseCase: locator()));
  // locator.registerFactory(() => FoodDetailJsonCubit(aiUseCase: locator()));

  // Use case
  // locator.registerLazySingleton(() => LoginUseCase(userRepository: locator()));
  // locator.registerLazySingleton(() => AiUseCase(aiRepository: locator()));

  // Repositories
  // locator.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(remoteDataSource: locator(), networkInfo: locator()));
  // locator.registerLazySingleton<AiRepository>(() => AiRepositoryImpl(remoteDataSource: locator(), networkInfo: locator()));

  // Data source
  // locator.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl(client: locator()));
  // locator.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl(sharedPreferences: locator()));

  // Core
  // locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(internetConnection: locator()));

  // External
  // final sharedPreferences = await SharedPreferences.getInstance();
  // locator.registerLazySingleton(() => sharedPreferences);
  // locator.registerLazySingleton(() => http.Client());
  // locator.registerLazySingleton(() => InternetConnection());
}
