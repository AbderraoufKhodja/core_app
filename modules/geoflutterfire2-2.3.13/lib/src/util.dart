import 'dart:math';

import 'point.dart';

class Util {
  static const BASE32_CODES = '0123456789bcdefghjkmnpqrstuvwxyz';
  Map<String, int> base32CodesDic = new Map();

  Util() {
    for (var i = 0; i < BASE32_CODES.length; i++) {
      base32CodesDic.putIfAbsent(BASE32_CODES[i], () => i);
    }
  }

  var encodeAuto = 'auto';

  ///
  /// Significant Figure Hash Length
  ///
  /// This is a quick and dirty lookup to figure out how long our hash
  /// should be in order to guarantee a certain amount of trailing
  /// significant figures. This was calculated by determining the error:
  /// 45/2^(n-1) where n is the number of bits for a latitude or
  /// longitude. Key is # of desired sig figs, value is minimum length of
  /// the geohash.
  /// @type Array
  // Desired sig figs:    0  1  2  3   4   5   6   7   8   9  10
  var sigfigHashLength = [0, 5, 7, 8, 11, 12, 13, 15, 16, 17, 18];

  ///
  /// Encode
  /// Create a geohash from latitude and longitude
  /// that is 'number of chars' long
  String encode(var latitude, var longitude, var numberOfChars) {
    if (numberOfChars == encodeAuto) {
      if (latitude.runtimeType == double || longitude.runtimeType == double) {
        throw new Exception('string notation required for auto precision.');
      }
      int decSigFigsLat = latitude.split('.')[1].length;
      int decSigFigsLon = longitude.split('.')[1].length;
      int numberOfSigFigs = max(decSigFigsLat, decSigFigsLon);
      numberOfChars = sigfigHashLength[numberOfSigFigs];
    } else if (numberOfChars == null) {
      numberOfChars = 9;
    }

    var chars = [], bits = 0, bitsTotal = 0, hashValue = 0;
    double maxLat = 90, minLat = -90, maxLon = 180, minLon = -180, mid;

    while (chars.length < numberOfChars) {
      if (bitsTotal % 2 == 0) {
        mid = (maxLon + minLon) / 2;
        if (longitude > mid) {
          hashValue = (hashValue << 1) + 1;
          minLon = mid;
        } else {
          hashValue = (hashValue << 1) + 0;
          maxLon = mid;
        }
      } else {
        mid = (maxLat + minLat) / 2;
        if (latitude > mid) {
          hashValue = (hashValue << 1) + 1;
          minLat = mid;
        } else {
          hashValue = (hashValue << 1) + 0;
          maxLat = mid;
        }
      }

      bits++;
      bitsTotal++;
      if (bits == 5) {
        var code = BASE32_CODES[hashValue];
        chars.add(code);
        bits = 0;
        hashValue = 0;
      }
    }

    return chars.join('');
  }

  ///
  /// Decode Bounding box
  ///
  /// Decode a hashString into a bound box that matches it.
  /// Data returned in a List [minLat, minLon, maxLat, maxLon]
  List<double> decodeBbox(String hashString) {
    var isLon = true;
    double maxLat = 90, minLat = -90, maxLon = 180, minLon = -180, mid;

    int? hashValue = 0;
    for (var i = 0, l = hashString.length; i < l; i++) {
      var code = hashString[i].toLowerCase();
      hashValue = base32CodesDic[code];

      for (var bits = 4; bits >= 0; bits--) {
        var bit = (hashValue! >> bits) & 1;
        if (isLon) {
          mid = (maxLon + minLon) / 2;
          if (bit == 1) {
            minLon = mid;
          } else {
            maxLon = mid;
          }
        } else {
          mid = (maxLat + minLat) / 2;
          if (bit == 1) {
            minLat = mid;
          } else {
            maxLat = mid;
          }
        }
        isLon = !isLon;
      }
    }
    return [minLat, minLon, maxLat, maxLon];
  }

  ///
  /// Decode a [hashString] into a pair of latitude and longitude.
  /// A map is returned with keys 'latitude', 'longitude','latitudeError','longitudeError'
  Map<String, double> decode(String hashString) {
    List<double> bbox = decodeBbox(hashString);
    double lat = (bbox[0] + bbox[2]) / 2;
    double lon = (bbox[1] + bbox[3]) / 2;
    double latErr = bbox[2] - lat;
    double lonErr = bbox[3] - lon;
    return {
      'latitude': lat,
      'longitude': lon,
      'latitudeError': latErr,
      'longitudeError': lonErr,
    };
  }

