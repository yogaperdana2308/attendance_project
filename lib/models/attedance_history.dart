class AttendanceHistoryModel {
  int? id;
  String? attendanceDate;
  String? checkInTime;
  String? checkOutTime;
  double? checkInLat;
  double? checkInLng;
  double? checkOutLat;
  double? checkOutLng;
  String? checkInAddress;
  String? checkOutAddress;
  String? status;

  AttendanceHistoryModel({
    this.id,
    this.attendanceDate,
    this.checkInTime,
    this.checkOutTime,
    this.checkInLat,
    this.checkInLng,
    this.checkOutLat,
    this.checkOutLng,
    this.checkInAddress,
    this.checkOutAddress,
    this.status,
  });

  factory AttendanceHistoryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceHistoryModel(
      id: json["id"],
      attendanceDate: json["attendance_date"],
      checkInTime: json["check_in_time"],
      checkOutTime: json["check_out_time"],
      checkInLat: json["check_in_lat"]?.toDouble(),
      checkInLng: json["check_in_lng"]?.toDouble(),
      checkOutLat: json["check_out_lat"]?.toDouble(),
      checkOutLng: json["check_out_lng"]?.toDouble(),
      checkInAddress: json["check_in_address"],
      checkOutAddress: json["check_out_address"],
      status: json["status"],
    );
  }
}
