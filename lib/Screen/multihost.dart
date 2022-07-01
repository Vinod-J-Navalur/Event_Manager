import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_organizer/Screen/homescreen.dart';
import 'package:event_organizer/Screen/login.dart';
import 'package:event_organizer/host/hostcloud.dart';
import 'package:event_organizer/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:date_time_picker/date_time_picker.dart';

class upload_Details extends StatefulWidget {
  const upload_Details({Key? key}) : super(key: key);

  @override
  State<upload_Details> createState() => _upload_DetailsState();
}

class _upload_DetailsState extends State<upload_Details> {
  String? _selectedTime;

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

  final databaseRef = FirebaseDatabase.instance.ref().child("user");
  //User Variable
  User? user;
  String? Zone;
  // To check wheather user has logged in or not
  bool isloggedin = false;

  final _auth = FirebaseAuth.instance;

  getUser() async {
    User? firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;
    print("hi praveen ");

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isloggedin = true;
      });
    }
  }

  int _currentIndex = 0;

  _onTap() async {
    if (_currentIndex == 4) {
      await _auth.signOut();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => const loginscreen()));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) =>
              _children[_currentIndex])); // this has changed
    }
  }

  final List<Widget> _children = [
    const HomeScreen(),
    const user_profile(),
    const upload_Details(),
  ];

  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
    this.getUser();
  }

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
              ElevatedButton.icon(
                  icon: Icon(Icons.punch_clock),
                  onPressed: _show,
                  label: Text(
                    _selectedTime != null ? _selectedTime! : 'Select Time',
                    style: const TextStyle(fontSize: 30),
                  )),
              const SizedBox(height: 20),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline_outlined),
              label: "Add Event"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Lists"),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: "Logout"),
        ],
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.white,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _onTap();
        },
      ),
    );
  }

  Future<void> _show() async {
    final TimeOfDay? result =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (result != null) {
      setState(() {
        _selectedTime = result.format(context);
      });
      print(_selectedTime);
    }
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
    party.uid = user!.uid;
    party.party_name = EventEditingcontroller.text;
    party.image = url;
    party.location = locationEditingcontroller.text;
    party.discription = discriptionEditingcontroller.text;
    party.date = endDateTimeEditingController.text;
    party.time = _selectedTime!.toString();

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

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const loginscreen()));
      }
    });
  }
}
