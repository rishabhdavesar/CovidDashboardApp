import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import 'helper.dart';
import 'stateWidget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Color> colors = [Colors.pink, Colors.blue, Colors.amberAccent];
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
          future: fetchData('data.json'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child: ListTile(
                        title: Text(
                            snapshot.data['cases_time_series'][
                                    snapshot.data['cases_time_series'].length -
                                        1]['date']
                                .toString(),
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            )),
                        subtitle: Text(translate('language.selection.title'),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            )),
                      )),
                      Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                top: h / 18, left: w / 25, right: w / 25),
                            padding: EdgeInsets.all(10),
                            width: w,
                            decoration: BoxDecoration(
                                color: Color(0xFFcfe3fc),
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(translate("language.selection.message"),
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black)),
                                Text(translate("language.selection.message2"),
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ))
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment(0.7, 1.5),
                            child: Image.asset(
                              'assets/doctor-man.png',
                              scale: 9,
                            ),
                          )
                        ],
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            totalWidget(
                                snapshot.data['cases_time_series'][
                                    snapshot.data['cases_time_series'].length -
                                        1]['totalconfirmed'],
                                'language.selection.affected',
                                Icon(
                                  Icons.add,
                                  size: 30,
                                  color: Color(0xfffc1441),
                                ),
                                Color(0xfffee6ec),
                                context),
                            totalWidget(
                                snapshot.data['cases_time_series'][
                                    snapshot.data['cases_time_series'].length -
                                        1]['totalrecovered'],
                                'language.selection.recovered',
                                Icon(
                                  Icons.favorite,
                                  size: 30,
                                  color: Color(0xff35a651),
                                ),
                                Color(0xffeaf6ed),
                                context),
                            totalWidget(
                                snapshot.data['cases_time_series'][
                                    snapshot.data['cases_time_series'].length -
                                        1]['totaldeceased'],
                                'language.selection.deceased',
                                Icon(
                                  Icons.close,
                                  size: 30,
                                  color: Color(0xff6d757d),
                                ),
                                Color(0xfff0f1f2),
                                context)
                          ],
                        ),
                      ),
                    ],
                  ),
                  DraggableScrollableSheet(
                      initialChildSize: .5,
                      minChildSize: 0.5,
                      maxChildSize: 1,
                      expand: true,
                      builder: (context, scrollController) {
                        return Container(
                          margin: EdgeInsets.only(left: w / 25, right: w / 25),
                          color: Colors.white,
                          child: GridView.builder(
                              controller: scrollController,
                              itemCount:
                                  snapshot.data['statewise'].length == null
                                      ? 0
                                      : snapshot.data['statewise'].length - 1,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: w / 35,
                                      mainAxisSpacing: w / 35,
                                      crossAxisCount: 2),
                              itemBuilder: (BuildContext context, int index) {
                                return new StateWidget(
                                  title: snapshot.data['statewise'][index + 1]
                                      ['state'],
                                  active: snapshot.data['statewise'][index + 1]
                                      ['active'],
                                  recovered: snapshot.data['statewise']
                                      [index + 1]['recovered'],
                                  death: snapshot.data['statewise'][index + 1]
                                      ['deaths'],
                                  confirmed: snapshot.data['statewise']
                                      [index + 1]['confirmed'],
                                  i: index + 1,
                                  isLiked: false,
                                );
                              }),
                        );
                      })
                ],
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
