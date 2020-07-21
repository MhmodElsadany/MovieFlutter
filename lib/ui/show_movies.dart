import 'package:flutter/material.dart';
import 'package:movies_app/utilites/sql_helper.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/Models/movie.dart';
import 'dart:convert';

import 'movie_detail.dart';

class ShowMoview extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ShowMoview();
  }
}

class _ShowMoview extends State<ShowMoview> {
  List data = new List();
  int _selectedIndex = 0;
  SQLHelper helper = new SQLHelper();
  List<Result> studentList;
  int count =0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("Show Movies"),
          centerTitle: true,
        ),
        body: _gridList()
    ,bottomNavigationBar: bottomNavgate(),);

  }

  Widget _gridList() {
    return FutureBuilder(
      future: getUser(),
      builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
        if (asyncSnapshot.hasError) {
          return Container();
        } else if (asyncSnapshot.hasData) {
          return (buildGrid(asyncSnapshot));
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<List<Result>> getUser() async {
    String typeFilm ="";
    if(_selectedIndex==0){
      typeFilm="popular";
    }else if(_selectedIndex==1){
      typeFilm="top_rated";
    }else {
     return  updateListMoviea();
    }
      var data = await http.get("http://api.themoviedb.org/3/movie/$typeFilm?api_key=774c9627467113733738773c9c96c8c8");

    var jsonData = json.decode(data.body);
    var list = jsonData['results'];
    List<Result> items = [];
    for (int i = 0; i < jsonData['results'].length; i++) {
      Result result = Result(jsonData['results'][i]);
      items.add(result);
    }
    return items;
  }

  goToMoviesDetailPage(AsyncSnapshot asyncSnapshot, int index) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DetailMovie(
        asyncSnapshot.data[index].title.toString(),
        asyncSnapshot.data[index].poster_path,
        asyncSnapshot.data[index].overview,
        asyncSnapshot.data[index].release_date,
        asyncSnapshot.data[index].vote_average.toString(),
        asyncSnapshot.data[index].id.toString(),
      );
    }));
  }

  Widget buildGrid(AsyncSnapshot asyncSnapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(0),
      itemCount: asyncSnapshot.data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 4, mainAxisSpacing: 4),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
          child: InkResponse(
            splashColor: Colors.red,
            enableFeedback: true,
            child: Image.network(
              'https://image.tmdb.org/t/p/w185${asyncSnapshot.data[index]
                  .poster_path}',
              fit: BoxFit.fill,
            ),
            onTap: () {
              goToMoviesDetailPage(asyncSnapshot, index);
            },
          ),
        );
      },
    );
  }


  Widget bottomNavgate() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.event_seat), title: Text("Popular")),
        BottomNavigationBarItem(
            icon: Icon(Icons.event), title: Text("Top Rated")),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite), title: Text("Favourite")),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.red,
      onTap: _onItemTapped,
     backgroundColor: Colors.transparent,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  List<Result> updateListMoviea() {
    final Future<Database> db = helper.inialization();
    db.then((database) {
      Future<List<Result>> results = helper.getMoviesList();
      results.then((thelist) {
        setState(() {
          this.studentList = thelist;
          this.count = thelist.length;
        });
      });
    });
    return studentList;
  }
}