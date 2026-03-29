import 'dart:io';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' as ll;
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:parafare/l10n/app_localizations.dart';

class MapPoint {
  const MapPoint(this.point, {this.color = Colors.blue, this.radius = 6});
  final ll.LatLng point;
  final Color color;
  final double radius;
}

class MapPath {
  const MapPath(this.points, {this.color = Colors.blue, this.width = 4});
  final List<ll.LatLng> points;
  final Color color;
  final double width;
}

class OfflineMapView extends StatefulWidget {
  const OfflineMapView({
    super.key,
    required this.stylePath,
    required this.center,
    this.markers = const [],
    this.polylines = const [],
    this.onTap,
  });

  final String? stylePath;
  final ll.LatLng center;
  final List<MapPoint> markers;
  final List<MapPath> polylines;
  final void Function(ll.LatLng)? onTap;

  @override
  State<OfflineMapView> createState() => _OfflineMapViewState();
}

class _OfflineMapViewState extends State<OfflineMapView> {
  MaplibreMapController? _controller;

  Future<void> _syncAnnotations() async {
    final c = _controller;
    if (c == null) return;
    await c.clearCircles();
    await c.clearLines();

    for (final p in widget.markers) {
      await c.addCircle(
        CircleOptions(
          geometry: LatLng(p.point.latitude, p.point.longitude),
          circleRadius: p.radius,
          circleColor: '#${p.color.value.toRadixString(16).padLeft(8, '0').substring(2)}',
          circleOpacity: 0.95,
        ),
      );
    }

    for (final path in widget.polylines.where((e) => e.points.length > 1)) {
      await c.addLine(
        LineOptions(
          geometry: path.points.map((e) => LatLng(e.latitude, e.longitude)).toList(),
          lineWidth: path.width,
          lineColor: '#${path.color.value.toRadixString(16).padLeft(8, '0').substring(2)}',
          lineOpacity: 0.95,
        ),
      );
    }
  }

  @override
  void didUpdateWidget(covariant OfflineMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncAnnotations();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (widget.stylePath == null || !File(widget.stylePath!).existsSync()) {
      return Center(child: Text(l10n.mapUnavailable));
    }

    return MaplibreMap(
      styleString: File(widget.stylePath!).readAsStringSync(),
      initialCameraPosition: CameraPosition(
        target: LatLng(widget.center.latitude, widget.center.longitude),
        zoom: 13,
      ),
      onMapCreated: (controller) {
        _controller = controller;
      },
      onStyleLoadedCallback: _syncAnnotations,
      onMapClick: (_, latLng) => widget.onTap?.call(ll.LatLng(latLng.latitude, latLng.longitude)),
      trackCameraPosition: false,
      rotateGesturesEnabled: false,
      compassEnabled: false,
    );
  }
}
