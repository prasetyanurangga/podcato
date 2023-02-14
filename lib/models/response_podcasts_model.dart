class ResponsePodcastModel {
  String? status;
  List<Feeds>? feeds;
  int? count;
  String? query;
  String? description;

  ResponsePodcastModel(
      {this.status, this.feeds, this.count, this.query, this.description});

  ResponsePodcastModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['feeds'] != null) {
      feeds = <Feeds>[];
      json['feeds'].forEach((v) {
        feeds!.add(Feeds.fromJson(v));
      });
    }
    count = json['count'];
    query = json['query'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (feeds != null) {
      data['feeds'] = feeds!.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    data['query'] = query;
    data['description'] = description;
    return data;
  }
}

class Feeds {
  int? id;
  String? title;
  String? url;
  String? originalUrl;
  String? link;
  String? description;
  String? author;
  String? ownerName;
  String? image;
  String? artwork;
  int? lastUpdateTime;
  int? lastCrawlTime;
  int? lastParseTime;
  int? lastGoodHttpStatusTime;
  int? lastHttpStatus;
  String? contentType;
  int? itunesId;
  String? generator;
  String? language;
  int? type;
  int? dead;
  int? crawlErrors;
  int? parseErrors;
  int? locked;
  bool? explicit;
  String? podcastGuid;
  int? episodeCount;
  int? imageUrlHash;
  int? newestItemPubdate;

  Feeds(
      {this.id,
      this.title,
      this.url,
      this.originalUrl,
      this.link,
      this.description,
      this.author,
      this.ownerName,
      this.image,
      this.artwork,
      this.lastUpdateTime,
      this.lastCrawlTime,
      this.lastParseTime,
      this.lastGoodHttpStatusTime,
      this.lastHttpStatus,
      this.contentType,
      this.itunesId,
      this.generator,
      this.language,
      this.type,
      this.dead,
      this.crawlErrors,
      this.parseErrors,
      this.locked,
      this.explicit,
      this.podcastGuid,
      this.episodeCount,
      this.imageUrlHash,
      this.newestItemPubdate});

  Feeds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    url = json['url'];
    originalUrl = json['originalUrl'];
    link = json['link'];
    description = json['description'];
    author = json['author'];
    ownerName = json['ownerName'];
    image = json['image'];
    artwork = json['artwork'];
    lastUpdateTime = json['lastUpdateTime'];
    lastCrawlTime = json['lastCrawlTime'];
    lastParseTime = json['lastParseTime'];
    lastGoodHttpStatusTime = json['lastGoodHttpStatusTime'];
    lastHttpStatus = json['lastHttpStatus'];
    contentType = json['contentType'];
    itunesId = json['itunesId'];
    generator = json['generator'];
    language = json['language'];
    type = json['type'];
    dead = json['dead'];
    crawlErrors = json['crawlErrors'];
    parseErrors = json['parseErrors'];
    locked = json['locked'];
    explicit = json['explicit'];
    podcastGuid = json['podcastGuid'];
    episodeCount = json['episodeCount'];
    imageUrlHash = json['imageUrlHash'];
    newestItemPubdate = json['newestItemPubdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['url'] = url;
    data['originalUrl'] = originalUrl;
    data['link'] = link;
    data['description'] = description;
    data['author'] = author;
    data['ownerName'] = ownerName;
    data['image'] = image;
    data['artwork'] = artwork;
    data['lastUpdateTime'] = lastUpdateTime;
    data['lastCrawlTime'] = lastCrawlTime;
    data['lastParseTime'] = lastParseTime;
    data['lastGoodHttpStatusTime'] = lastGoodHttpStatusTime;
    data['lastHttpStatus'] = lastHttpStatus;
    data['contentType'] = contentType;
    data['itunesId'] = itunesId;
    data['generator'] = generator;
    data['language'] = language;
    data['type'] = type;
    data['dead'] = dead;
    data['crawlErrors'] = crawlErrors;
    data['parseErrors'] = parseErrors;
    data['locked'] = locked;
    data['explicit'] = explicit;
    data['podcastGuid'] = podcastGuid;
    data['episodeCount'] = episodeCount;
    data['imageUrlHash'] = imageUrlHash;
    data['newestItemPubdate'] = newestItemPubdate;
    return data;
  }
}
