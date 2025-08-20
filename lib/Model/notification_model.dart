import 'package:backyard/Model/user_model.dart';

class NotificationModel {
  String id = '';
  String title = '';
  String body = '';
  String type = '';
  String createdAt = '';
  String sessionId = '';
  String date = '';
  User? user;

  NotificationModel({
    this.id = '',
    this.title = '',
    this.body = '',
    this.type = '',
    this.createdAt = '',
    this.sessionId = '',
    this.date = '',
    this.user,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? '';
    title = json['title'] ?? '';
    body = json['body'] ?? '';
    type = json['type'] ?? '';
    createdAt = json['createdAt'] ?? '';
    date = json['date'] ?? '';
    sessionId = json['session_id'] ?? '';
    user = (json['sender_id'] as Map<String, dynamic>?) != null
        ? User.setUser(json['sender_id'] as Map<String, dynamic>)
        : null;
  }
}
