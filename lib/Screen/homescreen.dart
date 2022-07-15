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
import 'package:event_organizer/utils/app_utils.dart';
import 'package:event_organizer/constant/color.dart';

import '../host/Event.dart';
import 'event_detail_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final Stream<QuerySnapshot> party = FirebaseFirestore.instance
      .collection('party')
      .orderBy('date', descending: true)
      .snapshots();

  late ScrollController scrollController;
  late AnimationController controller;
  late AnimationController opacityController;
  late Animation<double> opacity;

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

  void initState() {
    scrollController = ScrollController();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..forward();
    opacityController = AnimationController(
        vsync: this, duration: const Duration(microseconds: 1));
    opacity = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
      curve: Curves.linear,
      parent: opacityController,
    ));
    scrollController.addListener(() {
      opacityController.value = offsetToOpacity(
          currentOffset: scrollController.offset,
          maxOffset: scrollController.position.maxScrollExtent / 2);
    });
    super.initState();
  }

  void dispose() {
    controller.dispose();
    scrollController.dispose();
    opacityController.dispose();
    super.dispose();
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
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
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
                shrinkWrap: true,
                primary: false,
                itemCount: data.size,
                itemBuilder: (context, index) {
                  var animation = Tween<double>(begin: 800.0, end: 0.0).animate(
                    CurvedAnimation(
                      parent: controller,
                      curve: Interval((1 / data.docs.length) * index, 1.0,
                          curve: Curves.decelerate),
                    ),
                  );
                  Evnt eve = Evnt(
                      uid: data.docs[index]['uid'],
                      email: data.docs[index]['email'],
                      party_name: data.docs[index]['party_name'],
                      image: data.docs[index]['image'],
                      location: data.docs[index]['location'],
                      discription: data.docs[index]['discription'],
                      date: data.docs[index]['date'],
                      time: data.docs[index]['time'],
                      price: data.docs[index]['index']);
                  event.add(eve);
                  return InkWell(
                      child: Card(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                color: imgBG,
                                width: 80,
                                height: 100,
                                child: Image.network(
                                  data.docs[index]['image'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            UIHelper.horizontalSpace(8),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                UIHelper.verticalSpace(8),
                                Text(
                                    DateTimeUtils.getFullDate(DateTime.parse(
                                        "${data.docs[index]['date']}")),
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
                                    Text(
                                        "${data.docs[index]['location']}"
                                            .toString()
                                            .toUpperCase(),
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
                icon:
                    Icon(Icons.add_circle_outline_rounded, color: Colors.black),
                label: "Add Event",
                backgroundColor: Colors.black),
            BottomNavigationBarItem(
                icon: Icon(Icons.list_alt, color: Colors.black),
                label: "Lists",
                backgroundColor: Colors.black),
          ],
          //currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          //selectedItemColor: Theme.of(context).primaryColor,
          //unselectedItemColor: Colors.black,
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
