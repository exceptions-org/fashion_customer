import 'dart:convert';

import 'package:flutter/foundation.dart';

class GeoCodeModel {
  final Map? statename;
  final String? distance;
  final String? elevation;
  final Osmtags? osmtags;
  final String? state;
  final String? latt;
  final String? city;
  final String? prov;
  final String? geocode;
  final String? geonumber;
  final String? country;
  final dynamic? stnumber;
  final String? staddress;
  final String? inlatt;
  final Alt? alt;
  final String? timezone;
  final String? region;
  final String? postal;
  final Poi? poi;
  final String? longt;
  final String? remaining_credits;
  final String? confidence;
  final String? inlongt;
  final String? cClass;
  final String? altgeocode;
  GeoCodeModel({
    required this.statename,
    required this.distance,
    required this.elevation,
    required this.osmtags,
    required this.state,
    required this.latt,
    required this.city,
    required this.prov,
    required this.geocode,
    required this.geonumber,
    required this.country,
    required this.stnumber,
    required this.staddress,
    required this.inlatt,
    required this.alt,
    required this.timezone,
    required this.region,
    required this.postal,
    required this.poi,
    required this.longt,
    required this.remaining_credits,
    required this.confidence,
    required this.inlongt,
    required this.cClass,
    required this.altgeocode,
  });

  GeoCodeModel copyWith({
    Map? statename,
    String? distance,
    String? elevation,
    Osmtags? osmtags,
    String? state,
    String? latt,
    String? city,
    String? prov,
    String? geocode,
    String? geonumber,
    String? country,
    String? stnumber,
    String? staddress,
    String? inlatt,
    Alt? alt,
    String? timezone,
    String? region,
    String? postal,
    Poi? poi,
    String? longt,
    String? remaining_credits,
    String? confidence,
    String? inlongt,
    String? cClass,
    String? altgeocode,
  }) {
    return GeoCodeModel(
      statename: statename ?? this.statename,
      distance: distance ?? this.distance,
      elevation: elevation ?? this.elevation,
      osmtags: osmtags ?? this.osmtags,
      state: state ?? this.state,
      latt: latt ?? this.latt,
      city: city ?? this.city,
      prov: prov ?? this.prov,
      geocode: geocode ?? this.geocode,
      geonumber: geonumber ?? this.geonumber,
      country: country ?? this.country,
      stnumber: stnumber ?? this.stnumber,
      staddress: staddress ?? this.staddress,
      inlatt: inlatt ?? this.inlatt,
      alt: alt ?? this.alt,
      timezone: timezone ?? this.timezone,
      region: region ?? this.region,
      postal: postal ?? this.postal,
      poi: poi ?? this.poi,
      longt: longt ?? this.longt,
      remaining_credits: remaining_credits ?? this.remaining_credits,
      confidence: confidence ?? this.confidence,
      inlongt: inlongt ?? this.inlongt,
      cClass: cClass ?? this.cClass,
      altgeocode: altgeocode ?? this.altgeocode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'statename': statename,
      'distance': distance,
      'elevation': elevation,
      'osmtags': osmtags?.toMap(),
      'state': state,
      'latt': latt,
      'city': city,
      'prov': prov,
      'geocode': geocode,
      'geonumber': geonumber,
      'country': country,
      'stnumber': stnumber,
      'staddress': staddress,
      'inlatt': inlatt,
      'alt': alt?.toMap(),
      'timezone': timezone,
      'region': region,
      'postal': postal,
      'poi': poi?.toMap(),
      'longt': longt,
      'remaining_credits': remaining_credits,
      'confidence': confidence,
      'inlongt': inlongt,
      'class': cClass,
      'altgeocode': altgeocode,
    };
  }

