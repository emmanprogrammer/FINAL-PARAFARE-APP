import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:parafare/l10n/app_localizations.dart';

import '../../core/providers.dart';
import '../../map/view.dart';
import '../../nav/path.dart';
import '../../nav/route.dart';
import '../../nav/snap.dart';

class PassengerDash extends ConsumerStatefulWidget {
  const PassengerDash({super.key});

  @override
  ConsumerState<PassengerDash> createState() => _PassengerDashState();
}

class _PassengerDashState extends ConsumerState<PassengerDash> {
  LatLng? o;
  LatLng? d;
  double km = 0;
  int min = 0;
  List<LatLng> line = [];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final mapAssets = ref.watch(mapAssetBundleProvider);
    final graph = ref.watch(graphProvider);
    final fare = ref.read(fareServiceProvider).fareFor(km);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.passengerDashboard), actions: [IconButton(onPressed: () => context.push('/settings'), icon: const Icon(Icons.settings))]),
      body: graph.when(
        data: (g) => mapAssets.when(
          data: (bundle) => Stack(children: [
            OfflineMapView(
              stylePath: bundle?.stylePath,
              center: const LatLng(6.1164, 125.1716),
              onTap: (p) {
                setState(() {
                  if (o == null) {
                    o = p;
                  } else if (d == null) {
                    d = p;
                    final s = GraphSnap.nearestNodeId(g, o!);
                    final e = GraphSnap.nearestNodeId(g, d!);
                    final r = DijkstraPath.shortestPath(g, s, e);
                    line = routeCoords(g, r.nodeIds);
                    km = r.distanceKm;
                    min = (km / 0.25).round();
                  } else {
                    o = p;
                    d = null;
                    line = [];
                    km = 0;
                    min = 0;
                  }
                });
              },
              markers: [
                const MapPoint(LatLng(6.1164, 125.1716), color: Colors.blue),
                if (o != null) MapPoint(o!, color: Colors.green),
                if (d != null) MapPoint(d!, color: Colors.red),
              ],
              polylines: line.isEmpty ? [] : [MapPath(line, color: Colors.deepPurple, width: 4)],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Card(
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(l10n.routeInfo),
                    Text('${km.toStringAsFixed(2)} km • $min min • ₱${fare.toStringAsFixed(2)}'),
                    const Divider(),
                    Text(l10n.nearbyTricyclesComingSoon, style: TextStyle(color: Theme.of(context).disabledColor)),
                  ]),
                ),
              ),
            )
          ]),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('$e'),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Text('$e'),
      ),
    );
  }
}
