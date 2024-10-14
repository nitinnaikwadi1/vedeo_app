class Vedeolist {
  late int id;
  late String name;
  late String url;
  late String thumb;

  Vedeolist({required this.id, required this.name, required this.url});

  Vedeolist.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json['name'].toString();
    url = json['url'];
    thumb = json['thumb'];
  }
}
