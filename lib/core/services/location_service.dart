import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  Future<void> ensurePermission() async {
    final status = await Permission.locationWhenInUse.request();
    if (!status.isGranted) return;
    if (!await Geolocator.isLocationServiceEnabled()) return;
  }

  Stream<Position> stream() => Geolocator.getPositionStream();
}
