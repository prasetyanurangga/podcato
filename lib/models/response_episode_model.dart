class ResponseEpisodeModel {
  String? status;
  List<Items>? items;
  String? description;

  ResponseEpisodeModel({this.status, this.items, this.description});

  ResponseEpisodeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['description'] = description;
    return data;
  }
}

class ResponseEpisodeRandomModel {
  String? status;
  List<Items>? episodes;
  String? description;

  ResponseEpisodeRandomModel({this.status, this.episodes, this.description});

  ResponseEpisodeRandomModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['episodes'] != null) {
      episodes = <Items>[];
      json['episodes'].forEach((v) {
        episodes!.add(Items.fromJson(v));
      });
    }
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (episodes != null) {
      data['episodes'] = episodes!.map((v) => v.toJson()).toList();
    }
    data['description'] = description;
    return data;
  }
}


class Items {
  int? id;
  String? title;
  String? link;
  String? description;
  String? guid;
  int? datePublished;
  String? datePublishedPretty;
  int? dateCrawled;
  String? enclosureUrl;
  String? enclosureType;
  int? enclosureLength;
  int? duration;
  int? explicit;
  int? episode;
  String? episodeType;
  int? season;
  String? image;
  int? feedItunesId;
  String? feedImage;
  int? feedId;
  String? feedTitle;
  String? feedLanguage;
  int? feedDead;
  int? feedDuplicateOf;
  String? chaptersUrl;
  String? transcriptUrl;
  Map<String, dynamic>? categories;
  List<Persons>? persons;
  List<SocialInteract>? socialInteract;
  List<Transcripts>? transcripts;
  Value? value;

  Items(
      {this.id,
      this.title,
      this.link,
      this.description,
      this.guid,
      this.datePublished,
      this.datePublishedPretty,
      this.dateCrawled,
      this.enclosureUrl,
      this.enclosureType,
      this.enclosureLength,
      this.duration,
      this.explicit,
      this.episode,
      this.episodeType,
      this.season,
      this.image,
      this.feedItunesId,
      this.feedImage,
      this.feedId,
      this.feedTitle,
      this.feedLanguage,
      this.feedDead,
      this.feedDuplicateOf,
      this.chaptersUrl,
      this.transcriptUrl,
      this.persons,
      this.socialInteract,
      this.transcripts,
      this.categories,
      this.value});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    link = json['link'];
    description = json['description'];
    guid = json['guid'];
    datePublished = json['datePublished'];
    datePublishedPretty = json['datePublishedPretty'];
    dateCrawled = json['dateCrawled'];
    enclosureUrl = json['enclosureUrl'];
    enclosureType = json['enclosureType'];
    enclosureLength = json['enclosureLength'];
    duration = json['duration'];
    explicit = json['explicit'];
    episode = json['episode'];
    episodeType = json['episodeType'];
    season = json['season'];
    image = json['image'];
    feedItunesId = json['feedItunesId'];
    feedImage = json['feedImage'];
    feedId = json['feedId'];
    feedTitle = json['feedTitle'];
    feedLanguage = json['feedLanguage'];
    feedDead = json['feedDead'];
    feedDuplicateOf = json['feedDuplicateOf'];
    chaptersUrl = json['chaptersUrl'];
    transcriptUrl = json['transcriptUrl'];
    categories = json['categories'];
    if (json['persons'] != null) {
      persons = <Persons>[];
      json['persons'].forEach((v) {
        persons!.add(Persons.fromJson(v));
      });
    }
    if (json['socialInteract'] != null) {
      socialInteract = <SocialInteract>[];
      json['socialInteract'].forEach((v) {
        socialInteract!.add(SocialInteract.fromJson(v));
      });
    }
    if (json['transcripts'] != null) {
      transcripts = <Transcripts>[];
      json['transcripts'].forEach((v) {
        transcripts!.add(Transcripts.fromJson(v));
      });
    }
    value = json['value'] != null ? Value.fromJson(json['value']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['link'] = link;
    data['description'] = description;
    data['guid'] = guid;
    data['datePublished'] = datePublished;
    data['datePublishedPretty'] = datePublishedPretty;
    data['dateCrawled'] = dateCrawled;
    data['enclosureUrl'] = enclosureUrl;
    data['enclosureType'] = enclosureType;
    data['enclosureLength'] = enclosureLength;
    data['duration'] = duration;
    data['explicit'] = explicit;
    data['episode'] = episode;
    data['episodeType'] = episodeType;
    data['season'] = season;
    data['image'] = image;
    data['feedItunesId'] = feedItunesId;
    data['feedImage'] = feedImage;
    data['feedId'] = feedId;
    data['feedTitle'] = feedTitle;
    data['feedLanguage'] = feedLanguage;
    data['feedDead'] = feedDead;
    data['feedDuplicateOf'] = feedDuplicateOf;
    data['chaptersUrl'] = chaptersUrl;
    data['transcriptUrl'] = transcriptUrl;
    data['categories'] = categories;
    if (persons != null) {
      data['persons'] = persons!.map((v) => v.toJson()).toList();
    }
    if (socialInteract != null) {
      data['socialInteract'] = socialInteract!.map((v) => v.toJson()).toList();
    }
    if (transcripts != null) {
      data['transcripts'] = transcripts!.map((v) => v.toJson()).toList();
    }
    if (value != null) {
      data['value'] = value!.toJson();
    }
    return data;
  }
}

