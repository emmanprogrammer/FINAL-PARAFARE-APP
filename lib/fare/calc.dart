import 'dart:math';

double calcFare(double distanceKm, {double manualAdjustment = 0, double min = 10, double max = 100, double baseFare = 15, double baseDistance = 4, double perKm = 1}) {
  final extra = distanceKm > baseDistance ? ceil(distanceKm - baseDistance) * perKm : 0;
  final computed = baseFare + extra + manualAdjustment;
  return computed.clamp(min, max).toDouble();
}
