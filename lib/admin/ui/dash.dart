import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parafare/l10n/app_localizations.dart';

class AdminDash extends StatelessWidget {
  const AdminDash({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.adminDashboard), actions: [IconButton(onPressed: () => context.push('/settings'), icon: const Icon(Icons.settings))]),
      body: ListView(children: [
        ListTile(title: Text(l10n.allTrips), onTap: () => context.push('/admin/trips')),
        ListTile(title: Text(l10n.earningsReports), onTap: () => context.push('/admin/earnings')),
        ListTile(title: Text(l10n.fareRulesManager), onTap: () => context.push('/admin/fare-rules')),
      ]),
    );
  }
}
