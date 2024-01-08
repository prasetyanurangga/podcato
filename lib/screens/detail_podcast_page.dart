import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:podcato/audio_services/page_manager.dart';
import 'package:podcato/audio_services/services/service_locator.dart';
import 'package:podcato/blocs/detail_podcast/detail_podcast_bloc.dart';
import 'package:podcato/blocs/detail_podcast/detail_podcast_state.dart';
import 'package:podcato/models/response_episode_model.dart';
import 'package:podcato/models/response_podcasts_model.dart';
import 'package:podcato/wrappers/stack_player_wrapper.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transformable_list_view/transformable_list_view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

class DetailPodcastPage extends StatefulWidget {
  final Feeds detail;

  final String uuid;
  const DetailPodcastPage({Key? key, required this.detail, required this.uuid})
      : super(key: key);

  @override
  _DetailPodcastPageState createState() => _DetailPodcastPageState();
}

class _DetailPodcastPageState extends State<DetailPodcastPage> {
  bool isPlaying = false;
  late Feeds resPodcast;

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  late PageManager pageManager;
  int currentIndex = 0;
  String query = "";

  @override
  void initState() {
    pageManager = getIt<PageManager>();
    resPodcast = widget.detail;
    super.initState();
  }

  Matrix4 getScaleDownMatrix(TransformableListItem item) {
    /// final scale of child when the animation is completed
    const endScaleBound = 0.75;

    /// 0 when animation completed and [scale] == [endScaleBound]
    /// 1 when animation starts and [scale] == 1
    final animationProgress = item.visibleExtent / item.size.height;

    /// result matrix
    final paintTransform = Matrix4.identity();

    /// animate only if item is on edge
    if (item.position != TransformableListItemPosition.middle &&
        item.position != TransformableListItemPosition.bottomEdge) {
      final scale = endScaleBound + ((1 - endScaleBound) * animationProgress);

      paintTransform
        ..translate(item.size.width / 2)
        ..scale(scale)
        ..translate(-item.size.width / 2);
    }

    return paintTransform;
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

  Widget getCategories() {
    var categories = widget.detail.categories as Map<String, dynamic>;
    var listCategories = categories.values.toList();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(listCategories.length, (index) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.grey.shade300,
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(
            listCategories[index],
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        );
      }),
    );
  }

  String formatedTime(int timeInSecond) {
    if (timeInSecond > 3600) {
      int sec = timeInSecond % 60;
      int tempMen = ((timeInSecond - sec) / 60).floor();
      int min = tempMen % 60;

      int hr = ((tempMen - min) / 60).floor();
      return "$hr jam";
    } else if (timeInSecond >= 60) {
      int min = (timeInSecond / 60).floor();
      return "$min menit";
    } else {
      return "$timeInSecond detik";
    }
  }

  String formatedTimes(int timeInSecond) {
    if (timeInSecond > 3600) {
      int sec = timeInSecond % 60;
      int tempMen = ((timeInSecond - sec) / 60).floor();
      int min = tempMen % 60;

      int hr = ((tempMen - min) / 60).floor();
      String hour = hr > 10 ? "$hr" : "0$hr";
      String minute = min > 10 ? "$min" : "0$min";
      String second = sec > 10 ? "$sec" : "0$sec";
      return "$hour:$minute:$second";
    } else {
      int sec = timeInSecond % 60;
      int min = (timeInSecond / 60).floor();
      String minute = min > 10 ? "$min" : "0$min";
      String second = sec > 10 ? "$sec" : "0$sec";
      return "$minute:$second";
    }
  }

  List<Items> getEpisodeWithQuery(List<Items> items) {
    return items
        .where((element) =>
            (element.title ?? "").toLowerCase().contains(query.toLowerCase()) ||
            (element.description ?? "")
                .toLowerCase()
                .contains(query.toLowerCase()))
        .toList();
  }

  String podcastName() {
    if ((widget.detail.title ?? "").length > 25) {
      return '${(widget.detail.title ?? "").substring(0, 22)}...';
    } else {
      return (widget.detail.title ?? "");
    }
  }

  Widget _buildBody() {
    return StackPlayerWrapper(
        artwork: widget.detail.artwork ?? "",
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => {Navigator.pop(context)},
                        icon: const Icon(
                          Icons.chevron_left_rounded,
                        ),
                      ),
                      Text(
                        podcastName(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 15),
                      ),
                      IconButton(
                        onPressed: () => _launchUrl(widget.detail.link ?? ""),
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
                Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: widget.uuid,
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(30)),
                              child: CachedNetworkImage(
                                imageUrl:
                                    resPodcast.artwork!,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  enabled: true,
                                  child: Container(
                                    width: double.infinity,
                                    height: 300,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  height: double.infinity,
                                  width: 300,
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
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "About this Podcast",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: resPodcast.artwork!,
                                      width: 20,
                                      height: 20,
                                      fit: BoxFit.cover,
                                      imageBuilder: (context, imageProvider) =>
                                          CircleAvatar(
                                        backgroundImage: imageProvider,
                                      ),
                                      placeholder: (context, url) =>
                                          Shimmer.fromColors(
                                        baseColor: Colors.grey.shade300,
                                        highlightColor: Colors.grey.shade100,
                                        enabled: true,
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30)),
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        width: 20,
                                        height: 20,
                                        decoration: const BoxDecoration(
                                            color: Colors.orange,
                                            shape: BoxShape.circle),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Whoops!',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    const Text(
                                      "by",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      resPodcast.author ?? "",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                getCategories(),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  resPodcast.description ?? "",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      const Text(
                        "Episodes",
                        style: TextStyle(fontSize: 24),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none),
                            filled: true,
                            hintStyle: const TextStyle(fontSize: 12),
                            hintText: 'Search episode',
                            focusColor: Colors.black,
                            suffixIcon: const Icon(Icons.search),
                            fillColor: const Color.fromARGB(255, 237, 236, 236),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                          ),
                          textInputAction: TextInputAction.search,
                          onChanged: (value) {
                            if (value == "") {
                              setState(() {
                                query = "";
                              });
                            }
                          },
                          onSubmitted: (value) {
                            if (value != "") {
                              setState(() {
                                query = value;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: BlocBuilder<DetailPodcastBloc, DetailPodcastState>(
                    builder: (context, state) {
                      if (state is DetailPodcastSuccess) {
                        final resFeed = getEpisodeWithQuery(state.episodes);
                        return Column(
                          children: List.generate(
                            resFeed.length,
                            (index) {
                              var uuid = const Uuid().v4();
                              var title = "";
                              var description = "";
                              if (resFeed[index].title != null &&
                                  resFeed[index].title != '') {
                                title = resFeed[index].title!;
                              }

                              if (resFeed[index].description != null &&
                                  resFeed[index].description != '') {
                                description = resFeed[index].description!;
                              }
                              return Container(
                                width: double.infinity,
                                height: 100,
                                margin: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(16)),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  resFeed[index].feedImage ??
                                                      "",
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  Shimmer.fromColors(
                                                baseColor: Colors.grey.shade300,
                                                highlightColor:
                                                    Colors.grey.shade100,
                                                enabled: true,
                                                child: Container(
                                                  width: 100,
                                                  height: 100,
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30)),
                                                  ),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                width: 100,
                                                height: 100,
                                                color: Colors.amber,
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'Whoops!',
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () async {
                                          print(resFeed[index].enclosureUrl);
                                          if (pageManager.currentSongNotifier
                                                  .value.id !=
                                              resFeed[index].enclosureUrl) {
                                            getIt<PageManager>()
                                                .init(resFeed, index, uuid);
                                            getIt<PageManager>().play();
                                          }
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            Text(
                                              description,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            const SizedBox(
                                              height: 6,
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.access_time,
                                                  size: 12,
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  DateFormat(
                                                          "d MMM yy", "id_ID")
                                                      .format(resFeed[index]
                                                                  .datePublished !=
                                                              null
                                                          ? DateTime
                                                              .fromMillisecondsSinceEpoch(
                                                                  resFeed[index]
                                                                          .datePublished! *
                                                                      1000)
                                                          : DateTime.now()),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 12),
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                const Icon(
                                                  Icons.circle,
                                                  size: 4,
                                                ),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  formatedTime(
                                                      resFeed[index].duration ??
                                                          0),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      } else if (state is DetailPodcastLoading) {
                        return SizedBox(
                          height: 300,
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            enabled: true,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (_, __) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: 100,
                                        height: 100,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30)),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 8.0,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Container(
                                            width: 80,
                                            height: 8.0,
                                            color: Colors.white,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              itemCount: 6,
                            ),
                          ),
                        );
                      } else if (state is DetailPodcastFailure) {
                        return Text(state.error);
                      } else {
                        return Container();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: _buildBody(),
    );
  }
}
