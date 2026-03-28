import 'package:flutter/material.dart';
import 'package:parafare/l10n/app_localizations.dart';

import '../models.dart';

class SlotCard extends StatelessWidget {
  const SlotCard({super.key, required this.index, required this.ride, required this.onTap});
  final int index;
  final Ride? ride;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${l10n.slot} ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            if (ride == null) ...[
              Text(l10n.empty, style: const TextStyle(color: Colors.green)),
              Text(l10n.tapToAddRide),
            ] else ...[
              Text('${ride!.originNodeId} → ${ride!.destinationNodeId}'),
              Text('${ride!.distanceKm.toStringAsFixed(2)} km • ${ride!.etaMinutes} min'),
              Text('₱${ride!.fare.toStringAsFixed(2)}'),
            ]
          ]),
        ),
      ),
    );
  }
}
