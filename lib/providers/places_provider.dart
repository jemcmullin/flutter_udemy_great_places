import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspath;
import '../models/place.dart';
import '../helpers/db_helpers.dart';
import '../helpers/location_helpers.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _places = [];

  List<Place> get places {
    return [..._places];
  }

  Place placeById(String id) {
    return _places.firstWhere((e) => e.id == id);
  }

  Future<void> addPlace(
    String placeName,
    File pickedImage,
    PlaceLocation pickedLocation,
  ) async {
    //Use googleapi to get human readable address of picked lat long
    final _pickedAddress = await LocationHelper.getAddress(
      pickedLocation.latitude,
      pickedLocation.longitude,
    );
    //create place location with address to store
    final _updatedLocation = PlaceLocation(
      latitude: pickedLocation.latitude,
      longitude: pickedLocation.longitude,
      address: _pickedAddress,
    );
    //create a new place object in memory
    final newPlace = Place(
      id: DateTime.now().toString(),
      name: placeName,
      location: _updatedLocation,
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
        'loc_lat': newPlace.location.latitude,
        'loc_lon': newPlace.location.longitude,
        'address': newPlace.location.address,
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
            location: PlaceLocation(
              latitude: dataPlace['loc_lat'],
              longitude: dataPlace['loc_lon'],
              address: dataPlace['address'],
            ),
            image: File(path.join(appDir.path, dataPlace['image'])),
          ),
        )
        .toList();
    notifyListeners();
  }
}
