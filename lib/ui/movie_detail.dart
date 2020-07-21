import 'package:flutter/material.dart';
import 'package:movies_app/ui/review.dart';
import 'package:movies_app/ui/trailers.dart';
import 'package:movies_app/utilites/sql_helper.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/Models/movie.dart';
import 'dart:convert';

class DetailMovie extends StatefulWidget {
  String title, posterUrl, description, releaseDate, vote_average;
  String id;

  DetailMovie(this.title, this.posterUrl, this.description, this.releaseDate,
      this.vote_average, this.id);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DetailMovie(
        title, posterUrl, description, releaseDate, this.vote_average, this.id);
  }
}

class _DetailMovie extends State<DetailMovie> {
  String title, posterUrl, description, releaseDate;
  String voteAverage;
  String id;
  Result result = new Result.name();
  SQLHelper helper = new SQLHelper();
  int colr = 0;

  _DetailMovie(this.title, this.posterUrl, this.description, this.releaseDate,
      this.voteAverage, this.id);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
            child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      expandedHeight: 350.0,
                      floating: false,
                      pinned: false,
                      elevation: 0.0,
                      flexibleSpace: FlexibleSpaceBar(
                          background: Image.network(
                        "https://image.tmdb.org/t/p/w500${widget.posterUrl}",
                        fit: BoxFit.cover,
                      )),
                    ),
                  ];
                },
                body: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Wrap(
                    children: <Widget>[ Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Wrap(
                            direction: Axis.horizontal,
                            spacing: 50.0,
                            alignment: WrapAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  widget.title,
                                  style: TextStyle(
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              RaisedButton.icon(
                                onPressed: () {
                                  review(context, this.id);
                                },
                                textColor: Colors.white,
                                label: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Reviews'),
                                ),
                                shape: StadiumBorder(),
                                color: Colors.red,
                                icon:
                                    Icon(Icons.rate_review, color: Colors.white),
                              ),
                              RaisedButton.icon(
                                onPressed: () {
                                  trailer(context, this.id);
                                },
                                textColor: Colors.white,
                                label: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Trailers'),
                                ),
                                shape: StadiumBorder(),
                                color: Colors.red,
                                icon:
                                    Icon(Icons.play_circle_outline, color: Colors.white),
                              )
                            ]),
                        Container(margin: EdgeInsets.only(top: 8.0, bottom: 8.0)),
                        Row(
                          children: <Widget>[
                            RaisedButton.icon(
                              onPressed: () {
                                save();
                              },
                              textColor: Colors.white,
                              label: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: colr == 0
                                    ? Text(
                                        'Saved',
                                        style: TextStyle(color: Colors.red),
                                      )
                                    : Text('Save',
                                        style: TextStyle(color: Colors.white)),
                              ),
                              shape: StadiumBorder(),
                              color: Colors.grey,
                              icon: Icon(Icons.favorite,
                                  color: colr == 0 ? Colors.red : Colors.white),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10.0, right: 1.0),
                            ),
                            Text(
                              widget.vote_average,
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 30.0, right: 1.0),
                            ),
                            Text(
                              widget.releaseDate,
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ],
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 10.0, bottom: 8.0)),
                        Text(
                          "Storyline",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        Container(margin: EdgeInsets.only(top: 6.0, bottom: 8.0)),
                        Text(widget.description),
                        Container(margin: EdgeInsets.only(top: 10.0, bottom: 10.0)),
                        Text(
                          "TRailers",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        Container(margin: EdgeInsets.only(top: 10.0, bottom: 10.0)),
                       listTailer(this.id,widget.posterUrl)

                      ],
                    ),
                  ],),
                ))),
      ),
    );
  }

  @override
  void initState() {
    colorIcon();
  }

  Future<Widget> colorIcon() async {
    var lens = await helper.searchcont(this.title);
    if (lens < 1) {
      setState(() {
        this.colr = 1;
      });
    } else {
      setState(() {
        this.colr = 0;
      });
    }
  }

  void save() async {
    int res;
    int delet;
    result.title = this.title;
    result.vote_average = this.voteAverage;
    result.release_date = this.releaseDate;
    result.id = int.parse(this.id);
    result.overview = this.description;
    result.poster_path = this.posterUrl;

    var lens = await helper.searchcont(this.title);
    if (lens < 1) {
      res = await helper.insertMovie(result);
      setState(() {
        this.colr = 0;
      });

      if (res == 0) {
        showAlerDialog("sorry", "movie not save");
      } else {
        showAlerDialog("congtulation", "this movie has saved");
      }
    } else {
      res = await helper.deletMovies(this.title);
      showAlerDialog("", "this movie has added before  and deleted now");
      setState(() {
        this.colr = 1;
      });
    }
  }

  void showAlerDialog(String title, String mssg) {
    AlertDialog alertDialog = new AlertDialog(
      title: Text(title),
      content: Text(mssg),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

}
