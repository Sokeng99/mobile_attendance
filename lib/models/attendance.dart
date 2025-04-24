import 'package:mobile_attendance/db/collections/attendance_collection.dart';
import 'package:mobile_attendance/repositories/base_model.dart';

class AttendanceModel extends BaseModel<AttendanceModel> {
  final int? id;
  final int? userId;
  final String? userName;
  final DateTime? checkInTime;
  final String? status;

  AttendanceModel({this.id, this.userId, this.userName, this.checkInTime, this.status});
  
  @override
  AttendanceModel fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      checkInTime: json['checkInTime'],
      status: json['status'],
    );
  }
  
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'checkInTime': checkInTime,
      'status': status,
    };
  }

  AttendanceCollection get toAttendanceCollection {
    return AttendanceCollection()
    ..userId = userId
    ..userName = userName
    ..checkInTime = checkInTime
    ..status = status;
  }
    
    
}
