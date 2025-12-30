// To parse this JSON data, do
//
//     final modelSampleApi = modelSampleApiFromJson(jsonString);

import 'dart:convert';

List<ModelSampleApi> modelSampleApiFromJson(String str) => List<ModelSampleApi>.from(json.decode(str).map((x) => ModelSampleApi.fromJson(x)));

String modelSampleApiToJson(List<ModelSampleApi> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ModelSampleApi {
  int ? id;
  String ? name;
  String ? address;
  String ? zip;
  String ? country;
  int ? employeeCount;
  String ? industry;
  int ? marketCap;
  String ? domain;
  String ? logo;
  String ? ceoName;

  ModelSampleApi({
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

  factory ModelSampleApi.fromJson(Map<String, dynamic> json) => ModelSampleApi(
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

