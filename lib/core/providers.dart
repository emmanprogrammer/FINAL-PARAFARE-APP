import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../driver/ctrl.dart';
import '../driver/store.dart';
import '../nav/data.dart';
import '../nav/model.dart';
import 'services/export_service.dart';
import 'services/fare_service.dart';
import 'services/location_service.dart';
import 'services/tile_service.dart';

final sharedPrefsProvider = Provider<SharedPreferences>((_) => throw UnimplementedError());
final tileServiceProvider = Provider((_) => TileService());
final locationServiceProvider = Provider((_) => LocationService());
final fareServiceProvider = Provider((ref) => FareService(ref.watch(sharedPrefsProvider)));
final exportServiceProvider = Provider((_) => ExportService());
final graphProvider = FutureProvider<NavGraph>((_) => GraphData.load());
final driverStoreProvider = Provider((ref) => DriverStore(ref.watch(sharedPrefsProvider)));
final driverCtrlProvider = StateNotifierProvider<DriverCtrl, DriverState>((ref) => DriverCtrl(ref));

final roleProvider = StateProvider<String>((ref) => ref.watch(sharedPrefsProvider).getString('role') ?? 'passenger');
final localeProvider = StateProvider<Locale?>((ref) {
  final raw = ref.watch(sharedPrefsProvider).getString('lang');
  return raw == null ? null : Locale(raw);
});

final tilePathProvider = FutureProvider<String>((ref) => ref.watch(tileServiceProvider).ensurePmtiles());
