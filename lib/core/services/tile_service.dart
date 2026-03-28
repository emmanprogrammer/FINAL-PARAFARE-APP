import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class TileService {
  Future<String> ensurePmtiles() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/gensan.pmtiles');
    if (!await file.exists()) {
      final bytes = await rootBundle.load('assets/map/gensan.pmtiles');
      await file.writeAsBytes(bytes.buffer.asUint8List());
    }
    return file.path;
  }
}
