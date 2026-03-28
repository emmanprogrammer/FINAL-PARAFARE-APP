import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:parafare/l10n/app_localizations.dart';

import '../../core/providers.dart';

class DriverRegScreen extends ConsumerStatefulWidget {
  const DriverRegScreen({super.key});

  @override
  ConsumerState<DriverRegScreen> createState() => _DriverRegScreenState();
}

class _DriverRegScreenState extends ConsumerState<DriverRegScreen> {
  final name = TextEditingController();
  final id = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.driverRegistration)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          TextField(controller: name, decoration: InputDecoration(labelText: l10n.name)),
          TextField(controller: id, decoration: InputDecoration(labelText: l10n.tricycleId)),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () async {
              await ref.read(sharedPrefsProvider).setString('driver_name', name.text);
              await ref.read(sharedPrefsProvider).setString('driver_id', id.text);
              if (mounted) context.go('/onboarding/seats');
            },
            child: Text(l10n.continueText),
          )
        ]),
      ),
    );
  }
}
