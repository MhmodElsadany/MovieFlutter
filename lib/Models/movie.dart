class Result {
  int _vote_count;
  int _id;
  bool _video;
  var _vote_average;
  String _title;
  double _popularity;
  String _poster_path;
  String _original_language;
  String _original_title;
  List<int> _genre_ids = [];
  String _backdrop_path;
  bool _adult;
  String _overview;
  String _release_date;
  Result.name();

  Result(result) {
    _vote_count = result['vote_count'];
    _id = result['id'];
    _video = result['video'];
    _vote_average = result['vote_average'];
    _title = result['title'];
    _popularity = result['popularity'];
    _poster_path = result['poster_path'];
    _original_language = result['original_language'];
    _original_title = result['original_title'];
    for (int i = 0; i < result['genre_ids'].length; i++) {
      _genre_ids.add(result['genre_ids'][i]);
    }
    _backdrop_path = result['backdrop_path'];
    _adult = result['adult'];
    _overview = result['overview'];
    _release_date = result['release_date'];
  }

  set id(int value) {
    _id = value;
  }

  String get release_date => _release_date;

  String get overview => _overview;

  bool get adult => _adult;

  String get backdrop_path => _backdrop_path;

  List<int> get genre_ids => _genre_ids;

  String get original_title => _original_title;

  String get original_language => _original_language;

  String get poster_path => _poster_path;

  double get popularity => _popularity;

  String get title => _title;

  get vote_average => _vote_average;

  bool get video => _video;

  int get id => _id;

  int get vote_count => _vote_count;

  Map<String, dynamic> tomap() {
    var map = Map<String, dynamic>();
    map["_id"] = this._id.toString();
    map["_title"] = this._title;
    map["_overview"] = this._overview;
    map["_vote_average"] = this._vote_average.toString();
    map["_release_date"] = this._release_date;
    map["_poster_path"] = this._poster_path;
    return map;
  }

  Result.getMap(Map<String, dynamic> map) {
    this._id = map["_id"];
    this._title = map["_title"];
    this._overview = map["_overview"];
    this._vote_average = double.parse(map["_vote_average"].toString());
    this._release_date = map["_release_date"];
    this._poster_path = map["_poster_path"];
  }

  set vote_average(value) {
    _vote_average = value;
  }

  set release_date(String value) {
    _release_date = value;
  }

  set overview(String value) {
    _overview = value;
  }

  set poster_path(String value) {
    _poster_path = value;
  }

  set title(String value) {
    _title = value;
  }
}

class ItemModel {
  int _page;
  int _total_results;
  int _total_pages;
  List<Result> _results = [];

  ItemModel.fromJson(Map<String, dynamic> parsedJson) {
    print(parsedJson['results'].length);
    _page = parsedJson['page'];
    _total_results = parsedJson['total_results'];
    _total_pages = parsedJson['total_pages'];
    List<Result> temp = [];
    for (int i = 0; i < parsedJson['results'].length; i++) {
      Result result = Result(parsedJson['results'][i]);
      temp.add(result);
    }
    _results = temp;
  }

  List<Result> get results => _results;

  int get total_pages => _total_pages;

  int get total_results => _total_results;

  int get page => _page;
}
