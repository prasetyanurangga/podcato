import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podcato/blocs/detail_podcast/detail_podcast_bloc.dart';
import 'package:podcato/blocs/detail_podcast/detail_podcast_event.dart';
import 'package:podcato/blocs/podcast_search/podcast_search_bloc.dart';
import 'package:podcato/blocs/podcast_search/podcato_search_event.dart';
import 'package:podcato/blocs/podcast_trending/podcast_trending_bloc.dart';
import 'package:podcato/blocs/podcast_trending/podcato_trending_event.dart';
import 'package:podcato/blocs/podcast_trending/podcato_trending_state.dart';
import 'package:podcato/routers/main_router.dart';
import 'package:podcato/wrappers/stack_player_wrapper.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transformable_list_view/transformable_list_view.dart';
import 'package:uuid/uuid.dart';

import '../blocs/podcast_search/podcato_search_state.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    BlocProvider.of<PodcastTrendingBloc>(context)
        .add(const GetTrendingPodcast());
    BlocProvider.of<PodcastSearchBloc>(context)
        .add(const SearchPodcast(query: "rintik"));
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

  Widget _buildBody() {
    return StackPlayerWrapper(
        artwork: "",
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Podcato",
                      style: TextStyle(fontSize: 24),
                    ),
                    IconButton(
                      onPressed: () =>
                          {Navigator.pushNamed(context, '/search')},
                      icon: const Icon(Icons.search),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                margin: const EdgeInsets.only(bottom: 16, top: 24),
                height: 200,
                child: BlocBuilder<PodcastSearchBloc, PodcastSearchState>(
                  builder: (context, state) {
                    if (state is PodcastSearchSuccess) {
                      final resFeed = state.data;
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: resFeed.length,
                        itemBuilder: (context, index) {
                          var title = "";
                          var author = "";
                          if (resFeed[index].title != null) {
                            title = resFeed[index].title!;
                          }

                          if (resFeed[index].author != null) {
                            author = resFeed[index].author!;
                          }
                          var uuid = const Uuid().v4();
                          return GestureDetector(
                            onTap: () {
                              BlocProvider.of<DetailPodcastBloc>(context).add(
                                  GetDetailPodcast(
                                      id: (resFeed[index].id ?? 0).toString()));
                              Navigator.pushNamed(
                                context,
                                '/detail_podcast',
                                arguments:
                                    DetailPodcastArgument(resFeed[index], uuid),
                              ).then((value) {
                                setState(() {});
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 24),
                              width: 140,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Hero(
                                    tag: uuid,
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(30)),
                                      child: CachedNetworkImage(
                                        imageUrl: resFeed[index].image ?? "",
                                        height: 140,
                                        width: 140,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Shimmer.fromColors(
                                          baseColor: Colors.grey.shade300,
                                          highlightColor: Colors.grey.shade100,
                                          enabled: true,
                                          child: Container(
                                            width: 140,
                                            height: 140,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30)),
                                            ),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                          height: 140,
                                          width: 140,
                                          color: Colors.amber,
                                          alignment: Alignment.center,
                                          child: const Text(
                                            'Whoops!',
                                            style: TextStyle(fontSize: 30),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    author,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is PodcastSearchFailure) {
                      return Text(state.error);
                    } else if (state is PodcastSearchLoading) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        enabled: true,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (_, __) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Container(
                              margin: const EdgeInsets.only(left: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 140,
                                    height: 140,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    width: 140,
                                    height: 8.0,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    width: 120,
                                    height: 8.0,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          itemCount: 6,
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
                child: const Text(
                  "Popular Podcast",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: BlocBuilder<PodcastTrendingBloc, PodcastTrendingState>(
                    builder: (context, state) {
                      if (state is PodcastTrendingSuccess) {
                        final resFeed = state.data;
                        return TransformableListView.builder(
                          controller: ScrollController(),
                          padding: EdgeInsets.zero,
                          getTransformMatrix: getScaleDownMatrix,
                          itemBuilder: (context, index) {
                            var title = "";
                            var author = "";
                            if (resFeed[index].title != null &&
                                resFeed[index].title != '') {
                              title = resFeed[index].title!;
                            }

                            if (resFeed[index].author != null &&
                                resFeed[index].author != '') {
                              author = resFeed[index].author!;
                            }

                            var uuid = const Uuid().v4();
                            return GestureDetector(
                              onTap: () {
                                BlocProvider.of<DetailPodcastBloc>(context).add(
                                    GetDetailPodcast(
                                        id: (resFeed[index].id ?? 0)
                                            .toString()));
                                Navigator.pushNamed(
                                  context,
                                  '/detail_podcast',
                                  arguments: DetailPodcastArgument(
                                      resFeed[index], uuid),
                                ).then((value) {
                                  setState(() {});
                                });
                              },
                              child: Container(
                                height: 100,
                                margin: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Hero(
                                      tag: uuid,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(30)),
                                        child: CachedNetworkImage(
                                          imageUrl: resFeed[index].image ?? "",
                                          height: 100,
                                          width: 100,
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
                                    const SizedBox(width: 8),
                                    Expanded(
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
                                          Text(
                                            author,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: resFeed.length,
                        );
                      } else if (state is PodcastTrendingLoading) {
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
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: _buildBody()));
  }
}
