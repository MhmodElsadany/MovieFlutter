import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/Models/trailers.dart';
import 'package:http/http.dart' as http;

Widget trailer(BuildContext context, String id) {
  showDialog(
      context: context,
      builder: (_) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            content: Container(
              child: dialg(id),
            ),
          ));
}

Future<List<TrailersModel>> GetData(String id) async {
  var data = await http.get("https://api.themoviedb.org/3/movie/" +
      id +
      "/videos?api_key=7826714bce33155200adb2a059306594");
  var jsonData = json.decode(data.body);
  var list = jsonData['results'];
  List<TrailersModel> items = [];
  for (int i = 0; i < jsonData['results'].length; i++) {
    TrailersModel result = TrailersModel.fromJson(jsonData['results'][i]);
    items.add(result);
  }
  return items;
}

Widget listReview(AsyncSnapshot asyncSnapshot) {
  int count = 0;
  return ListView.builder(
      padding: const EdgeInsets.only(left: 20),
      itemCount: asyncSnapshot.data.length,
      itemBuilder: (BuildContext context, int position) {
        return InkWell(
          onTap: () {
            _launchURL(asyncSnapshot.data[position].getKey());
          },
          child: ListTile(
            leading: CircleAvatar(
              child: Image(
                image: AssetImage("assets/images/play.png"),
              ),
            ),
            title: Text(
              "Trailer ${++count}",
              style: TextStyle(fontSize: 18),
            ),
          ),
        );
      });
}

Widget dialg(String id) {
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

_launchURL(String urll) async {
  var url = 'https://www.youtube.com/watch/$urll';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Widget listTailer(String id, String poster) {
  return FutureBuilder(
    future: GetData(id),
    builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
      if (asyncSnapshot.hasError) {
        return Container();
      } else if (asyncSnapshot.hasData) {
        return (listTrail(asyncSnapshot, poster));
      }
      return Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

Widget listTrail(AsyncSnapshot asyncSnapshot, String poster) {
  int count = 0;
  return Container(
    height: 150,
    child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: asyncSnapshot.data.length,
        itemBuilder: (BuildContext context, int position) {
          return Padding(
            padding: const EdgeInsets.only(left: 9),
            child: Stack(children: <Widget>[
              Container(
                width: 140,
                child: InkResponse(
                  splashColor: Colors.red,
                  enableFeedback: true,
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w185$poster',
                    fit: BoxFit.fill,
                  ),
                  onTap: () {
                    _launchURL(asyncSnapshot.data[position].getKey());
                  },
                ),
              ),
              Container(
                height: 40,
                width: 40,
                child: Center(child: Image(image: AssetImage("assets/images/play.png"),)),
              )
            ]),
          );
        }),
  );
}
