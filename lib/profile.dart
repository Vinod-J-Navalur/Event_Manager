import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_organizer/Screen/homescreen.dart';
import 'package:event_organizer/Screen/login.dart';
import 'package:event_organizer/Screen/multihost.dart';
import 'package:event_organizer/model/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class user_profile extends StatefulWidget {
  const user_profile({Key? key}) : super(key: key);

  @override
  State<user_profile> createState() => _user_profileState();
}

class _user_profileState extends State<user_profile> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  String? name;

  UserModel loggedInUser = new UserModel();

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
    FirebaseFirestore.instance
        .collection("user")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      name = loggedInUser.firstName;
      print(name);

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Center(
          child: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Event Organizer",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Race'),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 100,
                  child: Image.asset(
                    "assets/Event.png",
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.person,
                      size: 50,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: Colors.black, // Set border color
                              width: 2.0), // Set border width
                          borderRadius: BorderRadius.all(Radius.circular(
                              10.0)), // Set rounded corner radius
                          boxShadow: const [
                            BoxShadow(
                                blurRadius: 0,
                                color: Colors.black,
                                offset: Offset(1, 3))
                          ] // Make rounded corner of border
                          ),
                      child: Text(
                        "Name : ${loggedInUser.firstName}",
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.phone,
                      size: 50,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: Colors.black, // Set border color
                              width: 2.0), // Set border width
                          borderRadius: BorderRadius.all(Radius.circular(
                              10.0)), // Set rounded corner radius
                          boxShadow: const [
                            BoxShadow(
                                blurRadius: 0,
                                color: Colors.black,
                                offset: Offset(1, 3))
                          ] // Make rounded corner of border
                          ),
                      child: Text(
                        "Mobile: +91 ${loggedInUser.mobileno}",
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.mail,
                      size: 50,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: Colors.black, // Set border color
                              width: 2.0), // Set border width
                          borderRadius: BorderRadius.all(Radius.circular(
                              10.0)), // Set rounded corner radius
                          boxShadow: const [
                            BoxShadow(
                                blurRadius: 0,
                                color: Colors.black,
                                offset: Offset(1, 3))
                          ] // Make rounded corner of border
                          ),
                      child: Text(
                        "Mail : ${loggedInUser.email}",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.document_scanner,
                      size: 50,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: Colors.black, // Set border color
                              width: 2.0), // Set border width
                          borderRadius: BorderRadius.all(Radius.circular(
                              10.0)), // Set rounded corner radius
                          boxShadow: const [
                            BoxShadow(
                                blurRadius: 0,
                                color: Colors.black,
                                offset: Offset(1, 3))
                          ] // Make rounded corner of border
                          ),
                      child: Text(
                        "Aadhar : ${loggedInUser.addhar}",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 5),
                  child: SizedBox(
                    width: 300,
                    height: 65,
                    child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.party_mode_outlined),
                        label: Text("My Events")),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
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
}
