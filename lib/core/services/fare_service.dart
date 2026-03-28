import 'package:shared_preferences/shared_preferences.dart';

import '../../fare/calc.dart';

class FareRules {
  FareRules({required this.baseFare, required this.baseDistance, required this.perKm, required this.minFare, required this.maxFare});

  final double baseFare;
  final double baseDistance;
  final double perKm;
  final double minFare;
  final double maxFare;

  Map<String, dynamic> toJson() => {
        'baseFare': baseFare,
        'baseDistance': baseDistance,
        'perKm': perKm,
        'minFare': minFare,
        'maxFare': maxFare,
      };

  FareRules copyWith({double? baseFare, double? baseDistance, double? perKm, double? minFare, double? maxFare}) => FareRules(
        baseFare: baseFare ?? this.baseFare,
        baseDistance: baseDistance ?? this.baseDistance,
        perKm: perKm ?? this.perKm,
        minFare: minFare ?? this.minFare,
        maxFare: maxFare ?? this.maxFare,
      );

  static FareRules defaults() => FareRules(baseFare: 15, baseDistance: 4, perKm: 1, minFare: 10, maxFare: 100);
}

class FareService {
  FareService(this.prefs);
  final SharedPreferences prefs;

  static const _k = 'fare_rules';

  FareRules loadRules() {
    final vals = prefs.getStringList(_k);
    if (vals == null || vals.length != 5) return FareRules.defaults();
    return FareRules(
      baseFare: double.parse(vals[0]),
      baseDistance: double.parse(vals[1]),
      perKm: double.parse(vals[2]),
      minFare: double.parse(vals[3]),
      maxFare: double.parse(vals[4]),
    );
  }

  Future<void> saveRules(FareRules rules) => prefs.setStringList(_k, [rules.baseFare.toString(), rules.baseDistance.toString(), rules.perKm.toString(), rules.minFare.toString(), rules.maxFare.toString()]);

  double fareFor(double distanceKm, {double adjustment = 0}) {
    final r = loadRules();
    return calcFare(distanceKm, manualAdjustment: adjustment, min: r.minFare, max: r.maxFare, baseFare: r.baseFare, baseDistance: r.baseDistance, perKm: r.perKm);
  }
}
