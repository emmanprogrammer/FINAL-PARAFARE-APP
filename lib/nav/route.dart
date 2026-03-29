import 'package:latlong2/latlong.dart';

import 'model.dart';

List<LatLng> routeCoords(NavGraph graph, List<String> nodeIds) {
  return nodeIds
      .map((id) => graph.nodes[id])
      .whereType<GraphNode>()
      .map((n) => LatLng(n.lat, n.lng))
      .toList();
}