  ///
  /// Neighbor
  ///
  /// Find neighbor of a geohash string in certain direction.
  /// Direction is a two-element array, i.e. [1,0] means north, [-1,-1] means southwest.
  ///
  /// direction [lat, lon], i.e.
  /// [1,0] - north
  /// [1,1] - northeast
  String neighbor(String hashString, var direction) {
    var lonLat = decode(hashString);
    var neighborLat = lonLat['latitude']! + direction[0] * lonLat['latitudeError'] * 2;
    var neighborLon = lonLat['longitude']! + direction[1] * lonLat['longitudeError'] * 2;
    return encode(neighborLat, neighborLon, hashString.length);
  }

  ///
  /// Neighbors
  /// Returns all neighbors' hashstrings clockwise from north around to northwest
  /// 7 0 1
  /// 6 X 2
  /// 5 4 3
  Map<String, dynamic> neighbors(String hashString) {
    int hashStringLength = hashString.length;
    var lonlat = decode(hashString);
    double? lat = lonlat['latitude'];
    double? lon = lonlat['longitude'];
    double latErr = lonlat['latitudeError']! * 2;
    double lonErr = lonlat['longitudeError']! * 2;

    var neighborLat, neighborLon;

    String encodeNeighbor(neighborLatDir, neighborLonDir) {
      neighborLat = lat! + neighborLatDir * latErr;
      neighborLon = lon! + neighborLonDir * lonErr;
      return encode(neighborLat, neighborLon, hashStringLength);
    }

    List<List<String>> blockList = [[], [], [], [], [], [], [], [], [], [], [], [], []];

    final maxExpansionsLength = 9;
    // adding 4 to include precision 5 block 18
    final expansionsLength = 13 - maxExpansionsLength + hashStringLength + 4;
    final expansions =
        List<int>.generate(expansionsLength > 13 ? 13 : expansionsLength, (index) => index);

    expansions.forEach(
      (expansion) {
        final indexes = [-6, -5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5, 6].map(
          (index) {
            final absIndex = index.isNegative ? -index : index;

            final virtualIndex = (absIndex * 2 - 12) + expansion;

            final result = virtualIndex > 0 ? (virtualIndex * index.sign) + index : index;

            return result;
          },
        ).toList();

        indexes.forEach(
          (i) {
            indexes.forEach((j) {
              blockList[expansion].add(encodeNeighbor(i, j));
            });
          },
        );
      },
    );

    final block5 = <String>[];
    [-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5].forEach((i) {
      [-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5].forEach((j) {
        block5.add(encodeNeighbor(i, j));
      });
    });

    final block4 = <String>[];
    [-4, -3, -2, -1, 0, 1, 2, 3, 4].forEach((i) {
      [-4, -3, -2, -1, 0, 1, 2, 3, 4].forEach((j) {
        block4.add(encodeNeighbor(i, j));
      });
    });

    final block3 = <String>[];
    [-3, -2, -1, 0, 1, 2, 3].forEach((i) {
      [-3, -2, -1, 0, 1, 2, 3].forEach((j) {
        block3.add(encodeNeighbor(i, j));
      });
    });

    final block2 = <String>[];
    [-2, -1, 0, 1, 2].forEach((i) {
      [-2, -1, 0, 1, 2].forEach((j) {
        block2.add(encodeNeighbor(i, j));
      });
    });

    final block1 = <String>[];
    [-1, 0, 1].forEach((i) {
      [-1, 0, 1].forEach((j) {
        block1.add(encodeNeighbor(i, j));
      });
    });

    // var neighborHashList = [
    //   encodeNeighbor(1, 0), // 1
    //   encodeNeighbor(1, 1), // 2
    //   encodeNeighbor(0, 1), // 3
    //   encodeNeighbor(-1, 1), // 4
    //   encodeNeighbor(-1, 0), // 5
    //   encodeNeighbor(-1, -1), // 6
    //   encodeNeighbor(0, -1), // 7
    //   encodeNeighbor(1, -1), // 8
    // ];

    return {
      'block1': block1,
      'block2': block2,
      'block3': block3,
      'block4': block4,
      'block5': block5,
      'block6': blockList[6 - 6],
      'block7': blockList[7 - 6],
      'block8': blockList[8 - 6],
      'block9': blockList[9 - 6],
      'block10': blockList[10 - 6],
      'block11': blockList[11 - 6],
      'block12': blockList[12 - 6],
      'block13': blockList[13 - 6],
      'block14': blockList[14 - 6],
      'block15': blockList[15 - 6],
      'block16': blockList[16 - 6],
      'block17': blockList[17 - 6],
      'block18': blockList[18 - 6],
    };
  }

  ///
  /// Neighbors
  /// Returns all neighbors' hashstrings clockwise from north around to northwest
  /// 7 0 1
  /// 6 X 2
  /// 5 4 3

