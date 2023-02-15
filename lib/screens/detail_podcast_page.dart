import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podcato/blocs/detail_podcast/detail_podcast_bloc.dart';
import 'package:podcato/blocs/detail_podcast/detail_podcast_event.dart';
import 'package:podcato/blocs/detail_podcast/detail_podcast_state.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transformable_list_view/transformable_list_view.dart';

class DetailPodcastPage extends StatefulWidget {
  final String id;
  final String podcastName;

  final String uuid;
  const DetailPodcastPage(
      {Key? key,
      required this.id,
      required this.podcastName,
      required this.uuid})
      : super(key: key);

  @override
  _DetailPodcastPageState createState() => _DetailPodcastPageState();
}

class _DetailPodcastPageState extends State<DetailPodcastPage> {
  @override
  void initState() {
    // TODO: implement initState

    BlocProvider.of<DetailPodcastBloc>(context)
        .add(GetDetailPodcast(id: widget.id));
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

  String formatedTime(int timeInSecond) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute:$second";
  }

  String podcastName() {
    if (widget.podcastName.length > 15) {
      return '${widget.podcastName.substring(0, 12)}...';
    } else {
      return widget.podcastName;
    }
  }

  Widget _buildBody() {
    return SafeArea(
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
                      onPressed: () => {Navigator.pop(context)},
                      icon: const Icon(
                        Icons.share,
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
                child: BlocBuilder<DetailPodcastBloc, DetailPodcastState>(
                  builder: (context, state) {
                    if (state is DetailPodcastSuccess) {
                      final resPodcast = state.data;
                      print(resPodcast);
                      return Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: widget.uuid,
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(16)),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      resPodcast.artwork! ?? resPodcast.image!,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    enabled: true,
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    height: 100,
                                    width: 100,
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
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    resPodcast.description ?? "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    } else if (state is DetailPodcastLoading) {
                      return Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          enabled: true,
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 300,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Container(
                                width: double.infinity,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Container(
                                width: double.infinity,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                ),
                              ),
                            ],
                          ));
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 16),
                child: const Text(
                  "Episodes",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Expanded(
                child: BlocBuilder<DetailPodcastBloc, DetailPodcastState>(
                  builder: (context, state) {
                    if (state is DetailPodcastSuccess) {
                      final resFeed = state.episodes;
                      print(resFeed);
                      return TransformableListView.builder(
                        controller: ScrollController(),
                        padding: EdgeInsets.zero,
                        getTransformMatrix: getScaleDownMatrix,
                        itemBuilder: (context, index) {
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
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30)),
                                  child: Image.network(
                                    resFeed[index].image != ""
                                        ? resFeed[index].image!
                                        : resFeed[index].feedImage!,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 100,
                                        width: 100,
                                        color: Colors.amber,
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Whoops!',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w300),
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
                                            formatedTime(
                                                resFeed[index].duration ?? 0),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: resFeed.length,
                      );
                    } else if (state is DetailPodcastLoading) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        enabled: true,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (_, __) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }
}
