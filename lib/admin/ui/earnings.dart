import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:parafare/l10n/app_localizations.dart';

import '../../core/providers.dart';

class AdminEarnings extends ConsumerWidget {
  const AdminEarnings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final rides = ref.watch(driverCtrlProvider).history;
    final byDriver = <String, double>{};
    for (final r in rides) {
      byDriver[r.driverId] = (byDriver[r.driverId] ?? 0) + r.fare;
    }
    return Scaffold(
      appBar: AppBar(title: Text(l10n.earningsReports)),
      body: ListView(children: byDriver.entries.map((e) => ListTile(title: Text(e.key), trailing: Text('₱${e.value.toStringAsFixed(2)}'))).toList()),
    );
  }
}
