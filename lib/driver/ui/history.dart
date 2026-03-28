import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/providers.dart';

class DriverHistory extends ConsumerWidget {
  const DriverHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final rides = ref.watch(driverCtrlProvider).history;
    final today = DateTime.now();
    final todayRides = rides.where((r) => r.completedAt != null && DateUtils.isSameDay(r.completedAt, today)).toList();
    final total = todayRides.fold(0.0, (a, b) => a + b.fare);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.earningsHistory), actions: [
        IconButton(
          onPressed: () async {
            final path = await ref.read(exportServiceProvider).exportRides(rides);
            if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('CSV: $path')));
          },
          icon: const Icon(Icons.download),
        )
      ]),
      body: ListView(
        children: [
          ListTile(title: Text(l10n.dailyEarnings), trailing: Text('₱${total.toStringAsFixed(2)}')),
          ListTile(title: Text(l10n.totalTripsToday), trailing: Text('${todayRides.length}')),
          ...rides.reversed.map((r) => ListTile(
                title: Text('${r.originNodeId} → ${r.destinationNodeId} • ₱${r.fare.toStringAsFixed(2)}'),
                subtitle: Text(DateFormat.yMd().add_jm().format(r.completedAt ?? r.createdAt)),
              )),
        ],
      ),
    );
  }
}
