// To parse this JSON data, do
//
//     final sampleApiObject = sampleApiObjectFromJson(jsonString);

import 'dart:convert';

SampleApiObject sampleApiObjectFromJson(String str) => SampleApiObject.fromJson(json.decode(str));

String sampleApiObjectToJson(SampleApiObject data) => json.encode(data.toJson());

class SampleApiObject {
  int? id;
  String? name;
  String? address;
  String? zip;
  String? country;
  int? employeeCount;
  String? industry;
  int? marketCap;
  String? domain;
  String? logo;
  String? ceoName;

  SampleApiObject({
    this.id,
    this.name,
    this.address,
    this.zip,
    this.country,
    this.employeeCount,
    this.industry,
    this.marketCap,
    this.domain,
    this.logo,
    this.ceoName,
  });

  factory SampleApiObject.fromJson(Map<String, dynamic> json) => SampleApiObject(
    id: json["id"],
    name: json["name"],
    address: json["address"],
    zip: json["zip"],
    country: json["country"],
    employeeCount: json["employeeCount"],
    industry: json["industry"],
    marketCap: json["marketCap"],
    domain: json["domain"],
    logo: json["logo"],
    ceoName: json["ceoName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "address": address,
    "zip": zip,
    "country": country,
    "employeeCount": employeeCount,
    "industry": industry,
    "marketCap": marketCap,
    "domain": domain,
    "logo": logo,
    "ceoName": ceoName,
  };
}
