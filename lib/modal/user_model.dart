import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:street_animal_rescue/enum/user_type_enum.dart';

class UserModel {
  String? name;
  String? email;
  String? phoneNumber;
  String? image;
  String? address;
  int? userType;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? uid;
  bool isVerifiedUser;
  List<String>? additionalPhoneNumber;
  String? token;
  String? password;

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
    this.userType,
    this.password,
    this.isVerifiedUser = false,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      name: data['name'],
      email: data['email'],
      password: data['password'],
      phoneNumber: data['phoneNumber'],
      image: data['image'],
      userType: data['userType'] ?? UserTypeEnum.Individual.index,
      address: data['address'],
      isVerifiedUser: data['isVerifiedUser'],
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
      'userType': userType ?? UserTypeEnum.Individual.index,
      'isVerifiedUser': isVerifiedUser,
      'createdAt': createdAt ?? DateTime.now(),
      'updatedAt': updatedAt ?? DateTime.now(),
      'password': password,
      'additionalPhoneNumber': additionalPhoneNumber,
    };
  }
}
