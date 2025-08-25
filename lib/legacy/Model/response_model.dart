import 'dart:convert';

ResponseModel responseModelFromJson(String str) => ResponseModel.fromJson(json.decode(str));

class ResponseModel {
  final int? status;
  final String? message;
  final dynamic data;

  const ResponseModel({required this.status, required this.message, required this.data});

  factory ResponseModel.fromJson(Map<String, dynamic> json) =>
      ResponseModel(status: json['status'], message: json['message'], data: json['data']);
}
