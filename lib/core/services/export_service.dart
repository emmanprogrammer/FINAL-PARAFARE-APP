import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

import '../../driver/models.dart';

class ExportService {
  Future<String> exportRides(List<Ride> rides) async {
    final rows = [
      ['driverId', 'slot', 'originNodeId', 'destinationNodeId', 'distanceKm', 'fare', 'createdAt', 'completedAt']
    ];
    rows.addAll(rides.map((r) => [r.driverId, r.slot, r.originNodeId, r.destinationNodeId, r.distanceKm, r.fare, r.createdAt.toIso8601String(), r.completedAt?.toIso8601String() ?? '']));
    final csv = const ListToCsvConverter().convert(rows);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/parafare_rides.csv');
    await file.writeAsString(csv);
    return file.path;
  }
}
