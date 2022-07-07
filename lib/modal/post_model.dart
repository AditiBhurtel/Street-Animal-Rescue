import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String? id;
  final String? image;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;

  PostModel({
    this.id,
    this.image,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PostModel.fromMap(Map<String, dynamic> data) {
    return PostModel(
      id: data['id'],
      image: data['image'],
      title: data['title'],
      createdAt: data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : DateTime.now(),
      updatedAt: data['updatedAt'] != null ? (data['updatedAt'] as Timestamp).toDate() : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'title': title,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
