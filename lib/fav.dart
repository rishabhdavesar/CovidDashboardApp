import 'package:flutter/material.dart';

class Fav {
  String fav;
  int index;
  bool isFav;
  Fav(this.fav, this.index, this.isFav);
}

class FavNotifier extends ChangeNotifier {
  List<Fav> favList = [];

  getList() {
    return favList;
  }

  addFav(String favName, int index, bool isFav) async {
    Fav fav = Fav(favName, index, isFav);
    favList.add(fav);
    notifyListeners();
  }

  removeFav(String favName) async {
    for (int i = 0; i < favList.length; i++) {
      if (favList[i].fav == favName) {
        favList.remove(favList[i]);
      }
    }
    notifyListeners();
  }
}
