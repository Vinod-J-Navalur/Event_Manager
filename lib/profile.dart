import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_organizer/Screen/event_detail_page.dart';
import 'package:event_organizer/Screen/homescreen.dart';
import 'package:event_organizer/Screen/hoted_events.dart';
import 'package:event_organizer/Screen/login.dart';
import 'package:event_organizer/Screen/multihost.dart';
import 'package:event_organizer/model/UserModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'Screen/hosted_event_detail.dart';
import 'constant/color.dart';
import 'constant/text_style.dart';
import 'host/Event.dart';
import 'model/datetime_utils.dart';
import 'model/ui_helper.dart';

class user_profile extends StatefulWidget {
  const user_profile({Key? key}) : super(key: key);

  @override
  State<user_profile> createState() => _user_profileState();
}

class _user_profileState extends State<user_profile> {
  final Stream<QuerySnapshot> party =
      FirebaseFirestore.instance.collection('party').snapshots();

  String? image;

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
                CircleAvatar(
                  radius: 65,
                  backgroundImage: AssetImage("assets/profile.png"),
                ),
                SizedBox(
                  height: 40,
                ),
                const SizedBox(height: 20),
                Card(
                  elevation: 20.0,
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
                const SizedBox(height: 5),
                Card(
                  elevation: 20.0,
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
                const SizedBox(height: 5),
                Card(
                  elevation: 20.0,
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
                const SizedBox(height: 5),
                Card(
                  elevation: 20.0,
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
                const SizedBox(height: 20),
                Container(
                    padding: EdgeInsets.only(top: 20),
                    height: 60.0,
                    width: 100.0,
                    child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: SingleChildScrollView(
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 16),
                                        //padding: const EdgeInsets.all(12),
                                        height: double.maxFinite,
                                        child: StreamBuilder<QuerySnapshot>(
                                            stream: party,
                                            builder: (BuildContext context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    snapshot) {
                                              if (snapshot.hasError) {
                                                return Text("Something");
                                              }
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Text('waiting');
                                              }
                                              final data = snapshot.requireData;
                                              int a = data.size;
                                              return ListView.builder(
                                                itemCount: data.size,
                                                itemBuilder: (context, index) {
                                                  image =
                                                      data.docs[index]['image'];
                                                  if (user!.uid !=
                                                      data.docs[index]['uid']) {
                                                    Evnt eve1 = Evnt(
                                                        party_name:
                                                            data.docs[index]
                                                                ['party_name'],
                                                        image: data.docs[index]
                                                            ['image'],
                                                        location:
                                                            data.docs[index]
                                                                ['location'],
                                                        discription:
                                                            data.docs[index]
                                                                ['discription'],
                                                        date: data.docs[index]
                                                            ['date'],
                                                        time: data.docs[index]
                                                            ['time'],
                                                        price: 0);
                                                    event1.add(eve1);
                                                    return Container();
                                                  }
                                                  if (user!.uid ==
                                                      data.docs[index]['uid']) {
                                                    Evnt eve2 = Evnt(
                                                        party_name:
                                                            data.docs[index]
                                                                ['party_name'],
                                                        image: data.docs[index]
                                                            ['image'],
                                                        location:
                                                            data.docs[index]
                                                                ['location'],
                                                        discription:
                                                            data.docs[index]
                                                                ['discription'],
                                                        date: data.docs[index]
                                                            ['date'],
                                                        time: data.docs[index]
                                                            ['time'],
                                                        price: 0);
                                                    event1.add(eve2);
                                                  }

                                                  return InkWell(
                                                      child: Card(
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16),
                                                              child: Container(
                                                                color: imgBG,
                                                                width: 80,
                                                                height: 100,
                                                                child: Image
                                                                    .network(
                                                                  image
                                                                      .toString(),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                            UIHelper
                                                                .horizontalSpace(
                                                                    8),
                                                            Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  UIHelper
                                                                      .verticalSpace(
                                                                          8),
                                                                  Text(
                                                                      DateTimeUtils.getFullDate(
                                                                          DateTime.parse(
                                                                              "2001-06-28")),
                                                                      style:
                                                                          monthStyle),
                                                                  UIHelper
                                                                      .verticalSpace(
                                                                          8),
                                                                  Text(
                                                                      "${data.docs[index]['party_name']}",
                                                                      style:
                                                                          titleStyle),
                                                                  UIHelper
                                                                      .verticalSpace(
                                                                          8),
                                                                  Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Icon(
                                                                          Icons
                                                                              .location_on,
                                                                          size:
                                                                              16,
                                                                          color:
                                                                              Theme.of(context).primaryColor),
                                                                      UIHelper
                                                                          .horizontalSpace(
                                                                              4),
                                                                      Text(
                                                                          "${data.docs[index]['location']}"
                                                                              .toString()
                                                                              .toUpperCase(),
                                                                          style:
                                                                              subtitleStyle),
                                                                    ],
                                                                  ),
                                                                ]),
                                                          ])),
                                                      onTap: () {
                                                        print(index);
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    EventDetailPage(
                                                                        event1[
                                                                            index])));
                                                      });
                                                },
                                              );
                                            }),
                                      ),
                                    ),
                                  ));
                        },
                        child: Text('My Events'))),
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
                icon: Icon(Icons.add_circle_outline_rounded,
                    color: Colors.deepPurple),
                label: "Add Event",
                backgroundColor: Colors.black),
            BottomNavigationBarItem(
                icon: Icon(Icons.list_alt, color: Colors.black),
                label: "Lists",
                backgroundColor: Colors.black),
            BottomNavigationBarItem(
                icon: Icon(Icons.logout, color: Colors.black),
                label: "Logout",
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
}
