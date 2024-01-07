import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:podcato/audio_services/page_manager.dart';
import 'package:podcato/audio_services/services/service_locator.dart';
import 'package:podcato/blocs/categories/categories_bloc.dart';
import 'package:podcato/blocs/detail_podcast/detail_podcast_bloc.dart';
import 'package:podcato/blocs/podcast_search/podcast_search_bloc.dart';
import 'package:podcato/blocs/podcast_trending/podcast_trending_bloc.dart';
import 'package:podcato/providers/api_provider.dart';
import 'package:podcato/repositories/main_repository.dart';
import 'package:podcato/routers/main_router.dart';

Future<void> main() async {
  await setupServiceLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null)
      .then((_) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    getIt<PageManager>().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<MainRepository>(
          create: (context) => MainRepository(),
          lazy: true,
        ),
        RepositoryProvider<ApiProvider>(
          create: (context) => ApiProvider(),
          lazy: true,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<PodcastSearchBloc>(
            create: (context) => PodcastSearchBloc(),
          ),
          BlocProvider<PodcastTrendingBloc>(
            create: (context) => PodcastTrendingBloc(),
          ),
          BlocProvider<DetailPodcastBloc>(
            create: (context) => DetailPodcastBloc(),
          ),
          BlocProvider<CategoriesBloc>(
            create: (context) => CategoriesBloc(),
          ),
        ],
        child: MaterialApp(
          title: 'Moodly',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          onGenerateRoute: MainRouter.generateRoute,
        ),
      ),
    );
  }
}
