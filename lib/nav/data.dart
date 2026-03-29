import 'dart:convert';

import 'package:flutter/services.dart';

import 'model.dart';

class GraphData {
  static Future<NavGraph> load() async {
    final raw = await rootBundle.loadString('assets/graph/gensan_graph.json');
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final nodesList = (decoded['nodes'] as List)
        .cast<Map<String, dynamic>>()
        .map((n) => GraphNode(
              id: n['id'].toString(),
              lat: (n['lat'] as num).toDouble(),
              lng: (n['lng'] as num).toDouble(),
            ));
    final nodeMap = {for (final n in nodesList) n.id: n};
    final edges = (decoded['edges'] as List)
        .cast<Map<String, dynamic>>()
        .map((e) => GraphEdge(
              from: e['from'].toString(),
              to: e['to'].toString(),
              distanceKm: (e['distanceKm'] as num).toDouble(),
            ))
        .toList();
    return NavGraph(nodes: nodeMap, edges: edges);
  }
}
