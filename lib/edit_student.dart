import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_manage/student.dart';
import 'dart:core';

class EditStudent extends StatefulWidget {
  var box = Hive.box<Student>('student');
  final List<Student> obj;
  final int index;
  // final formKey = GlobalKey<FormState>();

  EditStudent({Key? key, required this.obj, required this.index})
      : super(key: key);

  @override
  _EditStudentState createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController placeController = TextEditingController();

  int? newIndex;
  int? newKey;
  int? accessKey;
  XFile? image;
  String? imagePath;

  void details() {
    nameController.text = widget.obj[widget.index].name;
    ageController.text = widget.obj[widget.index].age.toString();
    placeController.text = widget.obj[widget.index].place;
    imagePath = widget.obj[widget.index].imagePath;
    newKey = widget.obj[widget.index].key;
    List<Student> student = widget.box.values.toList();
    for (int i = 0; i < student.length; i++) {
      if (student[i].key == newKey) {
        accessKey = i;
        break;
      }
    }
  }

  @override
  void initState() {
    details();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit ${widget.obj[widget.index].name}'),
          elevation: 10,
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (imagePath != null)
                    ClipRRect(
                      child: Image.file(
                        File(imagePath!),
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: nameController,
                    style: const TextStyle(fontSize: 16),
                    decoration: const InputDecoration(
                        labelText: 'Name', enabledBorder: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 16),
                    decoration: const InputDecoration(
                        labelText: 'Age', enabledBorder: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: placeController,
                    style: const TextStyle(fontSize: 16),
                    decoration: const InputDecoration(
                        labelText: 'Place',
                        enabledBorder: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () =>
                              getImage(source: ImageSource.gallery),
                          child: const Text('Select New Image')),
                      ElevatedButton(
                          onPressed: () => getImage(source: ImageSource.camera),
                          child: const Text('Take New Image')),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        widget.box.putAt(
                            accessKey!,
                            Student(
                                imagePath: imagePath,
                                name: nameController.text,
                                age: int.parse(ageController.text),
                                place: placeController.text));
                        Navigator.pop(context);
                      },
                      child: const Text('Submit changes'))
                ],
              ),
            ),
          ),
        ));
  }

  getImage({required ImageSource source}) async {
    image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      setState(() {
        imagePath = (image!.path);
      });
    } else {
      return null;
    }
  }
}
