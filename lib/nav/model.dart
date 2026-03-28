class GraphNode {
  const GraphNode({required this.id, required this.lat, required this.lng});
  final int id;
  final double lat;
  final double lng;
}

class GraphEdge {
  const GraphEdge({required this.from, required this.to, required this.distanceKm});
  final int from;
  final int to;
  final double distanceKm;
}

class NavGraph {
  const NavGraph({required this.nodes, required this.edges});
  final Map<int, GraphNode> nodes;
  final List<GraphEdge> edges;
}
