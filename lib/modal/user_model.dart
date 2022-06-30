import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? name;
  String? email;
  String? phoneNumber;
  String? image;
  String? address;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? uid;
  List<String>? additionalPhoneNumber;
  String? token;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.phoneNumber,
    this.image,
    this.address,
    this.createdAt,
    this.updatedAt,
    this.additionalPhoneNumber,
    this.token,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      name: data['name'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      image: data['image'],
      address: data['address'],
      createdAt: data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : DateTime.now(),
      updatedAt: data['updatedAt'] != null ? (data['updatedAt'] as Timestamp).toDate() : DateTime.now(),
      additionalPhoneNumber: data['additionalPhoneNumber'] != null ? data['additionalPhoneNumber'].cast<String>() : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'image': image,
      'address': address,
      'createdAt': createdAt ?? DateTime.now(),
      'updatedAt': updatedAt ?? DateTime.now(),
      'additionalPhoneNumber': additionalPhoneNumber,
    };
  }
}
