import 'dart:math';

import 'package:latlong2/latlong.dart';

import 'model.dart';

class GraphSnap {
  static int nearestNodeId(NavGraph graph, LatLng point) {
    var nearest = graph.nodes.keys.first;
    var nearestDist = double.infinity;
    for (final entry in graph.nodes.entries) {
      final dx = entry.value.lat - point.latitude;
      final dy = entry.value.lng - point.longitude;
      final dist = sqrt((dx * dx) + (dy * dy));
      if (dist < nearestDist) {
        nearestDist = dist;
        nearest = entry.key;
      }
    }
    return nearest;
  }
}
