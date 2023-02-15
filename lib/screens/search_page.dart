import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:podcato/blocs/podcast_search/podcast_search_bloc.dart';
import 'package:podcato/blocs/podcast_search/podcato_search_event.dart';
import 'package:shimmer/shimmer.dart';
import 'package:transformable_list_view/transformable_list_view.dart';

import '../blocs/podcast_search/podcato_search_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
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
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: const Text(
              "Podcato",
              style: TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 225, 224, 224),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              decoration: const InputDecoration(
                hintStyle: TextStyle(fontSize: 17),
                hintText: 'Search your trips',
                focusColor: Colors.black,
                suffixIcon: Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(20),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                if (value != "") {
                  BlocProvider.of<PodcastSearchBloc>(context)
                      .add(SearchPodcast(query: value));
                }
              },
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: BlocBuilder<PodcastSearchBloc, PodcastSearchState>(
                builder: (context, state) {
                  if (state is PodcastSearchSuccess) {
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
                          title = (resFeed[index].title!.length > 20
                              ? '${resFeed[index].title!.substring(0, 17)}...'
                              : resFeed[index].title)!;
                        }

                        if (resFeed[index].author != null &&
                            resFeed[index].author != '') {
                          author = (resFeed[index].author!.length > 20
                              ? "${resFeed[index].author!.substring(0, 17)}..."
                              : resFeed[index].author)!;
                        }
                        return Container(
                          height: 100,
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(30)),
                                child: Image.network(
                                  resFeed[index].image ?? "",
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    author,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                      itemCount: resFeed.length,
                    );
                  } else if (state is PodcastSearchLoading) {
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: _buildBody()));
  }
}