class Persons {
  int? id;
  String? name;
  String? role;
  String? group;
  String? href;
  String? img;

  Persons({this.id, this.name, this.role, this.group, this.href, this.img});

  Persons.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    role = json['role'];
    group = json['group'];
    href = json['href'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['role'] = role;
    data['group'] = group;
    data['href'] = href;
    data['img'] = img;
    return data;
  }
}

class SocialInteract {
  String? uri;
  String? protocol;
  String? accountId;
  String? accountUrl;
  int? priority;

  SocialInteract(
      {this.uri,
      this.protocol,
      this.accountId,
      this.accountUrl,
      this.priority});

  SocialInteract.fromJson(Map<String, dynamic> json) {
    uri = json['uri'];
    protocol = json['protocol'];
    accountId = json['accountId'];
    accountUrl = json['accountUrl'];
    priority = json['priority'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uri'] = uri;
    data['protocol'] = protocol;
    data['accountId'] = accountId;
    data['accountUrl'] = accountUrl;
    data['priority'] = priority;
    return data;
  }
}

class Transcripts {
  String? url;
  String? type;

  Transcripts({this.url, this.type});

  Transcripts.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['type'] = type;
    return data;
  }
}

class Value {
  Model? model;
  List<Destinations>? destinations;

  Value({this.model, this.destinations});

  Value.fromJson(Map<String, dynamic> json) {
    model = json['model'] != null ? Model.fromJson(json['model']) : null;
    if (json['destinations'] != null) {
      destinations = <Destinations>[];
      json['destinations'].forEach((v) {
        destinations!.add(Destinations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (model != null) {
      data['model'] = model!.toJson();
    }
    if (destinations != null) {
      data['destinations'] = destinations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Model {
  String? type;
  String? method;
  String? suggested;

  Model({this.type, this.method, this.suggested});

  Model.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    method = json['method'];
    suggested = json['suggested'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['method'] = method;
    data['suggested'] = suggested;
    return data;
  }
}

class Destinations {
  String? name;
  String? type;
  String? address;
  int? split;
  String? customKey;
  String? customValue;

  Destinations(
      {this.name,
      this.type,
      this.address,
      this.split,
      this.customKey,
      this.customValue});

  Destinations.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    address = json['address'];
    split = json['split'];
    customKey = json['customKey'];
    customValue = json['customValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['type'] = type;
    data['address'] = address;
    data['split'] = split;
    data['customKey'] = customKey;
    data['customValue'] = customValue;
    return data;
  }
}
