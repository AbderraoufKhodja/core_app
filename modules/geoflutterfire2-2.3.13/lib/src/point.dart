import 'package:cloud_firestore/cloud_firestore.dart';

import 'util.dart';

class GeoFirePoint {
  static Util _util = Util();
  double latitude, longitude;

  GeoFirePoint(this.latitude, this.longitude);

  /// return geographical distance between two Co-ordinates
  static double distanceBetween({required Coordinates to, required Coordinates from}) {
    return Util.distance(to, from);
  }

  /// return neighboring geo-hashes of [hash]
  static Map<String, dynamic> neighborsOf({required String hash}) {
    return _util.neighbors(hash);
  }

  /// return neighboring geo-hashes of [hash]
  static Map<String, dynamic> threeHundredKMOf({required String hash}) {
    return _util.threeHundredKM(hash);
  }

  /// return hash of [GeoFirePoint]
  String get hash {
    return _util.encode(this.latitude, this.longitude, 9);
  }

  /// return all neighbors of [GeoFirePoint]
  Map<String, dynamic> get neighbors {
    return _util.neighbors(this.hash);
  }

  /// return [GeoPoint] of [GeoFirePoint]
  GeoPoint get geoPoint {
    return GeoPoint(this.latitude, this.longitude);
  }

  Coordinates get coords {
    return Coordinates(this.latitude, this.longitude);
  }

  /// return distance between [GeoFirePoint] and ([lat], [lng])
  double distance({required double lat, required double lng}) {
    return distanceBetween(from: coords, to: Coordinates(lat, lng));
  }

  Map<String, dynamic> get data {
    final precisions = [1, 2, 3, 4, 5, 6, 7, 8, 9];

    final data =
        precisions.map((precision) => this.hash.substring(0, precision)).toList().asMap().map(
      (idx1, centerHash) {
        final key = 'precision' + idx1.toString();
        final value = GeoFirePoint.neighborsOf(hash: centerHash)
          ..addEntries([MapEntry('block0', centerHash)]);
        return MapEntry(
          key,
          value,
        );
      },
    );

    return {'geopoint': this.geoPoint, 'data': data};
  }

  Map<String, dynamic> get dataForThreeHundredKm {
    final precisions = [5, 9];

    final data =
        precisions.map((precision) => this.hash.substring(0, precision)).toList().asMap().map(
      (idx1, centerHash) {
        final key = 'precision' + (precisions[idx1] - 1).toString();
        final value = GeoFirePoint.threeHundredKMOf(hash: centerHash)
          ..addEntries([MapEntry('block0', centerHash)]);
        return MapEntry(
          key,
          value,
        );
      },
    );

    return {'geopoint': this.geoPoint, 'data': data};
  }

  /// haversine distance between [GeoFirePoint] and ([lat], [lng])
  haversineDistance({required double lat, required double lng}) {
    return GeoFirePoint.distanceBetween(from: coords, to: Coordinates(lat, lng));
  }
}

class Coordinates {
  double latitude;
  double longitude;

  Coordinates(this.latitude, this.longitude);
}
