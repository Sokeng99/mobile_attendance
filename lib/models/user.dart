import 'package:mobile_attendance/db/collections/user_collection.dart';
import 'package:mobile_attendance/repositories/base_model.dart';

class UserModel extends BaseModel<UserModel> {
  final int? userId;
  final String? name;
  final DateTime? registeredAt;

  UserModel({this.userId, this.name, this.registeredAt});

  
  @override
  UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      name: json['name'],
      registeredAt: json['registeredAt'],
    );
  }
  
  @override
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'registeredAt': registeredAt,
    };
  }
  
  UserCollection get toUserCollection {
    return UserCollection()
    ..name = name
    ..registeredAt = registeredAt;
  }
} 