import 'package:covidapp/fav.dart';
import 'package:covidapp/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import 'districtWise.dart';

class StateWidget extends StatefulWidget {
  final title;
  final active;
  final recovered;
  final death;
  final confirmed;
  final i;
  final isLiked;

  const StateWidget(
      {Key key,
      this.title,
      this.active,
      this.recovered,
      this.death,
      this.confirmed,
      this.isLiked,
      this.i})
      : super(key: key);
  @override
  _StateWidgetState createState() => _StateWidgetState();
}

class _StateWidgetState extends State<StateWidget> {
  bool _isLiked = false;
  @override
  void initState() {
    super.initState();
    bool flag = false;

    var list = Provider.of<FavNotifier>(context, listen: false).getList();

    for (int i = 0; i < list.length; i++) {
      if (list[i].fav == widget.title) {
        flag = true;
        setState(() {
          _isLiked = true;
        });
      }
    }
    if (!flag) {
      setState(() {
        _isLiked = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int r = int.parse(widget.recovered);
    int c = int.parse(widget.confirmed);
    double p = r / c;

    return Container(
      decoration: BoxDecoration(
          color: Color(0xFFfbd8c5), borderRadius: BorderRadius.circular(12)),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DistrictWise(
                        stateName: widget.title,
                      )));
        },
        onLongPress: () {
          showAlertDialog(context, widget.title, widget.active,
              widget.recovered, widget.death, widget.confirmed);
        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.only(left: 5, top: 5),
                      child: Text(
                        widget.title,
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                    )),
                IconButton(
                  icon: Icon(
                      _isLiked
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      color: _isLiked ? Colors.red : Colors.black),
                  onPressed: () {
                    setState(() {
                      _isLiked ? _isLiked = false : _isLiked = true;
                    });
                    _isLiked
                        ? Provider.of<FavNotifier>(context, listen: false)
                            .addFav(widget.title, widget.i, _isLiked)
                        : Provider.of<FavNotifier>(context, listen: false)
                            .removeFav(
                            widget.title,
                          );
                  },
                )
              ],
            ),
            new CircularPercentIndicator(
              radius: 90.0,
              lineWidth: 5.0,
              animation: true,
              percent: p.toDouble().toString() == 'NaN' ? 0 : p.toDouble(),
              center: new Text(
                p.toDouble().toString() == 'NaN'
                    ? "0%"
                    : p.toDouble().toString().substring(0, 4) + '%',
                style:
                    new TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              footer: new Text(
                translate("language.selection.recovery_rate"),
                style:
                    new TextStyle(fontWeight: FontWeight.w400, fontSize: 14.0),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Color(0xFFE95D12),
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog(
      BuildContext context, name, active, recovered, death, confirmed) {
    // set up the buttons
    double h = MediaQuery.of(context).size.height;

    Widget continueButton = FlatButton(
      child: Text("Done"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(name),
      content: Container(
        height: h / 2,
        child: Wrap(
          children: [
            stateInfoWidget(confirmed, "Confirmed", Color(0xfffee6ec), context),
            stateInfoWidget(recovered, "Recovered", Color(0xffeaf6ed), context),
            stateInfoWidget(death, "Death", Color(0xfff0f1f2), context),
            stateInfoWidget(active, "Active", Color(0xffe8f2ff), context),
          ],
        ),
      ),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
