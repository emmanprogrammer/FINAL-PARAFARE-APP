import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/providers.dart';
import 'models.dart';

class DriverState {
  DriverState({required this.slots, required this.history});
  final List<Ride?> slots;
  final List<Ride> history;

  DriverState copyWith({List<Ride?>? slots, List<Ride>? history}) => DriverState(slots: slots ?? this.slots, history: history ?? this.history);
}

class DriverCtrl extends StateNotifier<DriverState> {
  DriverCtrl(this.ref) : super(DriverState(slots: List<Ride?>.filled(6, null), history: [])) {
    final store = ref.read(driverStoreProvider);
    state = state.copyWith(slots: store.loadSlots(), history: store.loadHistory());
  }

  final Ref ref;

  Future<void> setRide(int slotIndex, Ride ride) async {
    final slots = [...state.slots]..[slotIndex] = ride;
    state = state.copyWith(slots: slots);
    await ref.read(driverStoreProvider).saveSlots(slots);
  }

  Future<void> finishRide(int slotIndex, double fare) async {
    final ride = state.slots[slotIndex];
    if (ride == null) return;
    final done = ride.copyWith(fare: fare, completedAt: DateTime.now());
    final slots = [...state.slots]..[slotIndex] = null;
    final history = [...state.history, done];
    state = state.copyWith(slots: slots, history: history);
    await ref.read(driverStoreProvider).saveSlots(slots);
    await ref.read(driverStoreProvider).saveHistory(history);
  }
}
