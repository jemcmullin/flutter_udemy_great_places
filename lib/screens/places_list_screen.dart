import 'package:flutter/material.dart';
import 'package:flutter_udemy_great_places/providers/places_provider.dart';
import 'package:provider/provider.dart';
import '../screens/add_place_screen.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Great Places'),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () =>
                  Navigator.of(context).pushNamed(AddPlaceScreen.routeName),
            )
          ],
        ),
        body: FutureBuilder(
          future: Provider.of<GreatPlaces>(context, listen: false)
              .fetchAndSetPlaces(),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Consumer<GreatPlaces>(
                  child:
                      const Center(child: Text('No Places Yet. Add a Place!')),
                  builder: (context, greatPlacesData, consumerChild) =>
                      greatPlacesData.places.length <= 0
                          ? consumerChild
                          : ListView.builder(
                              itemCount: greatPlacesData.places.length,
                              itemBuilder: (context, index) => ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: FileImage(
                                      greatPlacesData.places[index].image),
                                ),
                                title: Text(greatPlacesData.places[index].name),
                                subtitle: Text(greatPlacesData
                                    .places[index].location.address),
                                onTap: () {}, //TODO: Go to Detail Page
                              ),
                            ),
                ),
        ));
  }
}
