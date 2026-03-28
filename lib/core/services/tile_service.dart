import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class MapAssetBundle {
  const MapAssetBundle({required this.pmtilesPath, required this.stylePath});
  final String pmtilesPath;
  final String stylePath;
}

class TileService {
  Future<MapAssetBundle?> ensureMapAssets() async {
    final dir = await getApplicationDocumentsDirectory();
    final pmFile = File('${dir.path}/gensan.pmtiles');
    final styleFile = File('${dir.path}/style.json');

    if (!await pmFile.exists()) {
      final bytes = await rootBundle.load('assets/map/gensan.pmtiles');
      final data = bytes.buffer.asUint8List();
      if (!_looksUsable(data)) return null;
      await pmFile.writeAsBytes(data, flush: true);
    }

    final existing = await pmFile.readAsBytes();
    if (!_looksUsable(existing)) return null;

    final styleRaw = await rootBundle.loadString('assets/map/style.json');
    final srcUrl = 'pmtiles://${pmFile.path.replaceAll('\\', '/')}';
    final styleJson = jsonDecode(styleRaw) as Map<String, dynamic>;
    final sources = Map<String, dynamic>.from(styleJson['sources'] as Map);
    final gensan = Map<String, dynamic>.from(sources['gensan'] as Map);
    gensan['url'] = srcUrl;
    sources['gensan'] = gensan;
    styleJson['sources'] = sources;
    await styleFile.writeAsString(jsonEncode(styleJson), flush: true);

    return MapAssetBundle(pmtilesPath: pmFile.path, stylePath: styleFile.path);
  }

  bool _looksUsable(List<int> bytes) {
    if (bytes.length < 256) return false;
    final signature = String.fromCharCodes(bytes.take(7));
    return signature.contains('PMTiles') || bytes.length > 1024;
  }
}
