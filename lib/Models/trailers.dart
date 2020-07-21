

class TrailersModel {

  String id;
  String iso_639_1;
  String iso_3166_1;
  String key;
  String name;
  String site;
  int size;
  String type;

  TrailersModel(this.key);

  String getId() {
    return id;
  }

  TrailersModel.fromJson(Map<String, dynamic> parsedJson) {
    key = parsedJson['key'];
  }


  String getIso_639_1() {
    return iso_639_1;
  }

  String getIso_3166_1() {
    return iso_3166_1;
  }

  String getKey() {
    return key;
  }

  String getName() {
    return name;
  }

  String getSite() {
    return site;
  }

  int getSize() {
    return size;
  }

  String getType() {
    return type;
  }

}
