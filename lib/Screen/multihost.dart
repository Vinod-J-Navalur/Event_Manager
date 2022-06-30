import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_organizer/host/hostcloud.dart';
import 'package:event_organizer/model/UserModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:date_time_picker/date_time_picker.dart';

class upload_Details extends StatefulWidget {
  const upload_Details({Key? key}) : super(key: key);

  @override
  State<upload_Details> createState() => _upload_DetailsState();
}

class _upload_DetailsState extends State<upload_Details> {
  final _formkey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final EventEditingcontroller = new TextEditingController();
  final locationEditingcontroller = new TextEditingController();
  final discriptionEditingcontroller = new TextEditingController();
  final endDateTimeEditingController = TextEditingController();
  final timeEditingcontroller = new TextEditingController();
  String? url;
  List<XFile> _SelectedFiles = [];
  FirebaseStorage _storageRef = FirebaseStorage.instance;
  List<String?> _arrImagesUrls = [];
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final event_name = TextFormField(
      autofocus: false,
      controller: EventEditingcontroller,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Event Name cannot be empty");
        }
      },
      onSaved: (value) {
        EventEditingcontroller.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        fillColor: Colors.grey[800],
        filled: true,
        prefixIcon: Icon(
          Icons.account_circle,
          color: Color.fromARGB(255, 123, 182, 230),
        ),
        contentPadding: EdgeInsets.fromLTRB(10, 15, 20, 15),
        hintText: "Event Name",
        hintStyle: TextStyle(
            color: Color.fromARGB(255, 123, 182, 230),
            fontWeight: FontWeight.bold),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    final discription = TextFormField(
      autofocus: false,
      controller: discriptionEditingcontroller,
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 10,
      validator: (value) {
        if (value!.isEmpty) {
          return ("location cannot be empty");
        }
      },
      onSaved: (value) {
        EventEditingcontroller.text = value!;
      },
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
        fillColor: Colors.grey[800],
        filled: true,
        prefixIcon: Icon(
          Icons.account_circle,
          color: Color.fromARGB(255, 123, 182, 230),
        ),
        contentPadding: EdgeInsets.fromLTRB(10, 15, 20, 15),
        hintText: "Discription of event",
        hintStyle: TextStyle(
            color: Color.fromARGB(255, 123, 182, 230),
            fontWeight: FontWeight.bold),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    final location = TextFormField(
      autofocus: false,
      controller: locationEditingcontroller,
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 5,
      validator: (value) {
        if (value!.isEmpty) {
          return ("location cannot be empty");
        }
      },
      onSaved: (value) {
        EventEditingcontroller.text = value!;
      },
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
        fillColor: Colors.grey[800],
        filled: true,
        prefixIcon: Icon(
          Icons.account_circle,
          color: Color.fromARGB(255, 123, 182, 230),
        ),
        contentPadding: EdgeInsets.fromLTRB(10, 15, 20, 15),
        hintText: "Location of event",
        hintStyle: TextStyle(
            color: Color.fromARGB(255, 123, 182, 230),
            fontWeight: FontWeight.bold),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final dateTimeField = TextField(
      autofocus: false,
      controller: endDateTimeEditingController,
      keyboardType: TextInputType.number,
      onTap: () {
        _selectDate(context);
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.date_range),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Select Date",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
    final time = TextFormField(
      autofocus: false,
      controller: timeEditingcontroller,
      keyboardType: TextInputType.name,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Time is compulsary");
        }
      },
      onSaved: (value) {
        EventEditingcontroller.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        fillColor: Colors.grey[800],
        filled: true,
        prefixIcon: Icon(
          Icons.account_circle,
          color: Color.fromARGB(255, 123, 182, 230),
        ),
        contentPadding: EdgeInsets.fromLTRB(10, 15, 20, 15),
        hintText: "Time",
        hintStyle: TextStyle(
            color: Color.fromARGB(255, 123, 182, 230),
            fontWeight: FontWeight.bold),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Host"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              _SelectedFiles.length == 0
                  ? const Padding(
                      padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                      child: Text("Select only one image"),
                    )
                  : Padding(
                      padding: const EdgeInsets.fromLTRB(15, 16, 15, 0),
                      child: Image.file(File(_SelectedFiles[0].path),
                          width: 250, height: 250, fit: BoxFit.fill),
                    ),
              OutlinedButton(
                  onPressed: () {
                    SelectImage();
                  },
                  child: Text("Select Image")),
              SizedBox(
                height: 10,
              ),
              event_name,
              SizedBox(
                height: 10,
              ),
              location,
              SizedBox(
                height: 10,
              ),
              discription,
              SizedBox(
                height: 10,
              ),
              dateTimeField,
              SizedBox(
                height: 10,
              ),
              time,
              ElevatedButton.icon(
                  onPressed: () {
                    uploadFunction(_SelectedFiles);
                  },
                  icon: Icon(Icons.file_upload),
                  label: Text("Upload Event")),
            ],
          ),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate! : DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2040),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Colors.deepPurple,
                onPrimary: Colors.white,
                surface: Colors.blueGrey,
                onSurface: Colors.black54,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child!,
          );
        });
    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      endDateTimeEditingController
        ..text = DateFormat.yMMMd().format(_selectedDate!)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: endDateTimeEditingController.text.length,
            affinity: TextAffinity.upstream));
    }
  }

  Future<void> uploadFunction(List<XFile> _images) async {
    for (int i = 0; i < _images.length; i++) {
      uploadFile(_images[i]);
    }
  }

  Future<void> uploadFile(XFile _image) async {
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child("Party").child(_image.name);
    UploadTask uploadTask = firebaseStorageRef.putFile(File(_image.path));
    TaskSnapshot taskSnapshot = await uploadTask;
    url = (await taskSnapshot.ref.getDownloadURL());
    print(url);

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Party party = Party();

    party.party_name = EventEditingcontroller.text;
    party.image = url;
    party.location = locationEditingcontroller.text;
    party.discription = discriptionEditingcontroller.text;
    party.date = timeEditingcontroller.text;
    party.time = timeEditingcontroller.text;

    await firebaseFirestore
        .collection("party")
        .doc(party.party_name)
        .set(party.toMap());

    Fluttertoast.showToast(msg: "updated Successfully");
  }

  Future<void> SelectImage() async {
    if (_SelectedFiles != null) {
      _SelectedFiles.clear();
    }
    try {
      final List<XFile>? imgs = await _picker.pickMultiImage();
      if (imgs!.isNotEmpty) {
        _SelectedFiles.addAll(imgs);
      }
      print("List of selected Images : " + imgs.length.toString());
    } catch (e) {
      print("Something worng : " + e.toString());
    }
    setState(() {});
  }
}