  Map<String, dynamic> threeHundredKM(String hashString) {
    int hashStringLength = hashString.length;
    var lonlat = decode(hashString);
    double? lat = lonlat['latitude'];
    double? lon = lonlat['longitude'];
    double latErr = lonlat['latitudeError']! * 2;
    double lonErr = lonlat['longitudeError']! * 2;

    var neighborLat, neighborLon;

    String encodeNeighbor(neighborLatDir, neighborLonDir) {
      neighborLat = lat! + neighborLatDir * latErr;
      neighborLon = lon! + neighborLonDir * lonErr;
      return encode(neighborLat, neighborLon, hashStringLength);
    }

    final block1 = <String>[];
    [-1, 0, 1].forEach((i) {
      [-1, 0, 1].forEach((j) {
        block1.add(encodeNeighbor(i, j));
      });
    });

    if (hashStringLength == 9)
      return {
        'block0': hashString,
        'block1': block1,
      };

    List<String> block = [];

    final indexes = [
      -21,
      -20,
      -19,
      -18,
      -17,
      -16,
      -15,
      -14,
      -13,
      -12,
      -11,
      -10,
      -9,
      -8,
      -7,
      -6,
      -5,
      -4,
      -3,
      -2,
      -1,
      0,
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
      21,
    ].map(
      (index) {
        final absIndex = index.isNegative ? -index : index;

        final virtualIndex = (absIndex * 2 - 40) + 40;

        final result = virtualIndex > 0 ? (virtualIndex * index.sign) + index : index;

        return result;
      },
    ).toList();

    indexes.forEach(
      (i) {
        indexes.forEach((j) {
          final iAbsIndex = i.isNegative ? -i : i;
          final jAbsIndex = j.isNegative ? -j : j;

          if (iAbsIndex + jAbsIndex < 63 + (62 / 2) + 1) {
            block.add(encodeNeighbor(i, j));
          }
        });
      },
    );

    return {
      'block0': hashString,
      'block1': block1,
      'block63': block,
    };
  }

  static int setPrecision(double km) {
    /*
      * 1	≤ 5,000km	×	5,000km
      * 2	≤ 1,250km	×	625km
      * 3	≤ 156km	×	156km
      * 4	≤ 39.1km	×	19.5km
      * 5	≤ 4.89km	×	4.89km
      * 6	≤ 1.22km	×	0.61km
      * 7	≤ 153m	×	153m
      * 8	≤ 38.2m	×	19.1m
      * 9	≤ 4.77m	×	4.77m
      *
     */

    if (km <= 0.00477)
      return 9;
    else if (km <= 0.0382)
      return 8;
    else if (km <= 0.153)
      return 7;
    else if (km <= 1.22)
      return 6;
    else if (km <= 4.89)
      return 5;
    else if (km <= 39.1)
      return 4;
    else if (km <= 156)
      return 3;
    else if (km <= 1250)
      return 2;
    else
      return 1;
  }

  static const double MAX_SUPPORTED_RADIUS = 8587;

  // Length of a degree latitude at the equator
  static const double METERS_PER_DEGREE_LATITUDE = 110574;

  // The equatorial circumference of the earth in meters
  static const double EARTH_MERIDIONAL_CIRCUMFERENCE = 40007860;

  // The equatorial radius of the earth in meters
  static const double EARTH_EQ_RADIUS = 6378137;

  // The meridional radius of the earth in meters
  static const double EARTH_POLAR_RADIUS = 6357852.3;

  /* The following value assumes a polar radius of
     * r_p = 6356752.3
     * and an equatorial radius of
     * r_e = 6378137
     * The value is calculated as e2 == (r_e^2 - r_p^2)/(r_e^2)
     * Use exact value to avoid rounding errors
     */
  static const double EARTH_E2 = 0.00669447819799;

  // Cutoff for floating point calculations
  static const double EPSILON = 1e-12;

  static double distance(Coordinates location1, Coordinates location2) {
    return calcDistance(
        location1.latitude, location1.longitude, location2.latitude, location2.longitude);
  }

  static double calcDistance(double lat1, double long1, double lat2, double long2) {
    // Earth's mean radius in meters
    final double radius = (EARTH_EQ_RADIUS + EARTH_POLAR_RADIUS) / 2;
    double latDelta = _toRadians(lat1 - lat2);
    double lonDelta = _toRadians(long1 - long2);

    double a = (sin(latDelta / 2) * sin(latDelta / 2)) +
        (cos(_toRadians(lat1)) * cos(_toRadians(lat2)) * sin(lonDelta / 2) * sin(lonDelta / 2));
    double distance = radius * 2 * atan2(sqrt(a), sqrt(1 - a)) / 1000;
    return double.parse(distance.toStringAsFixed(3));
  }

  static double _toRadians(double num) {
    return num * (pi / 180.0);
  }
}
