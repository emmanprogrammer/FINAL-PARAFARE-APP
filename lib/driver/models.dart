import 'dart:convert';

class Ride {
  Ride({
    required this.slot,
    required this.driverId,
    required this.originNodeId,
    required this.destinationNodeId,
    required this.routeNodeIds,
    required this.distanceKm,
    required this.etaMinutes,
    required this.fare,
    required this.createdAt,
    this.completedAt,
  });

  final int slot;
  final String driverId;
  final int originNodeId;
  final int destinationNodeId;
  final List<int> routeNodeIds;
  final double distanceKm;
  final int etaMinutes;
  final double fare;
  final DateTime createdAt;
  final DateTime? completedAt;

  Ride copyWith({double? fare, DateTime? completedAt}) => Ride(
        slot: slot,
        driverId: driverId,
        originNodeId: originNodeId,
        destinationNodeId: destinationNodeId,
        routeNodeIds: routeNodeIds,
        distanceKm: distanceKm,
        etaMinutes: etaMinutes,
        fare: fare ?? this.fare,
        createdAt: createdAt,
        completedAt: completedAt ?? this.completedAt,
      );

  Map<String, dynamic> toJson() => {
        'slot': slot,
        'driverId': driverId,
        'originNodeId': originNodeId,
        'destinationNodeId': destinationNodeId,
        'routeNodeIds': routeNodeIds,
        'distanceKm': distanceKm,
        'etaMinutes': etaMinutes,
        'fare': fare,
        'createdAt': createdAt.toIso8601String(),
        'completedAt': completedAt?.toIso8601String(),
      };

  factory Ride.fromJson(Map<String, dynamic> json) {
    final rawNodes = json['routeNodeIds'];
    final nodes = rawNodes is List ? rawNodes.map((e) => (e as num).toInt()).toList() : <int>[];
    return Ride(
      slot: (json['slot'] as num).toInt(),
      driverId: (json['driverId'] ?? 'driver-local').toString(),
      originNodeId: (json['originNodeId'] as num).toInt(),
      destinationNodeId: (json['destinationNodeId'] as num).toInt(),
      routeNodeIds: nodes,
      distanceKm: (json['distanceKm'] as num).toDouble(),
      etaMinutes: (json['etaMinutes'] as num).toInt(),
      fare: (json['fare'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt'] as String) : null,
    );
  }

  static String encode(Ride ride) => jsonEncode(ride.toJson());
  static Ride decode(String raw) => Ride.fromJson(jsonDecode(raw) as Map<String, dynamic>);

  static String encodeList(List<Ride> rides) => jsonEncode(rides.map((e) => e.toJson()).toList());

  static List<Ride> decodeList(String raw) {
    final decoded = jsonDecode(raw);
    if (decoded is List) {
      return decoded
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .map(Ride.fromJson)
          .toList();
    }
    return [];
  }
}
