import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers.dart';

class AdminTrips extends ConsumerWidget {
  const AdminTrips({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final rides = ref.watch(driverCtrlProvider).history;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.allTrips)),
      body: ListView.builder(
        itemCount: rides.length,
        itemBuilder: (_, i) {
          final r = rides[i];
          return ListTile(
            title: Text('${r.driverId} • ${r.originNodeId} → ${r.destinationNodeId}'),
            subtitle: Text('₱${r.fare.toStringAsFixed(2)} • ${r.createdAt}'),
            onTap: () => context.push('/admin/trip/$i'),
          );
        },
      ),
    );
  }
}
