import 'package:flutter/material.dart';
import 'package:flutter_udemy_great_places/providers/places_provider.dart';
import 'package:flutter_udemy_great_places/screens/map_screen.dart';
import 'package:provider/provider.dart';

class PlaceDetailScreen extends StatelessWidget {
  static const routeName = 'place-detail';
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    final currentPlace =
        Provider.of<GreatPlaces>(context, listen: false).placeById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(currentPlace.name),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: 250,
              width: double.infinity,
              alignment: Alignment.center,
              child: Image.file(
                currentPlace.image,
                fit: BoxFit.cover,
              )),
          SizedBox(
            height: 10,
          ),
          Text(
            currentPlace.location.address,
            style: TextStyle(color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          TextButton(
            child: Text('Show On Map'),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => MapScreen(
                  initialLocation: currentPlace.location,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
