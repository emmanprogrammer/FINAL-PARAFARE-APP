import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:latlong2/latlong.dart';

import '../../core/providers.dart';
import '../../map/view.dart';
import '../../nav/route.dart';

class TripDetail extends ConsumerWidget {
  const TripDetail({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ride = ref.watch(driverCtrlProvider).history[index];
    final graph = ref.watch(graphProvider);
    final tile = ref.watch(tilePathProvider);
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.tripDetail)),
      body: graph.when(
        data: (g) => tile.when(
          data: (pm) => OfflineMapView(
            pmtilesPath: pm,
            center: const LatLng(6.1164, 125.1716),
            polylines: [Polyline(points: routeCoords(g, ride.routeNodeIds), strokeWidth: 4, color: Colors.red)],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('$e'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Text('$e'),
      ),
    );
  }
}
