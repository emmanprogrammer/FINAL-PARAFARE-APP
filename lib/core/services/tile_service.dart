import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class TileService {
  Future<String?> ensurePmtiles() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/gensan.pmtiles');

    if (!await file.exists()) {
      final bytes = await rootBundle.load('assets/map/gensan.pmtiles');
      final data = bytes.buffer.asUint8List();
      if (!_looksUsable(data)) return null;
      await file.writeAsBytes(data, flush: true);
    }

    final existing = await file.readAsBytes();
    if (!_looksUsable(existing)) return null;
    return file.path;
  }

  bool _looksUsable(List<int> bytes) {
    if (bytes.length < 256) return false;
    // Defensive check to avoid trying to decode empty/corrupt placeholders.
    final signature = String.fromCharCodes(bytes.take(7));
    return signature.contains('PMTiles') || bytes.length > 1024;
  }
}
