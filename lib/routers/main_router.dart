import 'package:flutter/material.dart';
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
      case '/detail_podcast':
        final argument = settings.arguments as DetailPodcastArgument;
        return MaterialPageRoute(
            builder: (_) => DetailPodcastPage(
                id: argument.guid,
                podcastName: argument.podcastName,
                uuid: argument.uuid));
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
  final String guid;
  final String podcastName;
  final String uuid;

  DetailPodcastArgument(this.guid, this.podcastName, this.uuid);
}
