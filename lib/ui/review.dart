import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:movies_app/Models/review.dart';
import 'package:http/http.dart' as http;

class ReviewDetailMovie extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ReviewDetailMovie();
  }
}

class _ReviewDetailMovie extends State<ReviewDetailMovie> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Text(
          "mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm"),
    );
  }
}

Widget review(BuildContext context ,String id) {
  showDialog(
      context: context,
      builder: (_) =>
      new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: Container(
          child:dialg(id) ,
        ),
      ));
}

Future<List<ModelReviews>> GetData(String id) async {
  var data = await http.get("https://api.themoviedb.org/3/movie/" +
      id +
      "/reviews?api_key=7826714bce33155200adb2a059306594");
  var jsonData = json.decode(data.body);
  var list = jsonData['results'];
  List<ModelReviews> items = [];
  for (int i = 0; i < jsonData['results'].length; i++) {
    ModelReviews result = ModelReviews.fromJson(jsonData['results'][i]);
    items.add(result);
  }
  return items;
}

Widget listReview(AsyncSnapshot asyncSnapshot) {
  return ListView.builder(
      itemCount: asyncSnapshot.data.length,
      itemBuilder: (BuildContext context, int position) {
          return ListTile(
            title: Text(asyncSnapshot.data[position].author),
            subtitle: Text(asyncSnapshot.data[position].content),
          );


      }
  );
}

Widget dialg(String id){
    return FutureBuilder(
      future: GetData(id),
      builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
        if (asyncSnapshot.hasError) {
          return Container();
        } else if (asyncSnapshot.hasData) {
          return (listReview(asyncSnapshot));
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
