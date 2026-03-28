import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parafare/l10n/app_localizations.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.local_taxi, size: 64),
          Text(l10n.appName, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 16),
          FilledButton(onPressed: () => context.go('/onboarding/role'), child: Text(l10n.getStarted)),
        ]),
      ),
    );
  }
}
