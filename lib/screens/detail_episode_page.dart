import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:podcato/audio_services/notifiers/play_button_notifier.dart';
import 'package:podcato/audio_services/notifiers/progress_notifier.dart';
import 'package:podcato/audio_services/page_manager.dart';
import 'package:podcato/audio_services/services/service_locator.dart';
import 'package:podcato/models/response_episode_model.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailEpisodePage extends StatefulWidget {
  final String id;
  final String uuid;
  final List<Items> listEpisode;
  final int index;

  const DetailEpisodePage(
      {Key? key,
      required this.id,
      required this.uuid,
      required this.listEpisode,
      required this.index})
      : super(key: key);

  @override
  _DetailEpisodePageState createState() => _DetailEpisodePageState();
}

class _DetailEpisodePageState extends State<DetailEpisodePage> {
  final pageManager = getIt<PageManager>();
  @override
  void initState() {
    // getIt<PageManager>().clearQueue();
    if (pageManager.currentSongNotifier.value.id != widget.id) {
      getIt<PageManager>().init(widget.listEpisode, widget.index, widget.uuid);
      getIt<PageManager>().play();
    }
    super.initState();
  }

  String titlePodcast(int index) {
    if (widget.listEpisode.asMap().containsKey(index)) {
      return widget.listEpisode[index].title ?? "";
    }
    return "";
  }

  String completeUrl(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    } else {
      return 'https://$url';
    }
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(completeUrl(url)))) {
      const snackBar = SnackBar(
        content: Text('Cannot Open URL'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => {
                      Navigator.pop(context, pageManager.currentSongIndex.value)
                    },
                    icon: const Icon(
                      Icons.chevron_left_rounded,
                    ),
                  ),
                  const Expanded(
                      child: Text(
                    'Detail Episode',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15),
                  )),
                  IconButton(
                    onPressed: () =>
                        _launchUrl(widget.listEpisode[widget.index].link ?? ""),
                    icon: const Icon(
                      Icons.open_in_new_rounded,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Hero(
              tag: '',
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                child: CachedNetworkImage(
                  imageUrl: widget.listEpisode[widget.index].feedImage ?? "",
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    enabled: true,
                    child: Container(
                      width: double.infinity,
                      height: 300,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: double.infinity,
                    height: 300,
                    color: Colors.amber,
                    alignment: Alignment.center,
                    child: const Text(
                      'Whoops!',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: ValueListenableBuilder<int>(
                valueListenable: pageManager.currentSongIndex,
                builder: (_, currentIndex, __) {
                  return Text(
                    titlePodcast(currentIndex),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: ValueListenableBuilder<int>(
                valueListenable: pageManager.currentSongIndex,
                builder: (_, currentIndex, __) {
                  return Text(
                    pageManager.bunchOfListItems[currentIndex].description ??
                        "",
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  );
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const AudioProgressBar(),
            ),
            SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  PreviousSongButton(index: widget.index, id: widget.id),
                  const PlayButton(),
                  NextSongButton(index: widget.index, id: widget.id),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: _buildBody()));
  }
}

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: pageManager.progressNotifier,
      builder: (_, value, __) {
        return ProgressBar(
          baseBarColor: Colors.grey.shade300,
          bufferedBarColor: Colors.grey.shade600,
          progressBarColor: Colors.black,
          thumbColor: Colors.black,
          thumbRadius: 8,
          progress: value.current,
          buffered: value.buffered,
          total: value.total,
          onSeek: pageManager.seek,
        );
      },
    );
  }
}

class PreviousSongButton extends StatelessWidget {
  final int index;
  final String id;

  const PreviousSongButton({Key? key, required this.index, required this.id})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<int>(
      valueListenable: pageManager.currentSongIndex,
      builder: (_, currentIndex, __) {
        return IconButton(
          icon: const Icon(Icons.skip_previous),
          onPressed: () {
            if (currentIndex > 0) {
              pageManager.previous(currentIndex, id);
            } else {
              null;
            }
          },
        );
      },
    );
  }
}

class PlayButton extends StatelessWidget {
  const PlayButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<ButtonState>(
      valueListenable: pageManager.playButtonNotifier,
      builder: (_, value, __) {
        switch (value) {
          case ButtonState.loading:
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              width: 32.0,
              height: 32.0,
              child: const CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 2,
              ),
            );
          case ButtonState.paused:
            return IconButton(
              icon: const Icon(Icons.play_arrow),
              iconSize: 32.0,
              onPressed: pageManager.play,
            );
          case ButtonState.playing:
            return IconButton(
              icon: const Icon(Icons.pause),
              iconSize: 32.0,
              onPressed: pageManager.pause,
            );
        }
      },
    );
  }
}

class NextSongButton extends StatelessWidget {
  final int index;
  final String id;

  const NextSongButton({Key? key, required this.index, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageManager = getIt<PageManager>();
    return ValueListenableBuilder<int>(
      valueListenable: pageManager.currentSongIndex,
      builder: (_, currentIndex, __) {
        return IconButton(
          icon: const Icon(Icons.skip_next),
          onPressed: () {
            if ((currentIndex + 1) < pageManager.bunchOfListItems.length) {
              pageManager.next(currentIndex, id);
            }
          },
        );
      },
    );
  }
}
