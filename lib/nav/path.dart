import 'model.dart';

class PathResult {
  PathResult({required this.nodeIds, required this.distanceKm});
  final List<String> nodeIds;
  final double distanceKm;
}

class DijkstraPath {
  static PathResult shortestPath(NavGraph graph, String startNodeId, String endNodeId) {
    final distances = <String, double>{for (final id in graph.nodes.keys) id: double.infinity};
    final previous = <String, String?>{};
    final unvisited = graph.nodes.keys.toSet();

    distances[startNodeId] = 0;

    while (unvisited.isNotEmpty) {
      String current = unvisited.first;
      for (final n in unvisited) {
        if (distances[n]! < distances[current]!) current = n;
      }

      if (current == endNodeId || distances[current] == double.infinity) break;
      unvisited.remove(current);

      final neighbors = graph.edges.where((e) => e.from == current || e.to == current);
      for (final edge in neighbors) {
        final next = edge.from == current ? edge.to : edge.from;
        if (!unvisited.contains(next)) continue;
        final tentative = distances[current]! + edge.distanceKm;
        if (tentative < distances[next]!) {
          distances[next] = tentative;
          previous[next] = current;
        }
      }
    }

    final path = <String>[];
    String? cursor = endNodeId;
    while (cursor != null) {
      path.insert(0, cursor);
      cursor = previous[cursor];
      if (cursor == startNodeId) {
        path.insert(0, cursor!);
        break;
      }
    }

    return PathResult(nodeIds: path.isEmpty ? [startNodeId, endNodeId] : path, distanceKm: distances[endNodeId] ?? 0);
  }
}
