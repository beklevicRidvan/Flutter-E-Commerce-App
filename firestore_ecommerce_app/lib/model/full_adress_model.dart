import 'dart:convert';

FullAdressModel fullAddressModelFromJson(String str) => FullAdressModel.fromJson(json.decode(str));

String fullAddressModelToJson(FullAdressModel data) => json.encode(data.toJson());

class FullAdressModel {
  final int placeId;
  final String licence;
  final String osmType;
  final int osmId;
  final String lat;
  final String lon;
  final String fullAddressModelClass;
  final String type;
  final int placeRank;
  final double importance;
  final String addresstype;
  final String name;
  final String displayName;
  final Address address;
  final List<String> boundingbox;

  FullAdressModel({
    required this.placeId,
    required this.licence,
    required this.osmType,
    required this.osmId,
    required this.lat,
    required this.lon,
    required this.fullAddressModelClass,
    required this.type,
    required this.placeRank,
    required this.importance,
    required this.addresstype,
    required this.name,
    required this.displayName,
    required this.address,
    required this.boundingbox,
  });

  factory FullAdressModel.fromJson(Map<String, dynamic> json) => FullAdressModel(
    placeId: json["place_id"] ?? 0,
    licence: json["licence"] ?? '',
    osmType: json["osm_type"] ?? '',
    osmId: json["osm_id"] ?? 0,
    lat: json["lat"] ?? '',
    lon: json["lon"] ?? '',
    fullAddressModelClass: json["class"] ?? '',
    type: json["type"] ?? '',
    placeRank: json["place_rank"] ?? 0,
    importance: json["importance"]?.toDouble() ?? 0.0,
    addresstype: json["addresstype"] ?? '',
    name: json["name"] ?? '',
    displayName: json["display_name"] ?? '',
    address: Address.fromJson(json["address"]),
    boundingbox: List<String>.from(json["boundingbox"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "place_id": placeId,
    "licence": licence,
    "osm_type": osmType,
    "osm_id": osmId,
    "lat": lat,
    "lon": lon,
    "class": fullAddressModelClass,
    "type": type,
    "place_rank": placeRank,
    "importance": importance,
    "addresstype": addresstype,
    "name": name,
    "display_name": displayName,
    "address": address.toJson(),
    "boundingbox": List<dynamic>.from(boundingbox.map((x) => x)),
  };
}

class Address {
  final String road;
  final String suburb;
  final String town;
  final String province;
  final String iso31662Lvl4;
  final String region;
  final String postcode;
  final String country;
  final String countryCode;

  Address({
    required this.road,
    required this.suburb,
    required this.town,
    required this.province,
    required this.iso31662Lvl4,
    required this.region,
    required this.postcode,
    required this.country,
    required this.countryCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    road: json["road"] ?? '',
    suburb: json["suburb"] ?? '',
    town: json["town"] ?? '',
    province: json["province"] ?? '',
    iso31662Lvl4: json["ISO3166-2-lvl4"] ?? '',
    region: json["region"] ?? '',
    postcode: json["postcode"] ?? '',
    country: json["country"] ?? '',
    countryCode: json["country_code"] ?? '',
  );

  Map<String, dynamic> toJson() => {
    "road": road,
    "suburb": suburb,
    "town": town,
    "province": province,
    "ISO3166-2-lvl4": iso31662Lvl4,
    "region": region,
    "postcode": postcode,
    "country": country,
    "country_code": countryCode,
  };
}
