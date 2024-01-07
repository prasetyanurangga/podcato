class ResponseCategoriesModel {
  String? status;
  List<Feeds>? feeds;
  int? count;
  String? description;

  ResponseCategoriesModel(
      {this.status, this.feeds, this.count, this.description});

  ResponseCategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['feeds'] != null) {
      feeds = <Feeds>[];
      json['feeds'].forEach((v) {
        feeds!.add(Feeds.fromJson(v));
      });
    }
    count = json['count'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (feeds != null) {
      data['feeds'] = feeds!.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    data['description'] = description;
    return data;
  }
}

class Feeds {
  int? id;
  String? name;

  Feeds({this.id, this.name});

  Feeds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
