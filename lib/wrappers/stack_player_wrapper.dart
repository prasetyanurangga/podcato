import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:podcato/audio_services/notifiers/play_button_notifier.dart';
import 'package:podcato/audio_services/notifiers/progress_notifier.dart';
import 'package:podcato/audio_services/page_manager.dart';
import 'package:podcato/audio_services/services/service_locator.dart';
import 'package:podcato/routers/main_router.dart';
import 'package:shimmer/shimmer.dart';

class StackPlayerWrapper extends StatefulWidget {
  final Widget child;
  final String artwork;
  const StackPlayerWrapper(
      {Key? key, required this.child, required this.artwork})
      : super(key: key);

  @override
  _StackPlayerWrapperState createState() => _StackPlayerWrapperState();
}

class _StackPlayerWrapperState extends State<StackPlayerWrapper> {
  bool isPlaying = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  late PageManager pageManager;
  int currentIndex = 0;

  @override
  void initState() {
    pageManager = getIt<PageManager>();
    super.initState();
  }

  void handlePlayPause(bool currentStatus) {
    setState(() {
      isPlaying = !currentStatus;
      if (isPlaying) {
        pageManager.play();
        // playAudio();
      } else {
        pageManager.pause();
        // pauseAudio();
      }
    });
  }

  String formatedTime(int timeInSecond) {
    if (timeInSecond > 3600) {
      int sec = timeInSecond % 60;
      int tempMen = ((timeInSecond - sec) / 60).floor();
      int min = tempMen % 60;

      int hr = ((tempMen - min) / 60).floor();
      return "$hr jam $min menit $sec detik";
    } else {
      int sec = timeInSecond % 60;
      int min = (timeInSecond / 60).floor();
      return "$min menit $sec detik";
    }
  }

  String formatedTimes(int timeInSecond) {
    if (timeInSecond > 3600) {
      int sec = timeInSecond % 60;
      int tempMen = ((timeInSecond - sec) / 60).floor();
      int min = tempMen % 60;

      int hr = ((tempMen - min) / 60).floor();
      String hour = hr >= 10 ? "$hr" : "0$hr";
      String minute = min >= 10 ? "$min" : "0$min";
      String second = sec >= 10 ? "$sec" : "0$sec";
      return "$hour:$minute:$second";
    } else {
      int sec = timeInSecond % 60;
      int min = (timeInSecond / 60).floor();
      String minute = min >= 10 ? "$min" : "0$min";
      String second = sec >= 10 ? "$sec" : "0$sec";
      return "$minute:$second";
    }
  }

  Future<void> closePlayBottomSheet() async {
    await pageManager.stop();
    pageManager.currentSongIndex.value = -1;
    pageManager.currentSongNotifier.value = const MediaItem(id: "", title: "");

    setState(() {
      currentIndex = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            widget.child,
            ValueListenableBuilder<MediaItem>(
              valueListenable: pageManager.currentSongNotifier,
              builder: (_, currentMedia, __) {
                final currentExtras = currentMedia.extras ?? {};
                return AnimatedPositioned(
                  bottom: (currentMedia.id != "") ? 0 : -150,
                  left: 0,
                  right: 0,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.16),
                            spreadRadius: 0,
                            blurRadius: 32)
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                          child: CachedNetworkImage(
                            imageUrl: currentMedia.extras != null
                                ? currentMedia.extras!['image']
                                : "",
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              enabled: true,
                              child: Container(
                                width: 64,
                                height: 64,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                CachedNetworkImage(
                              imageUrl: (currentMedia.extras != null)
                                  ? currentMedia.extras!['image']
                                  : widget.artwork,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/detail_episode',
                                    arguments: DetailEpisodeArgument(
                                      currentMedia.id,
                                      pageManager.bunchOfListItems,
                                      currentExtras['uuid'] ?? "",
                                      currentExtras['index'] ?? 0,
                                    ),
                                  );
                                },
                                child: Text(
                                  currentMedia.title ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              ValueListenableBuilder<ProgressBarState>(
                                valueListenable: pageManager.progressNotifier,
                                builder: (_, value, __) {
                                  double finalDuration =
                                      (value.total.inSeconds == 0 ||
                                              value.current.inSeconds == 0)
                                          ? 0
                                          : value.current.inSeconds /
                                              value.total.inSeconds;
                                  return LinearProgressIndicator(
                                    backgroundColor:
                                        Colors.grey[800]?.withOpacity(0.3),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black.withOpacity(0.9)),
                                    value: finalDuration,
                                  );
                                },
                              ),
                              ValueListenableBuilder<ProgressBarState>(
                                valueListenable: pageManager.progressNotifier,
                                builder: (_, value, __) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        formatedTimes(value.current.inSeconds),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 10),
                                      ),
                                      Text(
                                        formatedTimes(value.total.inSeconds),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 10),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        ValueListenableBuilder<ButtonState>(
                          valueListenable: pageManager.playButtonNotifier,
                          builder: (_, value, __) {
                            print(value);
                            if (value == ButtonState.paused) {
                              return IconButton(
                                onPressed: () => handlePlayPause(false),
                                iconSize: 24,
                                icon: const Icon(Icons.play_arrow),
                              );
                            } else if (value == ButtonState.playing) {
                              return IconButton(
                                onPressed: () => handlePlayPause(true),
                                iconSize: 24,
                                icon: const Icon(Icons.pause),
                              );
                            } else {
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                width: 24.0,
                                height: 24.0,
                                child: const CircularProgressIndicator(
                                  color: Colors.black,
                                  strokeWidth: 1,
                                ),
                              );
                            } 
                          },
                        ),
                        IconButton(
                            onPressed: closePlayBottomSheet,
                            iconSize: 24,
                            icon: const Icon(Icons.close)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
