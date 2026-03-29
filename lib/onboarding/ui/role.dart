import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:parafare/l10n/app_localizations.dart';

import '../../core/providers.dart';

class RoleScreen extends ConsumerWidget {
  const RoleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    Future<void> choose(String role) async {
      await ref.read(sharedPrefsProvider).setString('role', role);
      ref.read(roleProvider.notifier).state = role;
      if (role == 'driver') {
        if (context.mounted) context.go('/onboarding/driver-reg');
      } else {
        await ref.read(sharedPrefsProvider).setBool('onboarded', true);
        if (context.mounted) context.go('/$role');
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.selectRole)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FilledButton(onPressed: () => choose('driver'), child: Text(l10n.driver)),
          FilledButton.tonal(onPressed: () => choose('passenger'), child: Text(l10n.passenger)),
          FilledButton.tonal(onPressed: () => choose('admin'), child: Text(l10n.admin)),
        ],
      ),
    );
  }
}
