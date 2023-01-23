import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider {
  Future<Position?> currentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<Placemark?> placeMarkFromCoordinates(
      {required double lat, required double lan}) async {
    List<Placemark> placeMarks =
        await placemarkFromCoordinates(lat, lan, localeIdentifier: 'en_US');
    if (placeMarks.isNotEmpty) {
      return placeMarks.first;
    }
    return null;
  }
}
