import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:parafare/l10n/app_localizations.dart';
import 'package:latlong2/latlong.dart';

import '../../core/providers.dart';
import '../../map/view.dart';
import '../../nav/route.dart';

class RideManage extends ConsumerStatefulWidget {
  const RideManage({super.key, required this.slotIndex});
  final int slotIndex;

  @override
  ConsumerState<RideManage> createState() => _RideManageState();
}

class _RideManageState extends ConsumerState<RideManage> {
  double adjust = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ride = ref.watch(driverCtrlProvider).slots[widget.slotIndex]!;
    final fare = ref.read(fareServiceProvider).fareFor(ride.distanceKm, adjustment: adjust);
    final graph = ref.watch(graphProvider);
    final mapAssets = ref.watch(mapAssetBundleProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.manageRide)),
      body: Column(
        children: [
          Expanded(
            child: graph.when(
              data: (g) => mapAssets.when(
                data: (bundle) => OfflineMapView(
                  stylePath: bundle?.stylePath,
                  center: const LatLng(6.1164, 125.1716),
                  polylines: [MapPath(routeCoords(g, ride.routeNodeIds), color: Colors.blue, width: 4)],
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('$e')),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('$e')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${ride.originNodeId} → ${ride.destinationNodeId}'),
              Text('${ride.distanceKm.toStringAsFixed(2)} km • ${ride.etaMinutes} min'),
              Text('Fare: ₱${fare.toStringAsFixed(2)}'),
              Slider(value: adjust, min: -20, max: 20, divisions: 40, label: adjust.toStringAsFixed(0), onChanged: (v) => setState(() => adjust = v)),
              FilledButton(
                onPressed: () async {
                  await ref.read(driverCtrlProvider.notifier).finishRide(widget.slotIndex, fare);
                  if (context.mounted) context.pop();
                },
                child: Text(l10n.finishRide),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
