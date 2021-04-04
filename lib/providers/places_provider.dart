import 'dart:io';
import 'package:flutter/material.dart';
import '../models/place.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _places = [];

  List<Place> get places {
    return [..._places];
  }

  void addPlace(String placeName, File pickedImage) {
    _places.add(Place(
      id: DateTime.now().toString(),
      name: placeName,
      location: null,
      image: pickedImage,
    ));
    notifyListeners();
  }
}
