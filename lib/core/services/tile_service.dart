import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pmtiles/pmtiles.dart';

class MapAssetBundle {
  const MapAssetBundle({required this.pmtilesPath, required this.stylePath, required this.tileTemplateUrl});
  final String pmtilesPath;
  final String stylePath;
  final String tileTemplateUrl;
}

class TileService {
  static HttpServer? _server;
  static PmTilesArchive? _archive;
  static String? _tileTemplateUrl;

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

    final tileTemplate = await _ensureLocalTileServer(pmFile.path);

    final styleRaw = await rootBundle.loadString('assets/map/style.json');
    final styleJson = jsonDecode(styleRaw) as Map<String, dynamic>;
    final sources = Map<String, dynamic>.from(styleJson['sources'] as Map);
    final gensan = Map<String, dynamic>.from(sources['gensan'] as Map);
    gensan['tiles'] = [tileTemplate];
    gensan.remove('url');
    sources['gensan'] = gensan;
    styleJson['sources'] = sources;
    await styleFile.writeAsString(jsonEncode(styleJson), flush: true);

    return MapAssetBundle(pmtilesPath: pmFile.path, stylePath: styleFile.path, tileTemplateUrl: tileTemplate);
  }

  Future<String> _ensureLocalTileServer(String pmtilesPath) async {
    if (_server != null && _tileTemplateUrl != null) return _tileTemplateUrl!;

    _archive ??= await PmTilesArchive.from(pmtilesPath);
    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _tileTemplateUrl = 'http://127.0.0.1:${_server!.port}/{z}/{x}/{y}.mvt';

    _server!.listen((request) async {
      try {
        final segments = request.uri.pathSegments;
        if (segments.length < 3) {
          request.response.statusCode = HttpStatus.notFound;
          await request.response.close();
          return;
        }

        final z = int.parse(segments[0]);
        final x = int.parse(segments[1]);
        final ySegment = segments[2].split('.').first;
        final y = int.parse(ySegment);

        final tileId = ZXY(z, x, y).toTileId();
        final tile = await _archive!.tile(tileId);

        request.response.headers.contentType = ContentType('application', 'vnd.mapbox-vector-tile');
        request.response.add(tile.bytes());
        await request.response.close();
      } catch (_) {
        request.response.statusCode = HttpStatus.notFound;
        await request.response.close();
      }
    });

    return _tileTemplateUrl!;
  }

  bool _looksUsable(List<int> bytes) {
    if (bytes.length < 256) return false;
    final signature = String.fromCharCodes(bytes.take(7));
    return signature.contains('PMTiles') || bytes.length > 1024;
  }
}
