class Imagelist {
  late int id;
  late String url;

  Imagelist({required this.id, required this.url});

  Imagelist.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    url = json['url'];
  }
}
