import 'dart:io';
import 'package:flutter/material.dart';
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
        'image': newPlace.image.path,
      },
    );
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _places = dataList
        .map(
          (dataPlace) => Place(
            id: dataPlace['id'],
            name: dataPlace['name'],
            location: null,
            image: File(dataPlace['image']),
          ),
        )
        .toList();
    notifyListeners();
  }
}
