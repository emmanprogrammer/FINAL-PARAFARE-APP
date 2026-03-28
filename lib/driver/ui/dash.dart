import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:parafare/l10n/app_localizations.dart';

import '../../core/providers.dart';
import '../../map/view.dart';
import 'slot_card.dart';

class DriverDash extends ConsumerWidget {
  const DriverDash({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final tile = ref.watch(pmTilesProvider);
    final state = ref.watch(driverCtrlProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.driverDashboard),
        actions: [
          IconButton(onPressed: () => context.push('/driver/history'), icon: const Icon(Icons.history)),
          IconButton(onPressed: () => context.push('/settings'), icon: const Icon(Icons.settings)),
        ],
      ),
      body: tile.when(
        data: (path) => Column(
          children: [
            Expanded(
              child: OfflineMapView(
                tileProvider: path,
                center: const LatLng(6.1164, 125.1716),
                markers: [
                  Marker(point: const LatLng(6.1164, 125.1716), width: 20, height: 20, child: const DecoratedBox(decoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle)))
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: 6,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.6),
                itemBuilder: (_, i) => SlotCard(
                  index: i,
                  ride: state.slots[i],
                  onTap: () => context.push(state.slots[i] == null ? '/driver/add/$i' : '/driver/manage/$i'),
                ),
              ),
            )
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}
