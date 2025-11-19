import 'dart:convert';

StatsModel statsModelFromJson(String str) =>
    StatsModel.fromJson(json.decode(str));

String statsModelToJson(StatsModel data) => json.encode(data.toJson());

class StatsModel {
  String? message;
  Data? data;

  StatsModel({this.message, this.data});

  StatsModel copyWith({String? message, Data? data}) =>
      StatsModel(message: message ?? this.message, data: data ?? this.data);

  factory StatsModel.fromJson(Map<String, dynamic> json) => StatsModel(
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class Data {
  int? totalAbsen;
  int? totalMasuk;
  int? totalIzin;
  bool? sudahAbsenHariIni;

  Data({
    this.totalAbsen,
    this.totalMasuk,
    this.totalIzin,
    this.sudahAbsenHariIni,
  });

  Data copyWith({
    int? totalAbsen,
    int? totalMasuk,
    int? totalIzin,
    bool? sudahAbsenHariIni,
  }) => Data(
    totalAbsen: totalAbsen ?? this.totalAbsen,
    totalMasuk: totalMasuk ?? this.totalMasuk,
    totalIzin: totalIzin ?? this.totalIzin,
    sudahAbsenHariIni: sudahAbsenHariIni ?? this.sudahAbsenHariIni,
  );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalAbsen: json["total_absen"],
    totalMasuk: json["total_masuk"],
    totalIzin: json["total_izin"],
    sudahAbsenHariIni: json["sudah_absen_hari_ini"],
  );

  Map<String, dynamic> toJson() => {
    "total_absen": totalAbsen,
    "total_masuk": totalMasuk,
    "total_izin": totalIzin,
    "sudah_absen_hari_ini": sudahAbsenHariIni,
  };
}
