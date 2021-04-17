import 'dart:convert';

import '../keys.dart';
import 'package:http/http.dart' as http;

class LocationHelper {
  static String getLocationImagePreview({double latitude, double longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }

  static Future<String> getAddress(double latitude, double longitude) async {
    final url = Uri.https(
      'maps.googleapis.com',
      'maps/api/geocode/json',
      {
        'latlng': '$latitude,$longitude',
        'key': '$GOOGLE_API_KEY',
      },
    );
    // final url = Uri.parse(
    //     'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$GOOGLE_API_KEY');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return json.decode(response.body)['results'][0]['formatted_address'];
    }
    return null;
  }
}
