import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants/google_maps.dart';

class LocationHelper {
  static String getLocationImage(
      {required double latitude, required double longtitude}) {
    return "https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longtitude&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C$latitude,$longtitude&key=$GOOGLE_API_KEY";
  }

  static Future<String> getFormattedAddress(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$GOOGLE_API_KEY');

    final response = await http.get(url);
    final data = jsonDecode(response.body);

    return data['result'][0]['formatted_address'];
  }
}
