import 'package:flutter/material.dart';
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
    final l10n = AppLocalizations.of(context);
    final mapAssets = ref.watch(mapAssetBundleProvider);
    final state = ref.watch(driverCtrlProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.driverDashboard),
        actions: [
          IconButton(onPressed: () => context.push('/driver/history'), icon: const Icon(Icons.history)),
          IconButton(onPressed: () => context.push('/settings'), icon: const Icon(Icons.settings)),
        ],
      ),
      body: mapAssets.when(
        data: (bundle) => Column(
          children: [
            Expanded(
              child: OfflineMapView(
                stylePath: bundle?.stylePath,
                center: const LatLng(6.1164, 125.1716),
                markers: const [MapPoint(LatLng(6.1164, 125.1716), color: Colors.blue)],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: 6,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.25,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                ),
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
