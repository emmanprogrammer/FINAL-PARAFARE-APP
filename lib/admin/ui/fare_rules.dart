import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/providers.dart';

class AdminFareRules extends ConsumerStatefulWidget {
  const AdminFareRules({super.key});

  @override
  ConsumerState<AdminFareRules> createState() => _AdminFareRulesState();
}

class _AdminFareRulesState extends ConsumerState<AdminFareRules> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final service = ref.read(fareServiceProvider);
    final rules = service.loadRules();
    final baseFare = TextEditingController(text: rules.baseFare.toString());
    final baseDistance = TextEditingController(text: rules.baseDistance.toString());
    final perKm = TextEditingController(text: rules.perKm.toString());
    final minFare = TextEditingController(text: rules.minFare.toString());
    final maxFare = TextEditingController(text: rules.maxFare.toString());

    return Scaffold(
      appBar: AppBar(title: Text(l10n.fareRulesManager)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: baseFare, decoration: InputDecoration(labelText: l10n.baseFare)),
          TextField(controller: baseDistance, decoration: InputDecoration(labelText: l10n.baseDistance)),
          TextField(controller: perKm, decoration: InputDecoration(labelText: l10n.perKm)),
          TextField(controller: minFare, decoration: InputDecoration(labelText: l10n.minFare)),
          TextField(controller: maxFare, decoration: InputDecoration(labelText: l10n.maxFare)),
          FilledButton(
            onPressed: () async {
              await service.saveRules(rules.copyWith(
                baseFare: double.parse(baseFare.text),
                baseDistance: double.parse(baseDistance.text),
                perKm: double.parse(perKm.text),
                minFare: double.parse(minFare.text),
                maxFare: double.parse(maxFare.text),
              ));
              if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.updated)));
            },
            child: Text(l10n.save),
          )
        ],
      ),
    );
  }
}
