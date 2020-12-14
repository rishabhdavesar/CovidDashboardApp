import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';

import 'helper.dart';

class DistrictWise extends StatefulWidget {
  final String stateName;

  const DistrictWise({Key key, this.stateName}) : super(key: key);

  @override
  _DistrictWiseState createState() => _DistrictWiseState();
}

class _DistrictWiseState extends State<DistrictWise> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.stateName,
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: fetchData('state_district_wise.json'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot
                          .data[widget.stateName.toString()]["districtData"]
                          .length,
                      itemBuilder: (context, index) {
                        var district = snapshot
                            .data[widget.stateName.toString()]["districtData"];
                        return districtWidget(
                            district[district.keys.toList()[index]]['active']
                                .toString(),
                            district[district.keys.toList()[index]]['confirmed']
                                .toString(),
                            district[district.keys.toList()[index]]['deceased']
                                .toString(),
                            district[district.keys.toList()[index]]['recovered']
                                .toString(),
                            district.keys.toList()[index].toString());
                      },
                    ),
                  ),
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

  districtWidget(active, confirmed, deceased, recovered, name) {
    return Container(
      margin: EdgeInsets.all(5),
      child: ExpansionTile(
        childrenPadding: EdgeInsets.all(8),
        backgroundColor: Color(0xFF60A3FA),
        collapsedBackgroundColor: Color(0xFF3E6BA7),
        title: Text(
          name,
          style: TextStyle(color: Colors.white),
        ),
        tilePadding: EdgeInsets.all(8),
        children: <Widget>[
          detailWidget(
            active,
            confirmed,
            deceased,
            recovered,
          )
        ],
      ),
    );
  }

  detailWidget(
    active,
    confirmed,
    deceased,
    recovered,
  ) {
    return Container(
      margin: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                translate("language.selection.active"),
              ),
              Text(active)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(translate("language.selection.affected")),
              Text(confirmed)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(translate("language.selection.deceased")),
              Text(deceased)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(translate("language.selection.recovery_rate")),
              Text(recovered)
            ],
          ),
        ],
      ),
    );
  }
}
