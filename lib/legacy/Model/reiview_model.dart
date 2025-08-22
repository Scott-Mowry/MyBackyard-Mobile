import 'package:backyard/legacy/Model/user_model.dart';

class Review {
  int? id;
  int? busId;
  String? rate;
  String? feedback;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;

  Review({this.id, this.busId, this.rate, this.feedback, this.createdAt, this.updatedAt, this.user});

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json['id'],
    busId: int.parse(json['bus_id'].toString()),
    rate: json['rate'],
    feedback: json['feedback'],
    createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at']),
    updatedAt: json['updated_at'] == null ? null : DateTime.parse(json['updated_at']),
    user: json['user'] == null ? null : User.setUser(json['user']),
  );
}
