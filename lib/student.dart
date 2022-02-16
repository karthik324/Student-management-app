import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
part 'student.g.dart';

// import 'package:flutter/material.dart';

@HiveType(typeId: 0)
class Student extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int age;

  @HiveField(2)
  final String place;

  @HiveField(3)
  final dynamic imagePath;

  Student(
      {required this.name,
      required this.age,
      required this.place,
      this.imagePath});
}
