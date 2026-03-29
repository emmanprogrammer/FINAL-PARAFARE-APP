class GraphNode {
  const GraphNode({required this.id, required this.lat, required this.lng});
  final String id;
  final double lat;
  final double lng;
}

class GraphEdge {
  const GraphEdge({required this.from, required this.to, required this.distanceKm});
  final String from;
  final String to;
  final double distanceKm;
}

class NavGraph {
  const NavGraph({required this.nodes, required this.edges});
  final Map<String, GraphNode> nodes;
  final List<GraphEdge> edges;
}
