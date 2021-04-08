import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;
import '../models/place.dart';
import '../helpers/db_helpers.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _places = [];

  List<Place> get places {
    return [..._places];
  }

  void addPlace(String placeName, File pickedImage) {
    //create a new place object in memory
    final newPlace = Place(
      id: DateTime.now().toString(),
      name: placeName,
      location: null,
      image: pickedImage,
    );
    //save new place to list in memory
    _places.add(newPlace);
    notifyListeners();
    //save new place to local sqlDb on device
    DBHelper.insert(
      'user_places',
      {
        'id': newPlace.id,
        'name': newPlace.name,
        'image': path.basename(newPlace.image.path),
      },
    );
  }

  Future<void> fetchAndSetPlaces() async {
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final dataList = await DBHelper.getData('user_places');
    _places = dataList
        .map(
          (dataPlace) => Place(
            id: dataPlace['id'],
            name: dataPlace['name'],
            location: null,
            image: File(path.join(appDir.path, dataPlace['image'])),
          ),
        )
        .toList();
    notifyListeners();
  }
}
