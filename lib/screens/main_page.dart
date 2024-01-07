import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podcato/blocs/categories/categories_bloc.dart';
import 'package:podcato/blocs/categories/categories_event.dart';
import 'package:podcato/blocs/categories/categories_state.dart';
import 'package:podcato/blocs/detail_podcast/detail_podcast_bloc.dart';
import 'package:podcato/blocs/detail_podcast/detail_podcast_event.dart';
import 'package:podcato/blocs/podcast_search/podcast_search_bloc.dart';
import 'package:podcato/blocs/podcast_search/podcato_search_event.dart';
import 'package:podcato/blocs/podcast_trending/podcast_trending_bloc.dart';
import 'package:podcato/blocs/podcast_trending/podcato_trending_event.dart';
import 'package:podcato/blocs/podcast_trending/podcato_trending_state.dart';
// import 'package:podcato/models/response_detail_podcast_model.dart';
import 'package:podcato/models/response_podcasts_model.dart';
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
  List<Feeds> resFeedTrending = [];
  bool isLoadingTrending = false;
  int? currentCategaries;

  @override
  void initState() {
    BlocProvider.of<PodcastTrendingBloc>(context)
        .add(const GetTrendingPodcast(null));
    BlocProvider.of<PodcastSearchBloc>(context)
        .add(const SearchPodcast(query: "a"));

    BlocProvider.of<CategoriesBloc>(context).add(const GetCategories());

    BlocProvider.of<PodcastTrendingBloc>(context).stream.listen((event) {
      if (event is PodcastTrendingInitial || event is PodcastTrendingLoading) {
        setState(() {
          isLoadingTrending = true;
        });
      }
      if (event is PodcastTrendingSuccess) {
        setState(() {
          resFeedTrending = event.data;
          isLoadingTrending = false;
        });
      }

      if (event is PodcastTrendingFailure) {
        setState(() {
          isLoadingTrending = false;
        });
      }
    });
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

  Widget _buildBody(BuildContext context) {
    return StackPlayerWrapper(
        artwork: "",
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
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
                                  BlocProvider.of<DetailPodcastBloc>(context)
                                      .add(GetDetailPodcast(
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
                                  margin: const EdgeInsets.only(left: 24),
                                  width: 140,
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Hero(
                                        tag: uuid,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(30)),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                resFeed[index].image ?? "",
                                            height: 140,
                                            width: 140,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Shimmer.fromColors(
                                              baseColor: Colors.grey.shade300,
                                              highlightColor:
                                                  Colors.grey.shade100,
                                              enabled: true,
                                              child: Container(
                                                width: 140,
                                                height: 140,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(30)),
                                                ),
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: 140,
                                        height: 140,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30)),
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
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
                child: const Text(
                  "Popular Podcast",
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: BlocBuilder<CategoriesBloc, CategoriesState>(
                  builder: (context, state) {
                if (state is CategoriesSuccess) {
                  return Container(
                    padding:
                        const EdgeInsets.only(left: 24, right: 24, bottom: 16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(state.feed.length, (index) {
                          bool isActive =
                              state.feed[index].id == currentCategaries;
                          return GestureDetector(
                            onTap: () => {
                              setState(() {
                                currentCategaries = state.feed[index].id;
                              }),
                              BlocProvider.of<PodcastTrendingBloc>(context).add(
                                  GetTrendingPodcast(
                                      currentCategaries.toString()))
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: isActive
                                    ? Colors.black
                                    : Colors.grey.shade300,
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: Text(
                                state.feed[index].name ?? "",
                                style: TextStyle(
                                  color: isActive ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  );
                }

                return Container();
              }),
            ),
            isLoadingTrending
                ? SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 16),
                            margin: const EdgeInsets.symmetric(horizontal: 16),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        );
                      },
                      childCount: 10, // Replace with your actual item count
                    ),
                  )
                // ? SliverToBoxAdapter(
                //     child: Shimmer.fromColors(
                //       baseColor: Colors.grey.shade300,
                //       highlightColor: Colors.grey.shade100,
                //       enabled: true,
                //       child: ListView.builder(
                //         physics: const NeverScrollableScrollPhysics(),
                //         itemBuilder: (_, __) => Padding(
                //           padding: const EdgeInsets.only(bottom: 8.0),
                //           child: Container(
                //             child: Row(
                //               crossAxisAlignment: CrossAxisAlignment.center,
                //               mainAxisAlignment: MainAxisAlignment.start,
                //               children: <Widget>[
                //                 Container(
                //                   width: 100,
                //                   height: 100,
                //                   decoration: const BoxDecoration(
                //                     color: Colors.white,
                //                     borderRadius:
                //                         BorderRadius.all(Radius.circular(30)),
                //                   ),
                //                 ),
                //                 const SizedBox(
                //                   width: 8,
                //                 ),
                //                 Column(
                //                   mainAxisAlignment: MainAxisAlignment.center,
                //                   crossAxisAlignment: CrossAxisAlignment.start,
                //                   children: [
                //                     Container(
                //                       width: 100,
                //                       height: 8.0,
                //                       color: Colors.white,
                //                     ),
                //                     const SizedBox(
                //                       height: 8,
                //                     ),
                //                     Container(
                //                       width: 80,
                //                       height: 8.0,
                //                       color: Colors.white,
                //                     ),
                //                   ],
                //                 )
                //               ],
                //             ),
                //           ),
                //         ),
                //         itemCount: 6,
                //       ),
                //     ),
                //   )
                : TransformableSliverList(
                    getTransformMatrix: getScaleDownMatrix,
                    delegate: SliverChildBuilderDelegate(
                      childCount: resFeedTrending.length,
                      (context, index) {
                        var title = "";
                        var author = "";
                        if (resFeedTrending[index].title != null &&
                            resFeedTrending[index].title != '') {
                          title = resFeedTrending[index].title!;
                        }

                        if (resFeedTrending[index].author != null &&
                            resFeedTrending[index].author != '') {
                          author = resFeedTrending[index].author!;
                        }

                        var uuid = const Uuid().v4();
                        return GestureDetector(
                          onTap: () {
                            BlocProvider.of<DetailPodcastBloc>(context).add(
                                GetDetailPodcast(
                                    id: (resFeedTrending[index].id ?? 0)
                                        .toString()));
                            Navigator.pushNamed(
                              context,
                              '/detail_podcast',
                              arguments: DetailPodcastArgument(
                                  resFeedTrending[index], uuid),
                            ).then((value) {
                              setState(() {});
                            });
                          },
                          child: Container(
                            height: 100,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
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
                                      imageUrl:
                                          resFeedTrending[index].image ?? "",
                                      height: 100,
                                      width: 100,
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
                    ),
                  ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: _buildBody(context)));
  }
}
