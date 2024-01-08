class ResponseCategoriesModel {
  String? status;
  List<Categories>? categories;
  int? count;
  String? description;

  ResponseCategoriesModel(
      {this.status, this.categories, this.count, this.description});

  ResponseCategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['feeds'] != null) {
      categories = <Categories>[];
      json['feeds'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
    count = json['count'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (categories != null) {
      data['feeds'] = categories!.map((v) => v.toJson()).toList();
    }
    data['count'] = count;
    data['description'] = description;
    return data;
  }
}

class Categories {
  int? id;
  String? name;

  Categories({this.id, this.name});

  Categories.fromJson(Map<String, dynamic> json) {
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
