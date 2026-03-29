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
    final theme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${l10n.slot} ${index + 1}', style: theme.titleSmall?.copyWith(fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              if (ride == null) ...[
                Text(l10n.empty, style: theme.bodyMedium?.copyWith(color: Colors.green), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(l10n.tapToAddRide, style: theme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
              ] else ...[
                Text('${ride!.originNodeId} → ${ride!.destinationNodeId}', style: theme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('${ride!.distanceKm.toStringAsFixed(2)} km • ${ride!.etaMinutes} min', style: theme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('₱${ride!.fare.toStringAsFixed(2)}', style: theme.bodyMedium?.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
