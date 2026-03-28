import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:parafare/l10n/app_localizations.dart';

import '../../core/providers.dart';
import '../../map/view.dart';
import '../../nav/path.dart';
import '../../nav/route.dart';
import '../../nav/snap.dart';
import '../models.dart';

class AddRideMap extends ConsumerStatefulWidget {
  const AddRideMap({super.key, required this.slotIndex});
  final int slotIndex;

  @override
  ConsumerState<AddRideMap> createState() => _AddRideMapState();
}

class _AddRideMapState extends ConsumerState<AddRideMap> {
  LatLng? origin;
  LatLng? destination;
  List<LatLng> route = [];
  double distance = 0;
  int eta = 0;
  int? oNode;
  int? dNode;
  List<int> routeNodes = [];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final graph = ref.watch(graphProvider);
    final tile = ref.watch(pmTilesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.addRide)),
      body: graph.when(
        data: (g) => tile.when(
          data: (pm) => Column(children: [
            Expanded(
              child: OfflineMapView(
                tileProvider: pm,
                center: const LatLng(6.1164, 125.1716),
                onTap: (p) {
                  setState(() {
                    if (origin == null) {
                      origin = p;
                      oNode = GraphSnap.nearestNodeId(g, p);
                    } else if (destination == null) {
                      destination = p;
                      dNode = GraphSnap.nearestNodeId(g, p);
                      final result = DijkstraPath.shortestPath(g, oNode!, dNode!);
                      routeNodes = result.nodeIds;
                      route = routeCoords(g, result.nodeIds);
                      distance = result.distanceKm;
                      eta = (distance / 0.25).round();
                    }
                  });
                },
                markers: [
                  if (origin != null) Marker(point: origin!, width: 20, height: 20, child: const Icon(Icons.location_on, color: Colors.green)),
                  if (destination != null) Marker(point: destination!, width: 20, height: 20, child: const Icon(Icons.flag, color: Colors.red)),
                ],
                polylines: route.isEmpty ? [] : [Polyline(points: route, strokeWidth: 4, color: Colors.blue)],
              ),
            ),
            ListTile(title: Text('${distance.toStringAsFixed(2)} km • $eta min'), subtitle: Text('₱${ref.read(fareServiceProvider).fareFor(distance).toStringAsFixed(2)}')),
            Padding(
              padding: const EdgeInsets.all(8),
              child: FilledButton(
                onPressed: destination == null
                    ? null
                    : () async {
                        final fare = ref.read(fareServiceProvider).fareFor(distance);
                        final driverId = ref.read(sharedPrefsProvider).getString('driver_id') ?? 'driver-local';
                        await ref.read(driverCtrlProvider.notifier).setRide(
                              widget.slotIndex,
                              Ride(
                                slot: widget.slotIndex,
                                driverId: driverId,
                                originNodeId: oNode!,
                                destinationNodeId: dNode!,
                                routeNodeIds: routeNodes,
                                distanceKm: distance,
                                etaMinutes: eta,
                                fare: fare,
                                createdAt: DateTime.now(),
                              ),
                            );
                        if (context.mounted) context.pop();
                      },
                child: Text(l10n.confirmRide),
              ),
            )
          ]),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('$e'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}
