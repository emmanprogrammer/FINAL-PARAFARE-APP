import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:parafare/l10n/app_localizations.dart';

import '../../core/providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(children: [
        ListTile(
          title: Text(l10n.switchRole),
          onTap: () => context.go('/onboarding/role'),
        ),
        ListTile(
          title: Text(l10n.language),
          subtitle: Text(ref.watch(localeProvider)?.languageCode ?? l10n.systemDefault),
          onTap: () async {
            final current = ref.read(localeProvider)?.languageCode;
            final next = current == 'fil' ? 'en' : 'fil';
            await ref.read(sharedPrefsProvider).setString('lang', next);
            ref.read(localeProvider.notifier).state = Locale(next);
          },
        ),
      ]),
    );
  }
}
