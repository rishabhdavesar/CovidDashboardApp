import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';

fetchData(data) async {
  Dio dio = new Dio();
  Response response = await dio.get('https://api.covid19india.org/' + data);

  return response.data;
}

totalWidget(action, title, Icon icon, Color color, context) {
  double h = MediaQuery.of(context).size.height;
  double w = MediaQuery.of(context).size.width;
  return Container(
    height: h / 8,
    decoration:
        BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
    padding: EdgeInsets.all(w / 25),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        icon,
        AnimatedCounter(
          count: int.parse(action),
          size: 14,
        ),
        Text(translate(title))
      ],
    ),
  );
}

stateInfoWidget(action, title, Color color, context) {
  double h = MediaQuery.of(context).size.height;
  double w = MediaQuery.of(context).size.width;
  return Container(
    height: h / 8,
    width: w,
    decoration:
        BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
    padding: EdgeInsets.all(w / 25),
    margin: EdgeInsets.all(5),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
            alignment: Alignment.topLeft,
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w600),
            )),
        AnimatedCounter(count: int.parse(action), size: 24),
      ],
    ),
  );
}

class AnimatedCounter extends StatefulWidget {
  final int count;
  final double size;
  AnimatedCounter({this.count, this.size});
  @override
  _AnimatedCounterState createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController _controller;
  String i;
  @override
  void initState() {
    super.initState();
    i = widget.count.toString();
    print(i);
    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation = Tween<double>(begin: 0, end: widget.count.toDouble())
        .animate(_controller)
          ..addListener(() {
            setState(() {
              // The state that has changed here is the animation objects value
              i = animation.value.toStringAsFixed(0);
            });
          });
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$i',
      style: TextStyle(
        fontSize: widget.size,
        fontWeight: FontWeight.w500,
        color: const Color(0xFF2C2020),
      ),
    );
  }
}

class Helper {
  void showDemoActionSheet({BuildContext context, Widget child}) {
    showCupertinoModalPopup<String>(
        context: context,
        builder: (BuildContext context) => child).then((String value) {
      changeLocale(context, value);
    });
  }

  void onActionSheetPress(BuildContext context) {
    showDemoActionSheet(
      context: context,
      child: CupertinoActionSheet(
        title: Text(translate('language.selection.title')),
        message: Text(translate('language.selection.message')),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(translate('language.name.en')),
            onPressed: () => Navigator.pop(context, 'en_US'),
          ),
          CupertinoActionSheetAction(
            child: Text(translate('language.name.es')),
            onPressed: () => Navigator.pop(context, 'es'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(translate('button.cancel')),
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context, null),
        ),
      ),
    );
  }
}
