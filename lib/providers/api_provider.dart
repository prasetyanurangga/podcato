import 'dart:async';
import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:podcato/constant/strings.dart';

class ApiProvider {
  Dio getDio() {
    var unixTime = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    String newUnixTime = unixTime.toString();
    var apiKey = Strings.apiKey;
    var apiSecret = Strings.apiSecret;
    var firstChunk = utf8.encode(apiKey);
    var secondChunk = utf8.encode(apiSecret);
    var thirdChunk = utf8.encode(newUnixTime);

    var output = AccumulatorSink<Digest>();
    var input = sha1.startChunkedConversion(output);
    input.add(firstChunk);
    input.add(secondChunk);
    input.add(thirdChunk);
    input.close();
    var digest = output.events.single;

    const baseUrl = Strings.baseUrl;
    var options = BaseOptions(
      baseUrl: baseUrl,
      headers: {
        'X-Auth-Date': newUnixTime,
        'X-Auth-Key': apiKey,
        'Authorization': digest.toString(),
        'User-Agent': "SomethingAwesome/1.0.1"
      },
    );

    Dio dio = Dio(options);

    return dio;
  }

  Future<Response> searchPodcast(String query) async {
    String endpoint = "/search/byterm";
    Response response;

    try {
      response = await getDio()
          .get(endpoint, queryParameters: {'q': query, 'lang': 'id'});
    } on Error catch (e) {
      throw Exception('Failed to load post $e');
    }
    return response;
  }

  Future<Response> getTrendingPodcast() async {
    String endpoint = "/podcasts/trending";
    Response response;

    try {
      response = await getDio().get(endpoint, queryParameters: {'lang': 'id'});
    } on Error catch (e) {
      throw Exception('Failed to load post $e');
    }
    return response;
  }

  Future<Response> getDetailPodcast(String id) async {
    String endpoint = "/podcasts/byfeedid";
    Response response;

    try {
      response = await getDio().get(endpoint, queryParameters: {'id': id});
    } on Error catch (e) {
      throw Exception('Failed to load post $e');
    }
    return response;
  }

  Future<Response> getDetailEpisode(String id) async {
    String endpoint = "/episodes/byfeedid";
    Response response;

    try {
      response = await getDio().get(endpoint, queryParameters: {'id': id});
    } on Error catch (e) {
      throw Exception('Failed to load post $e');
    }
    return response;
  }
}
