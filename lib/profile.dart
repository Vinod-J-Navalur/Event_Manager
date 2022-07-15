import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_organizer/Screen/MyEvent.dart';
import 'package:event_organizer/Screen/event_detail_page.dart';
import 'package:event_organizer/Screen/homescreen.dart';
import 'package:event_organizer/Screen/hoted_events.dart';
import 'package:event_organizer/Screen/login.dart';
import 'package:event_organizer/Screen/multihost.dart';
import 'package:event_organizer/model/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'Screen/hosted_event_detail.dart';
import 'constant/color.dart';
import 'constant/text_style.dart';
import 'host/Event.dart';
import 'model/datetime_utils.dart';
import 'model/ui_helper.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}

class user_profile extends StatefulWidget {
  const user_profile({Key? key}) : super(key: key);

  @override
  State<user_profile> createState() => _user_profileState();
}

class _user_profileState extends State<user_profile> {
  final Stream<QuerySnapshot> party =
      FirebaseFirestore.instance.collection('party').snapshots();
  final Stream<QuerySnapshot> user1 =
      FirebaseFirestore.instance.collection('user').snapshots();

  String? image;

  List<String> strs = [];
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
    const hosted()
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

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Evnt> event1 = [];
    return Scaffold(
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
                SizedBox(
                  height: 40,
                ),
                CircleAvatar(
                  radius: 65,
                  backgroundImage: AssetImage("assets/profile.png"),
                ),
                SizedBox(
                  height: 20,
                ),
                //const SizedBox(height: 20),
                Card(
                  elevation: 5.0,
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      "${loggedInUser.firstName}",
                      style: TextStyle(
                          color: Colors.teal[900],
                          fontFamily: 'SourceSans',
                          fontSize: 20.0),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.deepPurple,
                ),
                //const SizedBox(height: 5),
                Card(
                  elevation: 5.0,
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.phone_android,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      "+91 ${loggedInUser.mobileno}",
                      style: TextStyle(
                          color: Colors.teal[900],
                          fontFamily: 'SourceSans',
                          fontSize: 20.0),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.deepPurple,
                ),
                //const SizedBox(height: 5),
                Card(
                  elevation: 5.0,
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.mail,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      "${loggedInUser.email}",
                      style: TextStyle(
                          color: Colors.teal[900],
                          fontFamily: 'SourceSans',
                          fontSize: 20.0),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.deepPurple,
                ),
                //const SizedBox(height: 5),
                Card(
                  elevation: 5.0,
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.document_scanner,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(
                      "Aadhar: ${loggedInUser.addhar}",
                      style: TextStyle(
                          color: Colors.teal[900],
                          fontFamily: 'SourceSans',
                          fontSize: 20.0),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.deepPurple,
                ),

                //const SizedBox(height: 20),
                Container(
                    margin: EdgeInsets.only(top: 30),
                    //width: 100.0,
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          height: 60.0,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 20,
                              shape: const StadiumBorder(),
                              primary: Theme.of(context).primaryColor,
                            ),
                            onPressed: () {
                              SizedBox(
                                height: 100.0,
                              );
                              int count = 0;
                              showDialog(
                                  context: context,
                                  builder: (_) => eventinfo(0));
                              //print(strs);
                            },
                            child: Text(
                              "My Events",
                              style: titleStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100.0,
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 10),
                          height: 60.0,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 20,
                                shape: const StadiumBorder(),
                                primary: Colors.white,
                              ),
                              onPressed: () {
                                _signOut();
                                Navigator.of(context).pushAndRemoveUntil(
                                  CupertinoPageRoute(
                                      builder: (context) => loginscreen()),
                                  (_) => false,
                                );
                              },
                              child: Text("  Log Out  ",
                                  style: titleStyle.copyWith(
                                      color: Colors.blue,
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal))),
                        )
                      ],
                    )),
              ],
            ),
          ),
        ),
      )),
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

  Widget eventinfo(int count) {
    List<dynamic> guests = [];
    int ind = -1;
    //print("reached");
    return Container(
      padding: EdgeInsets.all(20.0),
      margin: EdgeInsets.only(top: 100.0),
      child: StreamBuilder<QuerySnapshot>(
          stream: user1,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('waiting');
            }
            final data = snapshot.requireData;

            if (true) {
              Card(
                child: Text('event'),
              );
            }
            return ListView.builder(
                itemCount: data.size,
                itemBuilder: (context, index) {
                  if (count <= 1 && data.docs[index]['uid'] == user!.uid) {
                    guests = data.docs[index]['party_name'];
                    count += 1;
                    ind = -1;
                  }

                  strs = guests.map((e) => e.toString()).toList();

                  if (index == data.size - 1 && strs.isEmpty) {
                    return AlertDialog(
                      title: Text('Oops !'),
                      content: Text('You haven\'t Booked Any Event'),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            },
                            child: Text('Book'))
                      ],
                    );
                  }

                  //print(strs);
                  //print(count);
                  if (count == 1) {
                    count += 1;
                    return eve(strs);
                  }

                  print(count);

                  return SizedBox.shrink();
                });
          }),
    );
  }

  Widget eve(List<String> eves) {
    print(strs);
    return Column(children: [
      ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          itemCount: eves.length,
          itemBuilder: (BuildContext context, int index) {
            return SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Container(
                      child: Card(
                        elevation: 5.0,
                        color: Colors.white,
                        child: ListTile(
                          leading: Icon(
                            Icons.event,
                            //color: Theme.of(context).primaryColor,
                          ),
                          title: Text(
                            ('Event ' +
                                (index + 1).toString() +
                                ':  ' +
                                eves[index]),
                            style: titleStyle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
            ;
          }),
    ]);
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
