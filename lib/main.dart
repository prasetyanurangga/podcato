import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podcato/blocs/detail_podcast/detail_podcast_bloc.dart';
import 'package:podcato/blocs/podcast_search/podcast_search_bloc.dart';
import 'package:podcato/blocs/podcast_trending/podcast_trending_bloc.dart';
import 'package:podcato/providers/api_provider.dart';
import 'package:podcato/repositories/main_repository.dart';
import 'package:podcato/routers/main_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
