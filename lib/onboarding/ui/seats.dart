import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:parafare/l10n/app_localizations.dart';

import '../../core/providers.dart';

class SeatsScreen extends ConsumerWidget {
  const SeatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.confirmSeats)),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(l10n.sixSeats),
          const SizedBox(height: 12),
          FilledButton(
              onPressed: () async {
                await ref.read(sharedPrefsProvider).setBool('onboarded', true);
                if (context.mounted) context.go('/driver');
              },
              child: Text(l10n.confirm))
        ]),
      ),
    );
  }
}
