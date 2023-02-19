import 'package:flutter/material.dart';
import 'package:podcato/models/response_episode_model.dart';
import 'package:podcato/models/response_podcasts_model.dart';
import 'package:podcato/screens/detail_episode_page.dart';
import 'package:podcato/screens/detail_podcast_page.dart';
import 'package:podcato/screens/main_page.dart';
import 'package:podcato/screens/search_page.dart';

class MainRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const MainPage());
      case '/search':
        return MaterialPageRoute(builder: (_) => const SearchPage());
      case '/detail_episode':
        final argument = settings.arguments as DetailEpisodeArgument;
        return MaterialPageRoute(
            builder: (_) => DetailEpisodePage(
                id: argument.guid,
                listEpisode: argument.listEpisode,
                uuid: argument.uuid,
                index: argument.index));
      case '/detail_podcast':
        final argument = settings.arguments as DetailPodcastArgument;
        return MaterialPageRoute(
            builder: (_) => DetailPodcastPage(
                detail: argument.detail, uuid: argument.uuid));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(child: Text('Error page')),
      );
    });
  }
}

class DetailPodcastArgument {
  final Feeds detail;
  final String uuid;

  DetailPodcastArgument(this.detail, this.uuid);
}

class DetailEpisodeArgument {
  final String guid;
  final List<Items> listEpisode;
  final String uuid;
  final int index;

  DetailEpisodeArgument(this.guid, this.listEpisode, this.uuid, this.index);
}
