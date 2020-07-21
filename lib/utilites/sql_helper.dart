import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:movies_app/Models/movie.dart';

class SQLHelper {
  static SQLHelper dbhelper;
  static Database _database;

  SQLHelper._createInstance();

  factory SQLHelper() {
    if (dbhelper == null) {
      dbhelper = SQLHelper._createInstance();
    }
    return dbhelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await inialization();
    }
    return _database;
  }


  String table_name = "movie_table";
  String _id = "_id";
  String _vote_average = "_vote_average";
  String _title = "_title";
  String _poster_path = "_poster_path";
  String _overview = "_overview";
  String _release_date = "_release_date";

  Future<Database> inialization() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "students.db";
    var studentDB =
        await openDatabase(path, version: 1, onCreate: createDatabase);
    return studentDB;
  }

  void createDatabase(Database db, int version) {
    db.execute(
        "CREATE TABLE $table_name($_id INTEGER PRIMARY KEY AUTOINCREMENT , $_vote_average TEXT" +
            " ,$_title TEXT ,$_poster_path INTEGER ,$_overview TEXT,$_release_date TEXT)");
  }

  Future<List<Map<String, dynamic>>> gerMovieMap() async {
    Database database = await this.database;
    var result = await database.query(table_name, orderBy: "$_id Asc");
    return result;
  }

  Future<int> insertMovie(Result resultt) async {
    Database database = await this.database;
    var result = await database.insert(table_name, resultt.tomap());
    return result;
  }

  Future<int> deletMovies(String title ) async {
    Database database = await this.database;
    var result =
        await database.rawDelete("DELETE FROM $table_name WHERE $_title = ?",[title]);
    return result;
  }
  Future<int> searchcont( String title) async {
    Database database = await this.database;
    List<Map<String, dynamic>> all =
    await database.rawQuery("SELECT * FROM $table_name WHERE $_title = ?",[title]);
    int count = all.length;
    return count;
  }
  Future<int> getcont() async {
    Database database = await this.database;
    List<Map<String, dynamic>> all =
        await database.rawQuery("SELECT COUNT (*) FROM $table_name");
    int result = Sqflite.firstIntValue(all);
    return result;
  }

  Future<List<Result>> getMoviesList() async {
    var studentList = await gerMovieMap();
    int count = studentList.length;
    List<Result> students = new List<Result>();
    for (int i = 0; i < count; i++) {
      students.add(Result.getMap(studentList[i]));
    }
    return students;
  }
}
