import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class OfflineMapView extends StatelessWidget {
  const OfflineMapView({super.key, required this.tileProvider, required this.center, this.markers = const [], this.polylines = const [], this.onTap});

  final TileProvider tileProvider;
  final LatLng center;
  final List<Marker> markers;
  final List<Polyline> polylines;
  final void Function(LatLng)? onTap;

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: center,
        initialZoom: 14,
        minZoom: 11,
        maxZoom: 18,
        cameraConstraint: CameraConstraint.contain(
          bounds: LatLngBounds(const LatLng(5.9, 124.7), const LatLng(6.3, 125.2)),
        ),
        onTap: (_, point) => onTap?.call(point),
      ),
      children: [
        TileLayer(tileProvider: tileProvider),
        if (polylines.isNotEmpty) PolylineLayer(polylines: polylines),
        if (markers.isNotEmpty) MarkerLayer(markers: markers),
      ],
    );
  }
}
