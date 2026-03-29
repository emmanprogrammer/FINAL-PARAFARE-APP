import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parafare/l10n/app_localizations.dart';
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
    final mapAssets = ref.watch(mapAssetBundleProvider);
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).tripDetail)),
      body: graph.when(
        data: (g) => mapAssets.when(
          data: (bundle) => OfflineMapView(
            stylePath: bundle?.stylePath,
            center: const LatLng(6.1164, 125.1716),
            polylines: [MapPath(routeCoords(g, ride.routeNodeIds), color: Colors.red, width: 4)],
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
