import 'package:get_it/get_it.dart';
import 'core/network/api_client.dart';
import 'features/career_kit/data/repositories/career_kit_repository.dart';
import 'features/career_kit/presentation/bloc/career_kit_bloc.dart';
import 'features/resume/data/repositories/resume_repository.dart';
import 'features/resume/presentation/bloc/resume_bloc.dart';

import 'core/constants/env_config.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => ApiClient(baseUrl: EnvConfig.backendUrl));
  
  // Repositories
  sl.registerLazySingleton(() => CareerKitRepository(apiClient: sl()));
  sl.registerLazySingleton(() => ResumeRepository(apiClient: sl()));
  
  // Blocs
  sl.registerFactory(() => CareerKitBloc(repository: sl()));
  sl.registerFactory(() => ResumeBloc(repository: sl()));
}
