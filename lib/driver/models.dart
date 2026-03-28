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

  factory Ride.fromJson(Map<String, dynamic> json) => Ride(
        slot: json['slot'] as int,
        driverId: json['driverId'] as String,
        originNodeId: json['originNodeId'] as int,
        destinationNodeId: json['destinationNodeId'] as int,
        routeNodeIds: (json['routeNodeIds'] as List).cast<int>(),
        distanceKm: (json['distanceKm'] as num).toDouble(),
        etaMinutes: json['etaMinutes'] as int,
        fare: (json['fare'] as num).toDouble(),
        createdAt: DateTime.parse(json['createdAt'] as String),
        completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt'] as String) : null,
      );

  static String encodeList(List<Ride> rides) => jsonEncode(rides.map((e) => e.toJson()).toList());
  static List<Ride> decodeList(String raw) => (jsonDecode(raw) as List).cast<Map<String, dynamic>>().map(Ride.fromJson).toList();
}