  factory GeoCodeModel.fromMap(Map<String, dynamic> map) {
    return GeoCodeModel(
      statename: map['statename'],
      distance: map['distance'],
      elevation: map['elevation'],
      osmtags: Osmtags.fromMap(map['osmtags'] as Map<String, dynamic>),
      state: map['state'] is String ? map['state'] : null,
      latt: map['latt'] is String ? map['latt'] : null,
      city: map['city'] is String ? map['city'] : null,
      prov: map['prov'] is String ? map['prov'] : null,
      geocode: map['geocode'] is String ? map['geocode'] : null,
      geonumber: map['geonumber'] is String ? map['geonumber'] : null,
      country: map['country'] is String ? map['country'] : null,
      stnumber: map['stnumber'] is String ? map['stnumber'] : null,
      staddress: map['staddress'] is String ? map['staddress'] : null,
      inlatt: map['inlatt'] is String ? map['inlatt'] : null,
      alt: map['alt'] != null
          ? Alt.fromMap(map['alt'] as Map<String, dynamic>)
          : null,
      timezone: map['timezone'] is String ? map['timezone'] : null,
      region: map['region'] is String ? map['region'] : null,
      postal: map['postal'] is String ? map['postal'] : null,
      poi: map['poi'] != null
          ? Poi.fromMap(map['poi'] as Map<String, dynamic>)
          : null,
      longt: map['longt'] is String ? map['longt'] : null,
      remaining_credits:
          map['remaining_credits'] is String ? map['remaining_credits'] : null,
      confidence: map['confidence'] is String ? map['confidence'] : null,
      inlongt: map['inlongt'] is String ? map['inlongt'] : null,
      cClass: map['class'] is String ? map['class'] : null,

      altgeocode: map['altgeocode'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GeoCodeModel.fromJson(String source) =>
      GeoCodeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GeoCodeModel &&
        other.statename == statename &&
        other.distance == distance &&
        other.elevation == elevation &&
        other.osmtags == osmtags &&
        other.state == state &&
        other.latt == latt &&
        other.city == city &&
        other.prov == prov &&
        other.geocode == geocode &&
        other.geonumber == geonumber &&
        other.country == country &&
        other.stnumber == stnumber &&
        other.staddress == staddress &&
        other.inlatt == inlatt &&
        other.alt == alt &&
        other.timezone == timezone &&
        other.region == region &&
        other.postal == postal &&
        other.poi == poi &&
        other.longt == longt &&
        other.remaining_credits == remaining_credits &&
        other.confidence == confidence &&
        other.inlongt == inlongt &&
        other.cClass == cClass &&
        other.altgeocode == altgeocode;
  }

  @override
  int get hashCode {
    return statename.hashCode ^
        distance.hashCode ^
        elevation.hashCode ^
        osmtags.hashCode ^
        state.hashCode ^
        latt.hashCode ^
        city.hashCode ^
        prov.hashCode ^
        geocode.hashCode ^
        geonumber.hashCode ^
        country.hashCode ^
        stnumber.hashCode ^
        staddress.hashCode ^
        inlatt.hashCode ^
        alt.hashCode ^
        timezone.hashCode ^
        region.hashCode ^
        postal.hashCode ^
        poi.hashCode ^
        longt.hashCode ^
        remaining_credits.hashCode ^
        confidence.hashCode ^
        inlongt.hashCode ^
        cClass.hashCode ^
        altgeocode.hashCode;
  }
}

class Osmtags {
  final String boundary;
  final String name;
  final String type;
  final String admin_level;
  Osmtags({
    required this.boundary,
    required this.name,
    required this.type,
    required this.admin_level,
  });

  Osmtags copyWith({
    String? boundary,
    String? name,
    String? type,
    String? admin_level,
  }) {
    return Osmtags(
      boundary: boundary ?? this.boundary,
      name: name ?? this.name,
      type: type ?? this.type,
      admin_level: admin_level ?? this.admin_level,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'boundary': boundary,
      'name': name,
      'type': type,
      'admin_level': admin_level,
    };
  }

  factory Osmtags.fromMap(Map<String, dynamic> map) {
    return Osmtags(
      boundary: map['boundary'],
      name: map['name'],
      type: map['type'],
      admin_level: map['admin_level'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Osmtags.fromJson(String source) =>
      Osmtags.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Osmtags(boundary: $boundary, name: $name, type: $type, admin_level: $admin_level)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Osmtags &&
        other.boundary == boundary &&
        other.name == name &&
        other.type == type &&
        other.admin_level == admin_level;
  }

  @override
  int get hashCode {
    return boundary.hashCode ^
        name.hashCode ^
        type.hashCode ^
        admin_level.hashCode;
  }
}

class Alt {
  final List<Loc>? loc;
  Alt({
    required this.loc,
  });

  Alt copyWith({
    List<Loc>? loc,
  }) {
    return Alt(
      loc: loc ?? this.loc,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'loc': loc?.map((x) => x.toMap()).toList(),
    };
  }

  factory Alt.fromMap(Map<String, dynamic> map) {
    return Alt(
      loc: map['loc'] == null
          ? null
          : map['loc'] is List
              ? List<Loc>.from(
                  (map['loc']).map<Loc>(
                    (x) => Loc.fromMap(x as Map<String, dynamic>),
                  ),
                )
              : [Loc.fromMap(map['loc'])],
    );
  }

  String toJson() => json.encode(toMap());

  factory Alt.fromJson(String source) =>
      Alt.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Alt(loc: $loc)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Alt && listEquals(other.loc, loc);
  }

  @override
  int get hashCode => loc.hashCode;
}

class Loc {
  final String? staddress;
  final String? stnumber;
  final String? postal;
  final String? latt;
  final String? city;
  final String? prov;
  final String? longt;
  final String? cClass;
  Loc({
    required this.staddress,
    required this.stnumber,
    required this.postal,
    required this.latt,
    required this.city,
    required this.prov,
    required this.longt,
    required this.cClass,
  });

  Loc copyWith({
    String? staddress,
    String? stnumber,
    String? postal,
    String? latt,
    String? city,
    String? prov,
    String? longt,
    String? cClass,
  }) {
    return Loc(
      staddress: staddress ?? this.staddress,
      stnumber: stnumber ?? this.stnumber,
      postal: postal ?? this.postal,
      latt: latt ?? this.latt,
      city: city ?? this.city,
      prov: prov ?? this.prov,
      longt: longt ?? this.longt,
      cClass: cClass ?? this.cClass,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'staddress': staddress,
      'stnumber': stnumber,
      'postal': postal,
      'latt': latt,
      'city': city,
      'prov': prov,
      'longt': longt,
      'class': cClass,
    };
  }

  factory Loc.fromMap(Map<String, dynamic> map) {
    return Loc(
      staddress: map['staddress'] is String ? map['staddress'] : null,
      stnumber: map['stnumber'] is String ? map['stnumber'] : null,
      postal: map['postal'] is String ? map['postal'] : null,
      latt: map['latt'] is String ? map['latt'] : null,
      city: map['city'] is String ? map['city'] : null,
      prov: map['prov'] is String ? map['prov'] : null,
      longt: map['longt'] is String ? map['longt'] : null,
      cClass: map['class'] is String ? map['class'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Loc.fromJson(String source) =>
      Loc.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Loc(staddress: $staddress, stnumber: $stnumber, postal: $postal, latt: $latt, city: $city, prov: $prov, longt: $longt, cClass: $cClass)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Loc &&
        other.staddress == staddress &&
        other.stnumber == stnumber &&
        other.postal == postal &&
        other.latt == latt &&
        other.city == city &&
        other.prov == prov &&
        other.longt == longt &&
        other.cClass == cClass;
  }

  @override
  int get hashCode {
    return staddress.hashCode ^
        stnumber.hashCode ^
        postal.hashCode ^
        latt.hashCode ^
        city.hashCode ^
        prov.hashCode ^
        longt.hashCode ^
        cClass.hashCode;
  }
}

class Class {}

class Poi {
  final String amenity;
  final String poilat;
  final String poilon;
  final String name;
  final String id;
  final String poidist;
  Poi({
    required this.amenity,
    required this.poilat,
    required this.poilon,
    required this.name,
    required this.id,
    required this.poidist,
  });

  Poi copyWith({
    String? amenity,
    String? poilat,
    String? poilon,
    String? name,
    String? id,
    String? poidist,
  }) {
    return Poi(
      amenity: amenity ?? this.amenity,
      poilat: poilat ?? this.poilat,
      poilon: poilon ?? this.poilon,
      name: name ?? this.name,
      id: id ?? this.id,
      poidist: poidist ?? this.poidist,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'amenity': amenity,
      'poilat': poilat,
      'poilon': poilon,
      'name': name,
      'id': id,
      'poidist': poidist,
    };
  }

  factory Poi.fromMap(Map<String, dynamic> map) {
    return Poi(
      amenity: map['amenity'],
      poilat: map['poilat'],
      poilon: map['poilon'],
      name: map['name'],
      id: map['id'],
      poidist: map['poidist'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Poi.fromJson(String source) =>
      Poi.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Poi(amenity: $amenity, poilat: $poilat, poilon: $poilon, name: $name, id: $id, poidist: $poidist)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Poi &&
        other.amenity == amenity &&
        other.poilat == poilat &&
        other.poilon == poilon &&
        other.name == name &&
        other.id == id &&
        other.poidist == poidist;
  }

  @override
  int get hashCode {
    return amenity.hashCode ^
        poilat.hashCode ^
        poilon.hashCode ^
        name.hashCode ^
        id.hashCode ^
        poidist.hashCode;
  }
}
