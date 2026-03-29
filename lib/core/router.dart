import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../admin/ui/dash.dart';
import '../admin/ui/earnings.dart';
import '../admin/ui/fare_rules.dart';
import '../admin/ui/trip_detail.dart';
import '../admin/ui/trips.dart';
import '../driver/ui/add_ride_map.dart';
import '../driver/ui/dash.dart';
import '../driver/ui/history.dart';
import '../driver/ui/ride_manage.dart';
import '../onboarding/ui/driver_reg.dart';
import '../onboarding/ui/role.dart';
import '../onboarding/ui/seats.dart';
import '../onboarding/ui/welcome.dart';
import '../passenger/ui/dash.dart';
import '../settings/ui/settings.dart';
import 'providers.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final prefs = ref.watch(sharedPrefsProvider);
  final onboarded = prefs.getBool('onboarded') ?? false;
  final role = prefs.getString('role') ?? 'passenger';
  return GoRouter(
    initialLocation: onboarded ? '/$role' : '/onboarding/welcome',
    routes: [
      GoRoute(path: '/onboarding/welcome', builder: (_, __) => const WelcomeScreen()),
      GoRoute(path: '/onboarding/role', builder: (_, __) => const RoleScreen()),
      GoRoute(path: '/onboarding/driver-reg', builder: (_, __) => const DriverRegScreen()),
      GoRoute(path: '/onboarding/seats', builder: (_, __) => const SeatsScreen()),
      GoRoute(path: '/driver', builder: (_, __) => const DriverDash()),
      GoRoute(path: '/driver/add/:slot', builder: (_, s) => AddRideMap(slotIndex: int.parse(s.pathParameters['slot']!))),
      GoRoute(path: '/driver/manage/:slot', builder: (_, s) => RideManage(slotIndex: int.parse(s.pathParameters['slot']!))),
      GoRoute(path: '/driver/history', builder: (_, __) => const DriverHistory()),
      GoRoute(path: '/passenger', builder: (_, __) => const PassengerDash()),
      GoRoute(path: '/admin', builder: (_, __) => const AdminDash()),
      GoRoute(path: '/admin/trips', builder: (_, __) => const AdminTrips()),
      GoRoute(path: '/admin/earnings', builder: (_, __) => const AdminEarnings()),
      GoRoute(path: '/admin/fare-rules', builder: (_, __) => const AdminFareRules()),
      GoRoute(path: '/admin/trip/:index', builder: (_, s) => TripDetail(index: int.parse(s.pathParameters['index']!))),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
    ],
  );
});
