import 'dart:async';

import 'package:dio/dio.dart';
import 'package:podcato/models/response_detail_podcast_model.dart';
import 'package:podcato/models/response_episode_model.dart';
import 'package:podcato/models/response_podcasts_model.dart';
import 'package:podcato/providers/api_provider.dart';
import 'package:podcato/providers/response_data.dart';

class MainRepository {
  final ApiProvider _apiProvider = ApiProvider();

  Future<ResponseData> SearchPodcast(String query) async {
    Response response = await _apiProvider.searchPodcast(query);
    ResponsePodcastModel responseJust =
        ResponsePodcastModel.fromJson(response.data);
    if (responseJust == null) {
      return ResponseData.connectivityError();
    }

    if (response.statusCode == 200) {
      return ResponseData.success(responseJust);
    } else {
      return ResponseData.error("Error");
    }
  }

  Future<ResponseData> GetTrendingPodcast() async {
    Response response = await _apiProvider.getTrendingPodcast();
    ResponsePodcastModel responseJust =
        ResponsePodcastModel.fromJson(response.data);
    if (responseJust == null) {
      return ResponseData.connectivityError();
    }

    if (response.statusCode == 200) {
      return ResponseData.success(responseJust);
    } else {
      return ResponseData.error("Error");
    }
  }

  Future<ResponseData> GetDetailPodcast(String id) async {
    Response response = await _apiProvider.getDetailPodcast(id);
    ResponseDetailPodcastModel responseJust =
        ResponseDetailPodcastModel.fromJson(response.data);
    if (responseJust == null) {
      return ResponseData.connectivityError();
    }

    if (response.statusCode == 200) {
      return ResponseData.success(responseJust);
    } else {
      return ResponseData.error("Error");
    }
  }

  Future<ResponseData> GetDetailEpisode(String id) async {
    Response response = await _apiProvider.getDetailEpisode(id);
    ResponseEpisodeModel responseJust =
        ResponseEpisodeModel.fromJson(response.data);
    if (responseJust == null) {
      return ResponseData.connectivityError();
    }

    if (response.statusCode == 200) {
      return ResponseData.success(responseJust);
    } else {
      return ResponseData.error("Error");
    }
  }
}