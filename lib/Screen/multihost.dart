import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_organizer/Screen/homescreen.dart';
import 'package:event_organizer/Screen/hoted_events.dart';
import 'package:event_organizer/Screen/login.dart';
import 'package:event_organizer/constant/loading.dart';
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
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class upload_Details extends StatefulWidget {
  const upload_Details({Key? key}) : super(key: key);

  @override
  State<upload_Details> createState() => _upload_DetailsState();
}

class _upload_DetailsState extends State<upload_Details> {
  String? _selectedTime;

  static int count = 0;
  final _formkey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final EventEditingcontroller = new TextEditingController();
  final locationEditingcontroller = new TextEditingController();
  final discriptionEditingcontroller = new TextEditingController();
  final endDateTimeEditingController = TextEditingController();
  final timeEditingcontroller = new TextEditingController();
  final priceEditingcontroller = new TextEditingController();
  String? url;
  List<XFile> _SelectedFiles = [];
  FirebaseStorage _storageRef = FirebaseStorage.instance;
  List<String?> _arrImagesUrls = [];
  DateTime? _selectedDate;
  bool loading = false;

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
    const hosted()
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
        //fillColor: Colors.indigo[00],
        //filled: true,
        labelText: 'Event Name',
        prefixIcon: Icon(
          Icons.account_circle,
          color: Theme.of(context).primaryColor,
        ),
        contentPadding: EdgeInsets.fromLTRB(10, 15, 20, 15),
        //hintText: "Event Name",
        hintStyle: TextStyle(
            color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    final discription = TextFormField(
      autofocus: false,
      controller: discriptionEditingcontroller,
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 5,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Description cannot be empty");
        }
      },
      onSaved: (value) {
        EventEditingcontroller.text = value!;
      },
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
        fillColor: Colors.pinkAccent[00],
        //filled: true,
        labelText: 'Description of event',
        prefixIcon: Icon(
          Icons.description,
          color: Theme.of(context).primaryColor,
        ),
        contentPadding: EdgeInsets.fromLTRB(10, 15, 20, 15),
        //hintText: "Description of event",
        hintStyle: TextStyle(
            color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
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
        fillColor: Colors.pinkAccent[00],
        //filled: true,
        labelText: 'Location of event',
        prefixIcon: Icon(
          Icons.add_location_alt,
          color: Theme.of(context).primaryColor,
        ),
        contentPadding: EdgeInsets.fromLTRB(10, 15, 20, 15),
        //hintText: "Location of event",
        hintStyle: TextStyle(
            color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
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
        hintStyle: TextStyle(
          color: Colors.indigo,
        ),
        fillColor: Color.fromARGB(255, 245, 240, 242),
        //filled: true,
        labelText: 'Select Date',
        prefixIcon: Icon(
          Icons.date_range,
          color: Colors.blueAccent,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        //hintText: "Select Date",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );

    final price = TextFormField(
      autofocus: false,
      controller: priceEditingcontroller,
      keyboardType: TextInputType.number,
      validator: (value) {
        RegExp regex = RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Price cannot be empty");
        }
      },
      onSaved: (value) {
        priceEditingcontroller.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        fillColor: Colors.indigo[00],
        //filled: true,
        labelText: " ₹ Price ",
        prefixIcon: Icon(
          Icons.account_balance_wallet,
          color: Theme.of(context).primaryColor,
        ),
        contentPadding: EdgeInsets.fromLTRB(10, 15, 20, 15),
        //hintText: " ₹ Price ",
        hintStyle: TextStyle(
            color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: loading,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 20),
                _SelectedFiles.length == 0
                    ? const Padding(
                        padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
                        child: Text(
                          "*select only one image",
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
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
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent[00]),
                    child: Text("Select Image")),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 50,
                  width: 330,
                  child: event_name,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: 330,
                  child: location,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: 330,
                  child: discription,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: 330,
                  child: price,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 50,
                  width: 330,
                  child: dateTimeField,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 40,
                  //width: 330,
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
                      icon: Icon(
                        Icons.access_time,
                        color: Colors.white,
                      ),
                      onPressed: _show,
                      label: Text(
                        _selectedTime != null ? _selectedTime! : 'Select Time',
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white),
                      )),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          elevation: 20,
                          primary: Theme.of(context).primaryColor),
                      onPressed: () async {
                        setState(() {
                          loading = true; // your loader has started to load
                        });

                        await Future.delayed(const Duration(seconds: 2), () {});

                        setState(() {
                          loading =
                              false; // your loder will stop to finish after the data fetch
                        });
                        uploadFunction(_SelectedFiles);

                        await Future.delayed(const Duration(seconds: 5), () {});

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      },
                      icon: Icon(
                        Icons.file_upload_outlined,
                      ),
                      label: Text(
                        "Upload Event",
                        style: TextStyle(fontSize: 15),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 65.0,
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                label: "Home",
                backgroundColor: Colors.black),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              label: "Profile",
            ),
            BottomNavigationBarItem(
                icon:
                    Icon(Icons.add_circle_outline_rounded, color: Colors.black),
                label: "Add Event",
                backgroundColor: Colors.black),
            BottomNavigationBarItem(
                icon: Icon(Icons.list_alt, color: Colors.black),
                label: "Lists",
                backgroundColor: Colors.black),
          ],
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.black,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            _onTap();
          },
        ),
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
                surface: Colors.pinkAccent,
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
        ..text = DateFormat("yyyy-MM-dd").format(_selectedDate!)
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
    setState(() {
      loading = true;
    });
    TaskSnapshot taskSnapshot = await uploadTask;
    url = (await taskSnapshot.ref.getDownloadURL());
    print(url);

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Party party = Party();

    party.uid = user!.uid;
    party.party_name = EventEditingcontroller.text;
    party.image = url;
    party.price = int.parse(priceEditingcontroller.text);
    party.location = locationEditingcontroller.text;
    party.discription = discriptionEditingcontroller.text;
    party.date = endDateTimeEditingController.text;
    party.time = _selectedTime!.toString();
    party.email = user!.email;

    await firebaseFirestore
        .collection("party")
        .doc(party.party_name)
        .set(party.toMap());

    count += 1;

    setState(() {
      loading = false;
    });

    print(count);

    Fluttertoast.showToast(msg: "Updated Successfully");
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
      print("List of Selected Images : " + imgs.length.toString());
    } catch (e) {
      print("Something wrong : " + e.toString());
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
