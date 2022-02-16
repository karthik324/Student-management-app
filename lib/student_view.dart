import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:student_manage/student.dart';

class StudentView extends StatelessWidget {
  var box = Hive.box<Student>('student');
  final List<Student> obj;
  final int index;
  StudentView({Key? key, required this.obj, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(obj[index].name),
        centerTitle: true,
        elevation: 10,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
                radius: 50,
                backgroundColor: Colors.green.shade100,
                child: obj[index].imagePath == null
                    ? null
                    : ClipOval(
                        child: Image.file(
                          File(obj[index].imagePath),
                          width: 160,
                          height: 160,
                          fit: BoxFit.cover,
                        ),
                      )),
            const SizedBox(height: 10),
            Text(
              obj[index].name,
              style: const TextStyle(color: Colors.lightGreen, fontSize: 35),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              obj[index].place,
              style: const TextStyle(color: Colors.lightGreen, fontSize: 25),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              ('${obj[index].age}'),
              style: const TextStyle(color: Colors.lightGreen, fontSize: 15),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
