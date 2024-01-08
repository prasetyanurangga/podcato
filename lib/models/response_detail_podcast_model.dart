class ResponseDetailPodcastModel {
  String? status;
  Feed? feed;
  String? description;

  ResponseDetailPodcastModel({this.status, this.feed, this.description});

  ResponseDetailPodcastModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    feed = json['feed'] != null ? Feed.fromJson(json['feed']) : null;
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (feed != null) {
      data['feed'] = feed!.toJson();
    }
    data['description'] = description;
    return data;
  }
}

class Query {
  String? guid;
  int? id;

  Query({this.guid, this.id});

  Query.fromJson(Map<String, dynamic> json) {
    guid = json['guid'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['guid'] = guid;
    data['id'] = id;
    return data;
  }
}

class Feed {
  int? id;
  String? podcastGuid;
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
  String? itunesType;
  String? generator;
  String? language;
  bool? explicit;
  int? type;
  int? dead;
  String? chash;
  int? episodeCount;
  int? crawlErrors;
  int? parseErrors;
  Map<String, dynamic>? categories;
  int? locked;
  int? imageUrlHash;

  Feed({
    this.id,
    this.podcastGuid,
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
    this.itunesType,
    this.generator,
    this.language,
    this.explicit,
    this.type,
    this.dead,
    this.chash,
    this.episodeCount,
    this.crawlErrors,
    this.parseErrors,
    this.locked,
    this.categories,
    this.imageUrlHash,
  });

  Feed.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    podcastGuid = json['podcastGuid'];
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
    itunesType = json['itunesType'];
    generator = json['generator'];
    language = json['language'];
    explicit = json['explicit'];
    type = json['type'];
    dead = json['dead'];
    chash = json['chash'];
    episodeCount = json['episodeCount'];
    crawlErrors = json['crawlErrors'];
    parseErrors = json['parseErrors'];
    categories = json['categories'];
    locked = json['locked'];
    imageUrlHash = json['imageUrlHash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['podcastGuid'] = podcastGuid;
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
    data['itunesType'] = itunesType;
    data['generator'] = generator;
    data['language'] = language;
    data['explicit'] = explicit;
    data['type'] = type;
    data['dead'] = dead;
    data['chash'] = chash;
    data['episodeCount'] = episodeCount;
    data['crawlErrors'] = crawlErrors;
    data['categories'] = categories;
    data['parseErrors'] = parseErrors;
    data['locked'] = locked;
    data['imageUrlHash'] = imageUrlHash;
    return data;
  }
}
