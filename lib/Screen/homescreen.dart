import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_organizer/Screen/hoted_events.dart';
import 'package:event_organizer/Screen/login.dart';
import 'package:event_organizer/Screen/multihost.dart';
import 'package:event_organizer/host/event_fetcher.dart';
import 'package:event_organizer/model/usermodel.dart';
import 'package:event_organizer/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:event_organizer/model/ui_helper.dart';
import 'package:event_organizer/model/datetime_utils.dart';
import 'package:event_organizer/constant/text_style.dart';

import '../host/Event.dart';
import 'event_detail_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Stream<QuerySnapshot> party =
      FirebaseFirestore.instance.collection('party').snapshots();

  User? user = FirebaseAuth.instance.currentUser;
  FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel loggedInUser = UserModel();

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
    const hosted(),
  ];

  String? image;

  @override
  Widget build(BuildContext context) {
    List<Evnt> event = [];
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        child: StreamBuilder<QuerySnapshot>(
            stream: party,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text('waiting');
              }

              final data = snapshot.requireData;

              return ListView.builder(
                itemCount: data.size,
                itemBuilder: (context, index) {
                  Evnt eve = Evnt(
                      party_name: data.docs[index]['party_name'],
                      image: data.docs[index]['image'],
                      location: data.docs[index]['location'],
                      discription: data.docs[index]['discription'],
                      date: data.docs[index]['date'],
                      time: data.docs[index]['time'],
                      price: 0);
                  event.add(eve);
                  return InkWell(
                      child: Card(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Container(
                              width: 80,
                              height: 100,
                              child: Image.network(
                                data.docs[index]['image'],
                                fit: BoxFit.cover,
                              ),
                            ),
                            UIHelper.horizontalSpace(8),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    DateTimeUtils.getFullDate(
                                        DateTime.parse("2001-12-12")),
                                    style: monthStyle),
                                UIHelper.verticalSpace(8),
                                Text("${data.docs[index]['party_name']}",
                                    style: titleStyle),
                                UIHelper.verticalSpace(8),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.location_on,
                                        size: 16,
                                        color: Theme.of(context).primaryColor),
                                    UIHelper.horizontalSpace(4),
                                    Text("${data.docs[index]['location']}",
                                        style: subtitleStyle),
                                  ],
                                ),
                              ],
                            ),
                          ])),
                      onTap: () {
                        print(event[index].party_name.toString());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    EventDetailPage(event[index])));
                      });
                },
              );
            }),
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
