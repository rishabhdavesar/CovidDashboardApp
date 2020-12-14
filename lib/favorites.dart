import 'package:covidapp/fav.dart';
import 'package:covidapp/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'stateWidget.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('My Places',
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.w700,
            )),
      ),
      body: FutureBuilder(
          future: fetchData('data.json'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                margin:
                    EdgeInsets.only(left: w / 25, right: w / 25, top: w / 25),
                child: Column(
                  children: [
                    Expanded(
                      child: Consumer<FavNotifier>(
                        builder: (context, data, _) {
                          return GridView.builder(
                            itemCount: data.favList.length == null
                                ? 0
                                : data.favList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: w / 35,
                                    mainAxisSpacing: w / 35,
                                    crossAxisCount: 2),
                            itemBuilder: (context, index) {
                              return StateWidget(
                                title: snapshot.data['statewise']
                                    [data.favList[index].index]['state'],
                                active: snapshot.data['statewise']
                                    [data.favList[index].index]['active'],
                                recovered: snapshot.data['statewise']
                                    [data.favList[index].index]['recovered'],
                                death: snapshot.data['statewise']
                                    [data.favList[index].index]['deaths'],
                                confirmed: snapshot.data['statewise']
                                    [data.favList[index].index]['confirmed'],
                                i: index,
                                isLiked: true,
                              );
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
