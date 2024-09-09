import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:student_app/database/db_functions.dart';
import 'package:student_app/database/db_model.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final inputName = TextEditingController();
  final inputAge = TextEditingController();
  final inputGuardian = TextEditingController();
  final inputContact = TextEditingController();
  final formKey = GlobalKey<FormState>();

  String? classNumber;
  String? division;
  Uint8List? webImage;
  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        webImage = result.files.first.bytes;
      });
    }
  }

  Future<void> addStudentButtonClicked() async {
    final name = inputName.text.trim();
    final age = inputAge.text.trim();
    final guardian = inputGuardian.text.trim();
    final contact = inputContact.text.trim();

    if (name.isNotEmpty &&
        age.isNotEmpty &&
        guardian.isNotEmpty &&
        contact.isNotEmpty &&
        classNumber!.isNotEmpty &&
        division!.isNotEmpty) {
      final newStudent = StudentDBModel(
          name: name,
          age: age,
          guardian: guardian,
          contact: contact,
          image: webImage,
          classNumber: classNumber!,
          division: division!);

      try {
        await addStudent(newStudent);

        Navigator.of(context).pop();
      } catch (e) {
        print("Error adding student: $e");

        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to add student. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                InkWell(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage:
                        webImage != null ? MemoryImage(webImage!) : null,
                    child: webImage == null
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: inputName,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Name',
                          hintText: 'Enter name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Name required';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: inputAge,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Age',
                          hintText: 'Enter age',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Age required';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: classNumber,
                              hint: const Text('Class'),
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.all(10)),
                              items: [
                                '1',
                                '2',
                                '3',
                                '4',
                                '5',
                                '6',
                                '7',
                                '8',
                                '9',
                                '10'
                              ].map((String classValue) {
                                return DropdownMenuItem<String>(
                                  value: classValue,
                                  child: Text(classValue),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  classNumber = value!;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Class required';
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                          ),
                          const SizedBox(width: 90),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: division,
                              hint: const Text('Division'),
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.all(8)),
                              items: [
                                'A',
                                'B',
                                'C',
                                'D',
                                'E',
                                'F',
                                'G',
                                'H',
                                'I',
                                'J'
                              ].map((String divisionValue) {
                                return DropdownMenuItem<String>(
                                  value: divisionValue,
                                  child: Text(divisionValue),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  division = value!;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Divition required';
                                }
                                return null;
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: inputGuardian,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Guardian name',
                          hintText: 'Enter guardian name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Guardian name required';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: inputContact,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Phone number',
                          hintText: 'Phone number',
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone number required';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const SizedBox(width: 10),
                          TextButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                addStudentButtonClicked();
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.green),
                            ),
                            child: const Text(
                              'Add',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 10),
                          TextButton(
                            onPressed: () {
                              clear();
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.red),
                            ),
                            child: const Text(
                              'Clear',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void clear() {
    inputName.clear();
    inputAge.clear();
    inputGuardian.clear();
    inputContact.clear();

    setState(() {
      webImage = null;
    });
  }
}
