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
  //final Adminareas? adminareas;
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
    //required this.adminareas,
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
    //  Adminareas? adminareas,
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
      //   adminareas: adminareas ?? this.adminareas,
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
      //'adminareas': adminareas?.toMap(),
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
      //adminareas: Adminareas.fromMap(map['adminareas'] as Map<String, dynamic>),
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
        //    other.adminareas == adminareas &&
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
        //     adminareas.hashCode ^
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

/* class Adminareas {
  final Admin6 admin6;
  final Admin8 admin8;
  final Admin5 admin5;
  Adminareas({
    required this.admin6,
    required this.admin8,
    required this.admin5,
  });

  Adminareas copyWith({
    Admin6? admin6,
    Admin8? admin8,
    Admin5? admin5,
  }) {
    return Adminareas(
      admin6: admin6 ?? this.admin6,
      admin8: admin8 ?? this.admin8,
      admin5: admin5 ?? this.admin5,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'admin6': admin6.toMap(),
      'admin8': admin8.toMap(),
      'admin5': admin5.toMap(),
    };
  }

  factory Adminareas.fromMap(Map<String, dynamic> map) {
    return Adminareas(
      admin6: Admin6.fromMap(map['admin6'] as Map<String, dynamic>),
      admin8: Admin8.fromMap(map['admin8'] as Map<String, dynamic>),
      admin5: Admin5.fromMap(map['admin5'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Adminareas.fromJson(String source) =>
      Adminareas.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Adminareas(admin6: $admin6, admin8: $admin8, admin5: $admin5)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Adminareas &&
        other.admin6 == admin6 &&
        other.admin8 == admin8 &&
        other.admin5 == admin5;
  }

  @override
  int get hashCode => admin6.hashCode ^ admin8.hashCode ^ admin5.hashCode;
}

class Admin6 {
  final String level;
  final String boundary;
  final String name;
  final String type;
  final String admin_level;
  Admin6({
    required this.level,
    required this.boundary,
    required this.name,
    required this.type,
    required this.admin_level,
  });

  Admin6 copyWith({
    String? level,
    String? boundary,
    String? name,
    String? type,
    String? admin_level,
  }) {
    return Admin6(
      level: level ?? this.level,
      boundary: boundary ?? this.boundary,
      name: name ?? this.name,
      type: type ?? this.type,
      admin_level: admin_level ?? this.admin_level,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'level': level,
      'boundary': boundary,
      'name': name,
      'type': type,
      'admin_level': admin_level,
    };
  }

  factory Admin6.fromMap(Map<String, dynamic> map) {
    return Admin6(
      level: map['level']  ,
      boundary: map['boundary']  ,
      name: map['name']  ,
      type: map['type']  ,
      admin_level: map['admin_level']  ,
    );
  }

  String toJson() => json.encode(toMap());

  factory Admin6.fromJson(String source) =>
      Admin6.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Admin6(level: $level, boundary: $boundary, name: $name, type: $type, admin_level: $admin_level)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Admin6 &&
        other.level == level &&
        other.boundary == boundary &&
        other.name == name &&
        other.type == type &&
        other.admin_level == admin_level;
  }

  @override
  int get hashCode {
    return level.hashCode ^
        boundary.hashCode ^
        name.hashCode ^
        type.hashCode ^
        admin_level.hashCode;
  }
}

class Admin8 {
  final String level;
  final String boundary;
  final String name;
  final String type;
  final String admin_level;
  Admin8({
    required this.level,
    required this.boundary,
    required this.name,
    required this.type,
    required this.admin_level,
  });

  Admin8 copyWith({
    String? level,
    String? boundary,
    String? name,
    String? type,
    String? admin_level,
  }) {
    return Admin8(
      level: level ?? this.level,
      boundary: boundary ?? this.boundary,
      name: name ?? this.name,
      type: type ?? this.type,
      admin_level: admin_level ?? this.admin_level,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'level': level,
      'boundary': boundary,
      'name': name,
      'type': type,
      'admin_level': admin_level,
    };
  }

  factory Admin8.fromMap(Map<String, dynamic> map) {
    return Admin8(
      level: map['level']  ,
      boundary: map['boundary']  ,
      name: map['name']  ,
      type: map['type']  ,
      admin_level: map['admin_level']  ,
    );
  }

  String toJson() => json.encode(toMap());

  factory Admin8.fromJson(String source) =>
      Admin8.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Admin8(level: $level, boundary: $boundary, name: $name, type: $type, admin_level: $admin_level)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Admin8 &&
        other.level == level &&
        other.boundary == boundary &&
        other.name == name &&
        other.type == type &&
        other.admin_level == admin_level;
  }

  @override
  int get hashCode {
    return level.hashCode ^
        boundary.hashCode ^
        name.hashCode ^
        type.hashCode ^
        admin_level.hashCode;
  }
}

class Admin5 {
  final String wikipedia;
  final String wikidata;
  final String name_mr;
  final String name;
  final String admin_level;
  final String level;
  final String name_ar;
  final String boundary;
  final String name_pa;
  final String type;
  final String name_en;
  final String name_hi;
  Admin5({
    required this.wikipedia,
    required this.wikidata,
    required this.name_mr,
    required this.name,
    required this.admin_level,
    required this.level,
    required this.name_ar,
    required this.boundary,
    required this.name_pa,
    required this.type,
    required this.name_en,
    required this.name_hi,
  });

  Admin5 copyWith({
    String? wikipedia,
    String? wikidata,
    String? name_mr,
    String? name,
    String? admin_level,
    String? level,
    String? name_ar,
    String? boundary,
    String? name_pa,
    String? type,
    String? name_en,
    String? name_hi,
  }) {
    return Admin5(
      wikipedia: wikipedia ?? this.wikipedia,
      wikidata: wikidata ?? this.wikidata,
      name_mr: name_mr ?? this.name_mr,
      name: name ?? this.name,
      admin_level: admin_level ?? this.admin_level,
      level: level ?? this.level,
      name_ar: name_ar ?? this.name_ar,
      boundary: boundary ?? this.boundary,
      name_pa: name_pa ?? this.name_pa,
      type: type ?? this.type,
      name_en: name_en ?? this.name_en,
      name_hi: name_hi ?? this.name_hi,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'wikipedia': wikipedia,
      'wikidata': wikidata,
      'name_mr': name_mr,
      'name': name,
      'admin_level': admin_level,
      'level': level,
      'name_ar': name_ar,
      'boundary': boundary,
      'name_pa': name_pa,
      'type': type,
      'name_en': name_en,
      'name_hi': name_hi,
    };
  }

  factory Admin5.fromMap(Map<String, dynamic> map) {
    return Admin5(
      wikipedia: map['wikipedia']  ,
      wikidata: map['wikidata']  ,
      name_mr: map['name_mr']  ,
      name: map['name']  ,
      admin_level: map['admin_level']  ,
      level: map['level']  ,
      name_ar: map['name_ar']  ,
      boundary: map['boundary']  ,
      name_pa: map['name_pa']  ,
      type: map['type']  ,
      name_en: map['name_en']  ,
      name_hi: map['name_hi']  ,
    );
  }

  String toJson() => json.encode(toMap());

  factory Admin5.fromJson(String source) =>
      Admin5.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Admin5(wikipedia: $wikipedia, wikidata: $wikidata, name_mr: $name_mr, name: $name, admin_level: $admin_level, level: $level, name_ar: $name_ar, boundary: $boundary, name_pa: $name_pa, type: $type, name_en: $name_en, name_hi: $name_hi)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Admin5 &&
        other.wikipedia == wikipedia &&
        other.wikidata == wikidata &&
        other.name_mr == name_mr &&
        other.name == name &&
        other.admin_level == admin_level &&
        other.level == level &&
        other.name_ar == name_ar &&
        other.boundary == boundary &&
        other.name_pa == name_pa &&
        other.type == type &&
        other.name_en == name_en &&
        other.name_hi == name_hi;
  }

  @override
  int get hashCode {
    return wikipedia.hashCode ^
        wikidata.hashCode ^
        name_mr.hashCode ^
        name.hashCode ^
        admin_level.hashCode ^
        level.hashCode ^
        name_ar.hashCode ^
        boundary.hashCode ^
        name_pa.hashCode ^
        type.hashCode ^
        name_en.hashCode ^
        name_hi.hashCode;
  }
}
 */